class OrderPdf < Prawn::Document
  def initialize
    super(page_size: 'A4')
    stroke_axis
    
    font 'app/assets/fonts/ipaexm.ttf'

    #-------- 以下出力文章 ----------

    # タイトル
    text '発注書', size: 20, align: :center
    move_down 20

    # ページ数
    draw_text '1/1', at: [500, 760]

    # 発注先
    order_to = [['(株)テスト機械器具', '御中']]
    table order_to, column_widths: [150, 35] do
      cells.borders = [:bottom]
      cells.height = 30
      columns(1).size = 10
    end

    # 発注元
    bounding_box([320, 720], width: 200) do
      rounded_rectangle([0, cursor], 200, 110, 5) 
      text_box '発注元: ', at: [5, cursor - 5], size: 10
      move_down 15
      text_box '株式会社テスト', at: [5, cursor - 5], size: 13
      move_down 18
      stroke do
        line [5, 0], [100, 0]
      end
      order_from_address = [['〒000-0000'], ['東京都品川区1-1'], ['テストビルディング 2階'], ['Tell: 012-345-6789']]
      table order_from_address, cell_style: { borders: [], size: 10, height: 19 }
    end

    # 発注内容
    move_cursor_to 600
    order_details = [['発注内容', '個数(ヶ)', 'その他']]
    (0..16).each do
      order_details << ['', '', '']
    end
    demo_data = [['モーター', 2, ''], ['減速機', 1, ''], ['#35 防錆油 チェーン 2m', 5, '']]
    demo_data.each_with_index do |data, index|
      order_details[index + 1][0] = data[0]
      order_details[index + 1][1] = data[1]
      order_details[index + 1][2] = data[2]
    end
    p order_details
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