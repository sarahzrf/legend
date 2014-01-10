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
MODIFIERS  = {north: [0, -1], south: [0, 1],
							east: [1, 0], west: [-1, 0]}

class Symbol
	def flip
		OPPOSITES[self]
	end
end

class Array
	def move(direction, distance=1)
		self.dup.move!(direction, distance)
	end

	def move!(direction, distance=1)
		x_diff, y_diff = MODIFIERS[direction]
		x_diff *= distance
		y_diff *= distance
		self[0] += x_diff
		self[1] += y_diff
		self
	end
end

class Hash
	def slice(*keys)
		Hash[keys.zip(values_at(*keys))]
	end
end

# vim:set tabstop=2 shiftwidth=2 noexpandtab:

