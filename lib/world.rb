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

# vim:set tabstop=2 shiftwidth=2 noexpandtab:

