# Taken from https://github.com/bdesham/pluralize
#
# Original license:
# This script is hereby released into the public domain. To the extent
# possible, the author places no restrictions upon its use, modification,
# or redistribution.

module Jekyll
	module Pluralize

		def pluralize(number, singular, plural=nil)
			if number == 1
				"#{number} #{singular}"
			elsif plural == nil
				"#{number} #{singular}s"
			else
				"#{number} #{plural}"
			end
		end

	end
end

Liquid::Template.register_filter(Jekyll::Pluralize)
