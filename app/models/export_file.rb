module ExportFile

  ######################################################################################################################
  #
  # 电子表格初始化
  #
  # 定义表头格式
  def self.init_header_format(options = {} )
    header_format = Spreadsheet::Format.new(
        :color => :white, #white,
        :weight => :bold,
        :size => 14,
        :align => :left,
        :vertical_align => :center,
        # :border_color=>:builtin_black,
        # :border=>:thin,
        # :bottom_color=>:builtin_black, :top_color=>:builtin_black, :left_color=>:builtin_black, :right_color=>:builtin_black,
        :diagonal_color=>:builtin_black,
        :pattern=>1,
        :pattern_fg_color=>:green,
        :pattern_bg_color=>:white

    # :left=>:none, :right=>:none, :top=>:none, :bottom=>:none,
    )

    header_format
  end

  # 定义主体格式
  def self.init_body_format(options = {} )
    body_format = Spreadsheet::Format.new(
        :color => :gray,
        :size => 13,
        :align=>'left',
        :vertical_align=>:center,
        :align => 'justify'
    #:border=>:thin,
    #:border_color =>'white'
    #:bottom_color=>:builtin_black, :top_color=>:builtin_black, :left_color=>:builtin_black, :right_color=>:builtin_black,
    #:diagonal_color=>:builtin_black,
    #:pattern=>1,
    #:pattern_fg_color=>:black,
    #:pattern_bg_color=>:white,
    #:left=>:none, :right=>:none, :top=>:none, :bottom=>:none,
    )

    body_format
  end

  # 定义表尾格式
  def self.init_last_row_format(options = {} )
    last_row_format = Spreadsheet::Format.new(
        :color => :white, #white,
        :weight => :bold,
        :size => 16,
        :align  =>:left,
        :vertical_align => :center,
        # :border_color=>:builtin_black,
        # :border=>:thin,
        # :bottom_color=>:builtin_black, :top_color=>:builtin_black, :left_color=>:builtin_black, :right_color=>:builtin_black,
        :diagonal_color=>:builtin_black,
        :pattern=>1,
        :pattern_fg_color=>:red,
        :pattern_bg_color=>:white
    # :left=>:none, :right=>:none, :top=>:none, :bottom=>:none,
    )

    last_row_format
  end

  #
  # 导出当日订单列表
  #
  # @param orders [ActiveRecord::Relation] 订单列表
  # @param file_path [String] 文件地址
  #
  # @return [String] 导出回收记录excel
  #
  def self.export_excel_for_order(orders, file_path)
    book = Spreadsheet::Workbook.new

    sheet = book.create_worksheet :name => "当日订单报表_#{Time.now.strftime('%Y%m%d')}"

    build_order_excel_for_today(orders, sheet)

    book.write file_path
  end

  #
  # @return [Spreadsheet::Worksheet] 返回的电子表格
  #
  def self.build_order_excel_for_today(orders, sheet)
    header_format = init_header_format

    headers = %w{订单号 用户名 收货人 收货电话 订单总价 实际付款 订单详情}

    sheet.row(0).concat headers

    0.upto(headers.size - 1) {|column| sheet.row(0).set_format(column, header_format)}

    # 设置高度
    sheet.row(0).height = 25

    # 设置宽度
    sheet.column(0).width = 8

    1.upto(headers.size - 1) {|column| sheet.column(column).width = 25}
    sheet.column(headers.size - 1).width = 100

    body_format = init_body_format

    orders.each_with_index do |order, i|

      i = i + 1

      sheet[i, 0] = i# 序号

      sheet[i, 1] = order.user.try(:phone) || '' # 用户名
      sheet[i, 2] = order.try(:receiver_name) || '' # 收货人
      sheet[i, 3] = order.try(:receiver_phone) # 收货电话
      sheet[i, 4] = order.try(:price) || '' # 订单总价
      sheet[i, 5] = order.try(:pay_price) || ''# 实际付款

      detail = ''

      order.order_items.each do |order_item|
        detail.concat("#{order_item.quantity}份#{order_item.product.name}(#{order_item.specification.name}:#{order_item.specification.value}),")
      end

      detail = detail[0..detail.length-2] if detail.length > 2

      sheet[i, 6] = detail # 订单详情

      sheet.row(i).default_format = body_format
    end
    sheet
  end

end
