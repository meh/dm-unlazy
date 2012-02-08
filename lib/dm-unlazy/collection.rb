#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

require 'dm-unlazy/model'

module DataMapper

class Collection < LazyArray
	def unlazy
		Unlazy::Collection.new self
	end
end

module Unlazy

class Collection
	def initialize (collection)
		unless collection.is_a?(DataMapper::Collection)
			raise ArgumentError, 'you have to pass a Collection'
		end

		@collection = collection
	end

	def method_missing (id, *args, &block)
		collection = @collection

		if (Array.instance_method(id) rescue false)
			reload unless @resources

			if @resources.is_a?(Array)
				return @resources.__send__ id, *args, &block
			end

			collection = @resources
		end

		result = collection.__send__ id, *args, &block

		if result.is_a?(DataMapper::Collection)
			Collection.new(result)
		else
			result
		end
	end

	def fields (*fields)
		@fields = fields.flatten.map(&:to_sym)
		@fields.push *model.key.entries.map(&:name)
		@fields.uniq!

		self
	end

	def reload
		adapter    = repository.adapter
		collection = @collection.all(:fields => @fields || model.properties.map(&:field))

		if adapter.respond_to? :select
			statement = adapter.send(:select_statement, collection.query).flatten(1)

			@resources = adapter.select(*statement).map {|data|
				if data.is_a?(Struct)
					Unlazy::Model.new(model, data)
				else
					Unlazy::Model.new(model, Struct.new(@fields.first).new(data))
				end
			}
		else
			@resources = collection
		end

		self
	end
end

end

end
