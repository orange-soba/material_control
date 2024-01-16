class OrderPdfsController < ApplicationController
  def index
    respond_to do |format|
      format.pdf do
        order_pdf = OrderPdf.new(params[:orders]).render
        send_data order_pdf,
          filename: 'order.pdf',
          type: 'application/pdf',
          disposition: 'inline'
      end
    end
  end
end
