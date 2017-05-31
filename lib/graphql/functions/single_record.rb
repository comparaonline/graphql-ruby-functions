require_relative 'base'

module GraphQL
  module Functions
    class SingleRecord < Base
      argument :id, !types.ID

      def call(_, args, _)
        return @model_class.find(args[:id])
      end

      def type
        @type ||= "Types::#{@model_class}Type".constantize
      end
    end
  end
end
