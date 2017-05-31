require 'graphql'

module GraphQL
  module Functions
    class Base < ::GraphQL::Function
      class << self
        def create
          self.new(@model)
        end

        def model(model)
          @model = model
        end
      end

      private

      def initialize(model_class)
        @model_class = model_class
      end
    end
  end
end
