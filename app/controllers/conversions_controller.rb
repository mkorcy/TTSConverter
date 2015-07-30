require 'srt'
require 'nokogiri'
require './template.rb'

class ConversionsController < ApplicationController

  def show
  	@conversion = Conversion.find(params[:id])
  end

  def new
  	@conversion = Conversion.new
  end

  def create
    
    @conversion = Conversion.new(conversion_params)

    #read contents of uploaded file
    file_contents = params[:conversion][:file].tempfile.read

    #write contents of uploaded file to rails app default srt file
    #this write command overwrites any content already in default file
    File.open("defaultsrt.srt", "wb+") do |f|
      f.write(file_contents)
    end

    #execute conversion script from default srt file to default xml file
    %x(ruby convert_srt_to_tei.rb defaultsrt.srt defaultxml.xml)

    ##########
    #add in author and all that jazz in here


    ##########

    #read contents of converted file
    converted_contents = File.read("defaultxml.xml")

  	if @conversion.save
      #deliver converted contents to file download
      send_data converted_contents, :filename => 'writeto.xml'
  		#render "static_pages/home"
      #redirect_to @conversion
  	else
  		render 'new'
  	end
  end

  private

    def trialmethod(name)
      name = 'Alexander'
    end

	  def conversion_params
	  	params.require(:conversion).permit(:title, :author, :pid, 
	  									   :recording, :description, :file)
	  end

    def edit
      @conversion = Conversion.find(params[:id])
    end

end


