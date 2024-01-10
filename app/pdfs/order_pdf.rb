class OrderPdf < Prawn::Document
  def initialize
    super(page_size: 'A4')
    stroke_axis
    
    font 'app/assets/fonts/ipaexm.ttf'
  end
end