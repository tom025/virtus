module Virtus
  class Attribute
    class Collection

      class CoercibleWriter < Attribute::Writer::Coercible

        attr_reader :member_type

        attr_reader :member_writer

        # @api private
        def initialize(name, options)
          super
          @member_type   = options.fetch(:member_type, ::Object)
          @member_writer = Attribute.build(name, @member_type, :coerce => true).writer
        end

        # Coerce a collection with members
        #
        # @param [Object] value
        #
        # @return [Object]
        #
        # @api private
        def coerce(value)
          coerced = super
          return coerced unless coerced.respond_to?(:each_with_object)
          coerced.each_with_object(new_collection) do |entry, collection|
            coerce_and_append_member(collection, entry)
          end
        end

        # Return an instance of the collection
        #
        # @return [Enumerable]
        #
        # @api private
        def new_collection
          primitive.new
        end

        private

        # Coerce a member of a source collection and append it to the target collection
        #
        # @param [Array, Set] collection
        #   target collection to which the coerced member should be appended
        #
        # @param [Object] entry
        #   the member that should be coerced and appended
        #
        # @return [Array, Set]
        #   collection with the coerced member appended to it
        #
        # @api private
        def coerce_and_append_member(collection, entry)
          collection << member_writer.coerce(entry)
        end

      end # class CoercibleWriter

    end # class Collection
  end # class Attribute
end # module Virtus
