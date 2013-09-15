require 'RMagick' 
require 'Illusion'

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
				illusion = Illusion.new query_hash, env, full_path
				
				#create the illusion if nessicary
				unless illusion.exists?
					#write the illusion
					illusion.write_resized_image
				end
				
				#reate the file
				self.body = illusion.read
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