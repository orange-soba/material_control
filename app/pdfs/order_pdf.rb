class OrderPdf < Prawn::Document
  def initialize
    super(
      page_size: 'A4',
      top_margin: 40,
      bottom_margin: 30,
      left_margin: 20,
      right_margin: 20
    )

    font 'app/assets/fonts/ipaexg.ttf'
  end
end