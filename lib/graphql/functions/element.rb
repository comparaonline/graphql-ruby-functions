require_relative 'base'

module GraphQL
  module Functions
    class Element < Base
      argument :id, !types.ID

      def call(_, args, _)
        @model_class.find(args[:id])
      end

      def type
        @type ||= "Types::#{@model_class}Type".constantize
      end
    end
  end
end
