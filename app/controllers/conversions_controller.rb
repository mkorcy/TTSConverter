class ConversionsController < ApplicationController
  def new
  	@conversion = Conversion.new
  end
end
