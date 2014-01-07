require_relative 'event_target'
require_relative 'positioned'

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

# vim:set tabstop=2 shiftwidth=2 noexpandtab:

