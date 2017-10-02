require_relative 'base'

module GraphQL
  module Functions
    class Element < Base
      argument :id, types.ID

      def call(*attrs)
        _, args, = attrs
        return @model_class.find(args[:id]) if args[:id]
        return @model_class.first unless respond_to?(:query)
        relation = query(@model_class, *attrs)
        relation.is_a?(ActiveRecord::Relation) ? relation.first : relation
      end

      def type
        @type ||= "Types::#{@model_class}Type".constantize
      end
    end
  end
end
