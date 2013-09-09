class Illusion
	attr_accessor :width, :height, :mode, :extension
	
	def initialize(query_hash)
		#determine width and height
		self.width = (query_hash['width'] ||= query_hash['w']).to_i
		self.height = (query_hash['height'] ||= query_hash['h'] ||= width).to_i
		#check resize mode, default to pad
		self.mode = (query_hash['mode'] ||= 'pad')
		
		#come up with rewrite file name
		self.base_name = env["REQUEST_PATH"].split('.').first
		self.extension = env["REQUEST_PATH"].split('.').last
	end
	
	def file_name
		"#{file_name}_r#{width}x#{height}_#{mode}.#{extension}"
	end
	
	def path
		"#{Dir.pwd}/illusions/#{self.file_name}"
	end
	
	def exists?
		File.exists? self.path
	end
	
	def read
		File.new self.path
	end
	
	def resize_function
		case self.mode
			when 'max'	  then :resize_to_fit
			when 'pad'	  then :pad
			when 'crop'	  then :resize_to_fill
			when 'stretch'  then :scale
			else :resize_to_fill
		end
	end
	
	def write_resized_image
		if self,resize_function == :pad #one of these things is not like the others
			source = Image.read(full_path).first().resize_to_fit!(width, height)
			#select the appropriate background color
			background_color = source.opaque? ? 'white': 'Transparent'
			#create background image to composite with 
			target = Image.new(width, height) do
				self.background_color = background_color
			end
			#composite the two images
			target.composite(source, CenterGravity, OverCompositeOp).write(illusion)
		else
			Image.read(full_path).first().send(self,resize_function, width, height).write(illusion)
		end
	end
end