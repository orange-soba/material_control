class OrderPdf < Prawn::Document
  def initialize(orders, user)
    super(page_size: 'A4')
    stroke_axis
    
    font 'app/assets/fonts/ipaexm.ttf'

    # parts_order = orders[:parts].flatten.each_slice(2).to_a
    order_destination = orders.keys[1]
    parts_order = orders[order_destination].flatten.each_slice(2).to_a
    # materials_order = orders[:materials].flatten.each_slice(2).to_a

    #-------- 以下出力文章 ----------

    # タイトル
    title

    move_down 20

    # ページ数
    count_page(1, 1)

    # 発注先
    order_destinate(order_destination)

    # 発注元
    order_source(user)

    move_cursor_to 600

    # 発注内容
    order_contents(parts_order)

    # 発注日
    order_date
  end

  def title
    text '発注書', size: 20, align: :center
  end

  def count_page(now, sum)
    draw_text "#{now}/#{sum}", at: [500, 760]
  end

  def order_destinate(order_destination)
    order_to = [[order_destination, '御中']]
    table order_to, column_widths: [150, 35] do
      cells.borders = [:bottom]
      cells.height = 30
      columns(1).size = 10
    end
  end

  def order_source(user)
    bounding_box([320, 720], width: 200) do
      rounded_rectangle([0, cursor], 200, 110, 5) 
      text_box '発注元: ', at: [5, cursor - 5], size: 10
      move_down 15
      text_box user.name, at: [5, cursor - 5], size: 13
      move_down 18
      stroke do
        line [5, 0], [100, 0]
      end
      order_address = [[user.post_code], [user.prefecture.name + user.city + user.house_number], [user.building], ["Tell: #{user.phone_number}"]]
      table order_address, cell_style: { borders: [], size: 10, height: 19 }
    end
  end

  def order_date
    today = Date.today.strftime('%Y/%m/%d')
    bounding_box([0, 620], width: 130) do
      text "発注日: #{today}"
    end
  end

  def order_contents(parts_order)
    order_details = [['発注内容', '個数(ヶ)', 'その他']]
    (0..17).each do |index|
      if index < parts_order.length
        order_details << [parts_order[index][0], parts_order[index][1], '']
      else
        order_details << ['', '', '']
      end
    end
    # demo_data = [['モーター', 2, ''], ['減速機', 1, ''], ['#35 防錆油 チェーン 2m', 5, '']]
    # demo_data.each_with_index do |data, index|
    #   order_details[index + 1][0] = data[0]
    #   order_details[index + 1][1] = data[1]
    #   order_details[index + 1][2] = data[2]
    # end
    table order_details, cell_style: { height: 30 }, column_widths: [400, 60, 60] do
      row(0).align = :center
      columns(1).align = :center
      row(0).height = 25
      row(0).border_bottom_width = 2
      row(0).border_top_width = 2
      row(-1).border_bottom_width = 2
      columns(0).border_left_width = 2
      columns(0).border_right_width = 2
      columns(1).border_right_width = 2
      columns(2).border_right_width  =2
    end
  end
end