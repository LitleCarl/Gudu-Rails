# encoding: utf-8

module Concerns::Query

  # 公共方法
  module Methods
    extend ActiveSupport::Concern

    # 动态定义类方法
    included do
      #
      # 根据当前类的属性定义单个查询方法
      #
      # @example
      #   Hospital.query_first_by_id(2)
      #   => Hospital Load (0.5ms)  SELECT  `hospitals`.* FROM `hospitals` WHERE (`hospitals`.`deleted_at` IS NULL) AND
      #     `hospitals`.`id` = 2  ORDER BY `hospitals`.`id` ASC LIMIT 1
      #
      # @return [self.class, nil] 返回
      #
      self.attribute_names.each do |attr|
        define_singleton_method("query_first_by_#{attr}") do |arg|
          query_first_by_options(attr.to_sym => arg)
        end
      end
    end

    # 类方法
    module ClassMethods
      #
      # 根据多个条件查询单个对象
      #
      # @param options [Hash] @see #query_by_options
      #
      # @return [self.class, nil] 返回
      #
      def query_first_by_options(options = {})
        query_by_options(options).first
      end

      #
      # 根据多个条件查询并分页
      #
      # @param options [Hash] @see #query_by_options
      #
      # @return [ActiveRecord::Relation] 返回
      #
      def query_and_paginate_by_options(options = {})
        query_by_options(options).page(options[:page].presence || 1).per(options[:per])
      end

      #
      # 通用查询方法
      #
      # @note
      #   1.根据属性名称精准匹配
      #   2.根据 like_属性名 模糊匹配
      #   3.通用查询无法满足的情况下 可在使用的模型中 override 该方法
      #     第一行应使用 xxx = super(options) 先继承通用的查询方法
      #
      # @example
      #   Hospital.query_by_options(id: 1, cn_name: 'aa')
      #     => Hospital Load (0.6ms)  SELECT `hospitals`.* FROM `hospitals` WHERE (`hospitals`.`deleted_at` IS NULL) AND
      #       `hospitals`.`id` = 1 AND `hospitals`.`cn_name` = 'aa'
      #
      #   Hospital.query_by_options(id: 1, like_cn_name: 'aa')
      #     => Hospital Load (0.8ms)  SELECT `hospitals`.* FROM `hospitals` WHERE (`hospitals`.`deleted_at` IS NULL) AND
      #       `hospitals`.`id` = 1 AND (hospitals.cn_name like '%aa%')
      #
      # @param options [Hash] 查询参数 不同的模型拥有不同的属性
      #
      # @return [ActiveRecord::Relation] 返回
      #
      def query_by_options(options = {})
        result = self.all

        if options.present?
          keys = options.keys

          keys.each do |key|
            if options[key].present?
              result = result.where(key.to_sym => options[key]) if self.attribute_method?(key)

              if key.to_s.include?('like_')
                attr_key = key.to_s.gsub('like_', '')

                result = result.where("#{self.name.tableize}.#{attr_key} like ?", "%#{options[key]}%") if self.attribute_method?(attr_key)
              end
            end
          end
        else
          result = result.page(1)
        end

        result
      end
    end
  end

end
