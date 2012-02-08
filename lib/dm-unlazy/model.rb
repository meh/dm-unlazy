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

		if [Associations::OneToMany::Collection, Associations::ManyToMany::Collection].any? { |k| k === result }
			result.source.define_singleton_method(:saved?) { true }
			result.reload
		end

		result
	end
end

end; end
