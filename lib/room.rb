require 'andand'
require_relative 'core_ext'

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
		collides = tiles.values.any? &:solid?
		yield if collides
		# if we any of the blocks the sprite now overlaps are	solid,
		# yield to the the reset callback to move the sprite back to where it was.
		# we'll call the collision handlers on the colliding tile anyway, 
		# because push events are just collision events on solid tiles.
		# we return before running the sprite colliisoni hooks because
		# sprites do not have a separate push hook and the sprite that
		# to move will not be colliding with anything new.
		# TODO: actually fucking differentiate between collision and pushing,
		# rendering this length comment unnecessary.
		tiles.each do |(x, y), tile|
			event_extend tile, x, y
			tile.collide! sprite
		end
		return if collides
		@sprites.each do |osprite|
			next if osprite.equal? sprite
			next unless osprite.collide? sprite
			osprite.collide! sprite
		end
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

# vim:set tabstop=2 shiftwidth=2 noexpandtab:

