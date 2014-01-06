require './util'
require 'singleton'
require 'andand'

class World
	attr_reader :rooms
	attr_accessor :current_coords

	def initialize(rooms={})
		@rooms = {}
		@rooms.merge! rooms
		@current_coords = 0, 0
	end

	def current_room
		@rooms[@current_coords]
	end

	def add_room(coords, room)
		@rooms[coords] = room
	end

	def all_sprites
		@rooms.values.map &:sprites
	end

	alias_method :[]=, :add_room
end

class Room
	attr_reader :world, :grid, :sprites

	def initialize(world, coords=nil, grid=[[]], sprites=[])
		@world = world
		@grid = grid
		@sprites = []
		@world[coords] = self if coords
	end

	def add_sprite(sprite)
		@sprites << sprite
	end

	def remove_sprite(sprite)
		@sprites.delete sprite
	end

	def sprite_moved(sprite)
		tiles = sprite.solid? ? tile_collisions(sprite) : []
		tiles.each do |(x, y), tile|
			event_extend tile, x, y
			tile.collide! sprite
		end
		return false if tiles.values.any? &:solid?
		@sprites.each do |osprite|
			next if osprite.equal? sprite
			next unless osprite.collide? sprite
			osprite.collide! sprite
		end
		true
	end

	def tile_collisions(sprite)
		xr, yr = sprite.x_irange, sprite.y_irange
		collided_coords = xr.to_a.product yr.to_a
		collided_coords.each_with_object({}) do |(x, y), h|
			tile = self[x, y]
			h[[x, y]] = tile if tile
		end
	end

	def event_extend(tile, x, y)
		room = self
		tile.singleton_class.class_eval do
			define x: x, y: y, room: room
		end
	end

	alias_method :<<, :add_sprite

	def [] x=nil, y=nil
		if x and y
			@grid[x].andand[y]
		elsif x
			@grid[x].dup
		elsif y
			@grid.transpose[y]
		else
			@grid.map &:dup
		end
	end

	def []= x=nil, y=nil, val
		if x and y
			(@grid[x] ||= [])[y] = val
		elsif x
			@grid[x] = val
		elsif y
			@grid.each {|col| col[y] = val}
			val
		else
			@grid = val
		end
	end
end

# individual tile objects will be extended before
# having events sent to them, giving them access
# to methods that aren't listed in this class;
# see Room#event_extend.
class Tile
	include Positioned
	include EventTarget

	define x_size: 1, y_size: 1, solid?: false, type: 'generic_tile'
	# most tiles are not solid
	# type is an internal identifer; currently used in event dispatching
end

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

