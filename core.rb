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

	def initialize(world, grid=[[]], sprites=[])
		@world = world
		@grid = grid
		@sprites = []
	end

	def add_sprite(sprite)
		@sprites << sprite
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
			@grid[x].andand[y] = val
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

class Tile
	include Positioned

	def x_size
		1
	end

	def y_size
		1
	end

	def solid?
		false # default for most kinds of tiles
	end
end

# vim:set tabstop=2 shiftwidth=2 noexpandtab:

