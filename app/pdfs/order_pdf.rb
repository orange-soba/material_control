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
  end
end