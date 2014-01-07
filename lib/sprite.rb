require_relative 'core_ext'
require_relative 'event_target'
require_relative 'positioned'

class Sprite
	include Positioned
	include EventTarget

	attr_reader :room, :x, :y, :facing, :moving
	define x_size: 1, y_size: 1, solid?: true, type: 'generic_sprite'
	# most sprites are solid
	# type is an internal identifer; currently used in event dispatching

	def initialize(room, x, y, facing=:north)
		@room, @x, @y, @facing = room, x, y, facing
		@moving = false
		# @moving will be set in the update method, once it's written
		@room << self
	end

	def update_facing(x, y)
		x_diff, y_diff = @x - x, @y - y
		case
		when x_diff >= y_diff && x_diff < 0
			@facing = :west
		when x_diff >= y_diff && x_diff > 0
			@facing = :east
		when y_diff > x_diff && y_diff < 0
			@facing = :north
		when y_diff > x_diff && y_diff > 0
			@facing = :south
		end
	end

	def move(x_diff, y_diff)
		move_to(@x + x_diff, @y + y_diff)
	end

	def move_to(x, y)
		update_facing x, y
		ox, oy, = @x, @y
		@x, @y = x, y
		@x, @y = ox, oy unless @room.sprite_moved self
		# make sure the room approces of our movement
	end

	def room= room
		@room.remove_sprite self
		room << self
	end

	def x= x
		move_to x, @y
	end

	def y= y
		move_to @x, y
	end
end

# vim:set tabstop=2 shiftwidth=2 noexpandtab:

