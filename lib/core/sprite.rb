require_relative 'core_ext'
require_relative 'event_target'
require_relative 'positioned'
require_relative '../display/drawable'

class Sprite
	include Positioned
	include EventTarget

	include Drawable
	define z_index: 1

	attr_reader :room, :x, :y, :facing, :moving, :state
	define x_size: 0.8, y_size: 0.8, solid?: true, type: :generic_sprite
	# most sprites are solid
	# type is an internal identifer

	def initialize(room, x, y, facing=:north, state=:idle)
		@room, @x, @y = room, x, y
		@facing, @state = facing, state
		@moving = false
		# @moving will be set in the update method, once it's written
		@room << self
	end

	def update_facing(x, y)
		x_diff, y_diff = @x - x, @y - y
		case
		when x_diff.abs >= y_diff.abs && x_diff > 0
			@facing = :west
		when x_diff.abs >= y_diff.abs && x_diff < 0
			@facing = :east
		when y_diff.abs > x_diff.abs && y_diff > 0
			@facing = :north
		when y_diff.abs > x_diff.abs && y_diff < 0
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
		@room.sprite_moved(self) {@x, @y = ox, oy}
		# make sure the room approves of our movement
		# (the block is a callback for a move failure)
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

