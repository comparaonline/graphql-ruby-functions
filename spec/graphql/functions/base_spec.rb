require 'spec_helper'

RSpec.describe GraphQL::Functions::Base do
  context '#model' do
    it 'fails when the argument is not an ActiveRecord object' do
      stub_const('A', Class.new)
      expect do
        stub_const('B', Class.new(described_class) { model A })
      end.to raise_error(ArgumentError)
    end
  end

  context '#create' do
    it 'fails when model is not set' do
      expect { described_class.create }.to raise_error(ArgumentError)
    end

    it 'returns a GraphQL::Function' do
      stub_const('C', Class.new(ActiveRecord::Base))
      stub_const('D', Class.new(described_class) { model C })

      expect(D.create).to be_kind_of(GraphQL::Function)
    end
  end
end
