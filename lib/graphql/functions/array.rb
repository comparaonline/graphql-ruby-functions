require_relative 'base'

module GraphQL
  module Functions
    class Array < Base
      argument :ids, types[types.ID]
      argument :limit, types.Int
      argument :offset, types.Int

      def call(_, args, _)
        query = args[:ids] ? @model_class.where(id: args[:ids]) : @model_class.all
        query = query.offset(args[:offset]) if args[:offset]
        query = query.limit(args[:limit]) if args[:limit]
        query
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
