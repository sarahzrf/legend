module EventTarget
	def event(type, subject, data, modifier=nil)
		handlers = ["on_#{type}", "on_#{type}_#{modifier}",
							"on_#{subject.type}_#{type}",
							"on_#{subject.type}_#{type}_#{modifier}"]
		handlers.map do |handler| # return the handler results; currently unused
			send handler, subject, data if respond_to? handler
		end
	end
end

# vim:set tabstop=2 shiftwidth=2 noexpandtab:

