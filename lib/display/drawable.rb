require 'gosu'

module Drawable
	@@window = nil
	@@default_texture = nil
	@@scale = 32
	@@textures = {}

	class << self
		def window; @@window; end
		def window= window
			@@window = window
			@@default_texture = window.record(@@scale, @@scale) do
				black = Gosu::Color::BLACK
				window.draw_quad(0, 0, black,
												 @@scale, 0, black,
												 @@scale, @@scale, black,
												 0, @@scale, black)
			end
		end

		def scale; @@scale; end
		def scale= scale; @@scale = scale; end

		def register_texture(type, facing=nil, state=nil, texture)
			type = type.type if type.respond_to? :type
			name = "#{type}"
			name << "_#{facing}" if facing
			name << "_#{state}" if state
			unless texture.respond_to? :draw
				texture = Gosu::Image.new(@@window, texture, true)
			end
			@@textures[name] = texture
		end

		alias_method :[]=, :register_texture
	end

	attr_accessor :z_index

	# default impl; may be overridden
	def texture
		names = ["#{type}"]
		names << "#{type}_#{facing}" if respond_to? :facing
		names << "#{type}_#{state}" if respond_to? :state
		if respond_to? :state and respond_to? :facing
			names << "#{type}_#{facing}_#{state}"
		end
		most_specific = @@textures.values_at(*names).compact.last
		most_specific || @@default_texture
	end

	def draw(x=nil, y=nil)
		x ||= self.x
		y ||= self.y
		texture.draw x * @@scale, y * @@scale, (@z_index ||= 0)
	end
end

# vim:set tabstop=2 shiftwidth=2 noexpandtab:

