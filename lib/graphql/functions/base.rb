require 'graphql'
require 'active_record'

module GraphQL
  module Functions
    class Base < ::GraphQL::Function
      class << self
        def create
          fail_on_model_not_set unless @model
          new(@model)
        end

        def model(model)
          fail_on_wrong_class_model unless model < ActiveRecord::Base
          @model = model
        end

        private

        def fail_on_model_not_set
          raise(
            ArgumentError,
            "'model' not set. Forgot to add 'model ::ModelClass' ?"
          )
        end

        def fail_on_wrong_class_model
          raise(
            ArgumentError,
            "'model' superclass mismatch. It must be 'ActiveRecord::Base'"
          )
        end
      end

      private

      def initialize(model_class)
        @model_class = model_class
      end
    end
  end
end
