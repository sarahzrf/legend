class Class
	def define(constants)
		constants.each do |name, val|
			define_method(name) {val}
		end
	end
end

class Range
	def overlap?(other)
		first < other.first or last > other.last
	end
end

DIRECTIONS = [:north, :south, :east, :west]
OPPOSITES  = {north: :south, south: :north,
							east: :west, west: :east}

class Symbol
	def flip
		OPPOSITES[self]
	end
end

# vim:set tabstop=2 shiftwidth=2 noexpandtab:

