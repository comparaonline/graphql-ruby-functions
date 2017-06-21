require_relative 'base'

module GraphQL
  module Functions
    class Array < Base
      argument :ids, types[types.ID]
      argument :limit, types.Int
      argument :offset, types.Int

      def call(*attrs)
        _, args, = attrs
        relation = @model_class
          .all
          .where(args[:ids] ? { id: args[:ids] } : nil)
          .offset(args[:offset])
          .limit(args[:limit])

        (query(relation, *attrs) if respond_to?(:query)) || relation
      end

      def type
        @type ||= self.class.types[!type_class]
      end

      def type_class
        "Types::#{@model_class}Type".constantize
      end
    end
  end
end
