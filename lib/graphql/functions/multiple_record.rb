require_relative 'base'

module GraphQL
  module Functions
    class MultipleRecord < Base
      argument :ids, types[types.ID]
      argument :limit, types.Int
      argument :offset, types.Int

      def call(obj, args, ctx)
        query = args[:ids] ? @model_class.where(id: args[:ids]) : @model_class.all
        query = query.offset(args[:offset]) if args[:offset]
        query = query.limit(args[:limit]) if args[:limit]
        query
      end

      def type
        @type ||= self.class.types[!"Types::#{@model_class}Type".constantize]
      end
    end
  end
end
