class OrderPdf < Prawn::Document
  def initialize
    super(page_size: 'A4')

    font 'app/assets/fonts/ipaexm.ttf'
  end
end