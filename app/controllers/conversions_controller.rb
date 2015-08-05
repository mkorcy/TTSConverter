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

    #####IN PROGRESS, trying to get cielo script to work
    if file_contents[0] == "["
      File.open("defaultcielo.txt", "wb+") do |f|
        f.write(file_contents)
      end
      %x(ruby preprocess_srt.rb defaultcielo.txt defaultsrt.srt)
    end
    #######

    #execute conversion script from default srt file to default xml file
    %x(ruby convert_srt_to_tei.rb defaultsrt.srt defaultxml.xml)

    ########## MAKE ALL THESE INTO HELPER FUNCTION
    #all this Nokogiri stuff adds the user inputted form items into the xml doc  
    @doc = Nokogiri::XML(File.open("defaultxml.xml"))

    #insert title
    title = @doc.at_css "title"
    title.content = params[:conversion][:title]
    puts title.content
    File.write("defaultxml.xml", @doc.to_xml)
    
    #insert author name
    author = @doc.at_css "author"
    author.content = params[:conversion][:author]
    puts author.content
    File.write("defaultxml.xml", @doc.to_xml)

    #insert pid 
    pid = @doc.at_css "idno"
    pid.content = params[:conversion][:pid]
    puts pid.content
    File.write("defaultxml.xml", @doc.to_xml)

    #THIS NEEDS TO BE FIXED, IT OVERWRITES <p> ELEMENT
    #insert recording details
    recording = @doc.at_css "equipment"
    recording.content = params[:conversion][:recording]
    puts recording.content
    File.write("defaultxml.xml", @doc.to_xml)

    #insert description
    description = @doc.at_css "resp"
    description.content = params[:conversion][:description]
    puts description.content
    File.write("defaultxml.xml", @doc.to_xml)
    ##########

    #read contents of converted file
    converted_contents = File.read("defaultxml.xml")

  	if @conversion.save
      #deliver converted contents to file download
      send_data converted_contents, :filename => 'ConversionResults.xml'
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


