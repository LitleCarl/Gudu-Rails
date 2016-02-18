# encoding: utf-8

module Concerns::Management::Api::V1::ProductConcern

  extend ActiveSupport::Concern

  included do
    # 通用查询方法
    include Concerns::Query::Methods
  end

  module ClassMethods

    # 管理者查询管理校区内某商铺的某商品
    #
    # @param options [Hash]
    # @option options [Manager] :manager 关联管理者
    # @option options [String] :store_id 商铺id
    # @option options [String] :id 商品id
    #
    # @return [Array] response, store, product
    #
    def query_product_for_management(options = {})
      product = nil
      store = nil

      catch_proc = proc{
        product = nil
        store = nil
      }

      response = ResponseStatus.__rescue__(catch_proc) do |res|

        manager, id, store_id = options[:manager], options[:id], options[:store_id]

        res.__raise__(ResponseStatus::Code::ERROR, '参数错误') if manager.blank? || store_id.blank? || id.blank?

        res.__raise__(ResponseStatus::Code::ERROR, '您没有管辖校区') if manager.campus.blank?

        store = manager.campus.stores.where(id: store_id).first

        res.__raise__(ResponseStatus::Code::ERROR, '不存在店铺或不再管辖范围内') if store.blank?

        product = store.products.where(id: id).first

        res.__raise__(ResponseStatus::Code::ERROR, '商品不存在') if product.blank?

      end

      return response, store, product
    end

    # 管理者查询该店铺的商品
    #
    # @param options [Hash]
    # @option options [Manager] :manager 关联管理者
    # @option options [Status] :status 状态(可选)
    # @option options [String] :store_id 商铺id
    # @option options [Integer] :page 状态(可选)
    # @option options [Integer] :limit 状态(可选)
    #
    # @return [Array] response, stores
    #
    def query_store_products_for_management(options = {})
      products = []
      store = nil

      catch_proc = proc{
        products = []
        store = nil
      }

      response = ResponseStatus.__rescue__(catch_proc) do |res|

        manager, status, category, store_id = options[:manager], options[:status], options[:category], options[:store_id]

        res.__raise__(ResponseStatus::Code::ERROR, '参数错误') if manager.blank? || store_id.blank?

        res.__raise__(ResponseStatus::Code::ERROR, '您没有管辖校区') if manager.campus.blank?

        store = manager.campus.stores.where(id: store_id).first

        res.__raise__(ResponseStatus::Code::ERROR, '不存在店铺或不再管辖范围内') if store.blank?

        products = store.products

        products = products.where(status: status) if status.present?
        products = products.where(category: category) if category.present?

        products = products.order('id desc').paginate(options)
      end

      return response, store, products
    end

    # 管理者为该学校该店铺添加或更新商品
    #
    # @param options [Hash]
    # @option options [Manager] :manager 关联管理者
    # @option options [String] :store_id 商铺id
    # @option options [Integer] :id 商品id(可选,更新时传)
    # @option options [Hash] :product 商品信息json
    #
    # @return [Array] response, store, product
    #
    def create_or_update_product_for_management(options = {})
      product = nil
      store = nil

      catch_proc = proc{
        product = nil
        store = nil
      }

      response = ResponseStatus.__rescue__(catch_proc) do |res|

        transaction do
          manager, id, store_id, product_json, product_image_ids, new_images, specification_name, specification_values, specification_prices, specification_ids_to_keep = options[:manager], options[:id], options[:store_id], options[:product], options[:product_image_ids], options[:new_images], options[:specification_name], options[:specification_values], options[:specification_prices], options[:specification_ids_to_keep]

          res.__raise__(ResponseStatus::Code::ERROR, '参数错误') if manager.blank? || store_id.blank? || product_json.blank? || specification_name.blank? || specification_values.blank? || specification_prices.blank?

          # 剔除空元素
          specification_values = specification_values.reject(&:blank?)
          specification_prices = specification_prices.reject(&:blank?)

          res.__raise__(ResponseStatus::Code::ERROR, '规格value和price数量不一致') if specification_values.count != specification_prices.count



          res.__raise__(ResponseStatus::Code::ERROR, '您没有管辖校区') if manager.campus.blank?

          store = manager.campus.stores.where(id: store_id).first

          res.__raise__(ResponseStatus::Code::ERROR, '不存在店铺或不再管辖范围内') if store.blank?

          is_create = false
          if id.present?
            product = store.products.where(id: id).first

            res.__raise__(ResponseStatus::Code::ERROR, '商品不存在') if product.blank?
          else
            is_create = true

            product = Product.new
            
            product.store = store
          end

          product.name = product_json[:name] if product_json[:name].present?
          product.brief = product_json[:brief] if product_json[:brief].present?
          product.category = product_json[:category] if product_json[:category].present?
          product.status = product_json[:status] if product_json[:status].present?
          product.logo_filename = product_json[:logo_filename] if product_json[:logo_filename].present?

          # 删除不需要的图片
          if product_image_ids.present?
            product.product_images.where.not(id: product_image_ids).destroy_all
          else
            product.product_images.destroy_all
          end

          # 新图片添加
          new_images.each do|image_uploaded|
            pi = ProductImage.new
            pi.product = product
            pi.image_name = image_uploaded

            pi.save!
          end if new_images.present?

          product.save!

          # 处理规格
          # 下架不需要的的规格
          product.specifications.where.not(name: specification_name).update_all(status: Specification::Status::Pending)

          # 下架删除的规格
          if specification_ids_to_keep.blank?
            product.specifications.update_all(status: Specification::Status::Pending)
          else
            product.specifications.where.not(id: specification_ids_to_keep).update_all(status: Specification::Status::Pending)
          end

          # 添加新的规格
          if specification_prices.present?
            specification_prices.each_with_index do |price, index|
              spe_options = {
                  specification_name: specification_name,
                  specification_value: specification_values[index],
                  product: product,
                  price: price
              }

              inner_response, specification = Specification.create_with_options(spe_options)

              # 有必要抛出内部错误
              res.__raise__response__(inner_response)

              # 保存规格
              specification.save!
            end
          end

        end

      end

      return response, store, product
    end

  end

end
