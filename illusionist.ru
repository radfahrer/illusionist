require 'RMagick'
#include Magick

class Illusionist
	include Magick
    attr_accessor :response_code, :headers, :body
  
    def initialize
	    @response_code = 200
    end
  
    def call(env) 
	    full_path = Dir.pwd + env["REQUEST_PATH"] 
	    if File.exist? full_path
	        self.response_code = 200
	        content_type = `file -Ib #{full_path}`.gsub(/\n/,"")
	        self.headers = {"Content-Type" => content_type}
	        
	        #parse query string
	        query_hash = Hash[*env['QUERY_STRING'].split(/[&=]/)]

	        #check for resize commands
	        if(query_hash.has_key?('w') || query_hash.has_key?('width'))
	            #determine width and height
	            width = (query_hash['width'] ||= query_hash['w']).to_i
	            height = (query_hash['height'] ||= query_hash['h'] ||= width).to_i
	            #check resize mode, default to pad
	            mode = (query_hash['mode'] ||= 'pad')
                
                #come up with rewrite file name
                file_name = env["REQUEST_PATH"].split('.').first
                extension = env["REQUEST_PATH"].split('.').last
	            illusion = "#{Dir.pwd}/illusions/#{file_name}_r#{width}x#{height}_#{mode}.#{extension}"
	            
	            
                
	            #create the illusion if nessicary
	            unless File.exists?(illusion)
	                #choose a resize function 
    	            resize_function =  case mode
                        when 'max'      then :resize_to_fit
                        when 'pad'      then :pad
                        when 'crop' then :resize_to_fill
                        when 'stretch'  then :scale
                        else :resize_to_fill
                    end
                    
                    #call the appropriate function
                    if resize_function == :pad #one of these things is not like the others
                        source = Image.read(full_path).first().resize_to_fit!(width, height)
                        target = Image.new(width, height) do
                          self.background_color = 'white'
                        end
                        target.composite(source, CenterGravity, AtopCompositeOp).write(illusion)
                    else
                        Image.read(full_path).first().send(resize_function, width, height).write(illusion)
                    end	                
                end
                
                #reate the file
                self.body = File.new(illusion)
	        else
	            self.body = File.new(full_path)
	        end
	    else
	        self.response_code = 404
	        self.headers = {"Content-Type" => "text/plain"}
	        self.body = ["#{env.inspect}"]
	    end
	    [self.response_code, self.headers, self.body]
  end
  
end

run Illusionist.new