class ConversionsController < ApplicationController

  def show
  	@conversion = Conversion.find(params[:id])
  end

  def new
  	@conversion = Conversion.new
  end

  def create
  	@conversion = Conversion.new(conversion_params)
  	if @conversion.save
  		redirect_to @conversion
  	else
  		render 'new'
  	end
  end

  private

	  def conversion_params
	  	params.require(:conversion).permit(:title, :author, :pid, 
	  									   :recording, :description, :file)
	  end

end


