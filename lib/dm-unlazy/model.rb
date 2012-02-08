#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

module DataMapper; module Unlazy

class Model
	def initialize (model, data = nil)
		@model = model.new

		if data
			@model.attributes = Hash[data.each_pair.to_a]
		end
	end

	def method_missing (id, *args, &block)
		result = @model.__send__ id, *args, &block

		if Associations::OneToMany::Collection === result
			class << result.source
				def saved?
					true
				end
			end

			result.reload

			class << result.source
				remove_method :saved?
			end
		end

		result
	end
end

end; end
