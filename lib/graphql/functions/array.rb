require_relative 'base'

module GraphQL
  module Functions
    class Array < Base
      argument :ids, types[types.ID]
      argument :limit, types.Int
      argument :offset, types.Int
      argument :order_by, types.String
      argument :desc, types.Boolean

      def call(*attrs)
        _, args, = attrs
        ids_filter = { id: args[:ids] } if args[:ids]
        order_by = args[:order_by].try(:to_sym)
        order = args[:desc] ? { order_by => :desc } : order_by
        relation = @model_class
          .all
          .where(ids_filter)
          .offset(args[:offset])
          .limit(args[:limit])
          .order(order)

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
