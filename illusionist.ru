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
	            
                #come up with rewrite file name
                file_name = env["REQUEST_PATH"].split('.').first
                extension = env["REQUEST_PATH"].split('.').last
	            illusion = "#{Dir.pwd}/illusions/#{file_name}_r#{width}x#{height}.#{extension}"
	            #create the illusion if nessicary
	            Image.read(full_path).first().scale(width, height).write(illusion) unless File.exists?(illusion)
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