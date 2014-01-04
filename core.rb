require 'singleton'
require 'andand'

class World
	def initialize(rooms={})
		@rooms = {}
		@rooms.merge! rooms
		@current_coords = 0, 0
	end

	attr_reader :rooms
	attr_accessor :current_coords

	def current_room
		@rooms[@current_coords]
	end

	def add_room(coords, room)
		@rooms[coords] = room
	end

	def all_sprites
		@rooms.values.map &:sprites
	end

	alias_method :<<, :add_room
end

class Room
	def initialize(grid=[[]], sprites=[])
		@grid = grid
		@sprites = []
	end

	attr_reader :sprites

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

# vim:set tabstop=2 shiftwidth=2 noexpandtab:

