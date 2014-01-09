require_relative '../core/room'

class Room
	def draw
		@grid.each_with_index do |col, x|
			col.each_with_index do |tile, y|
				position_extend tile, x, y
				tile.draw
			end
		end
		@sprites.each &:draw
	end
end

# vim:set tabstop=2 shiftwidth=2 noexpandtab:

