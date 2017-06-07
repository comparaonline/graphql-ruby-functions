require 'spec_helper'

RSpec.describe GraphQL::Functions::Array do
  def create_and_filter(quantity)
    quantity.times { Mock.create }
    yield(Mock)
  end

  before(:example) do
    ActiveRecordMock.setup
    stub_const('Mock', Class.new(ActiveRecord::Base))
    stub_const('Types::MockType', Class.new)
    stub_const(
      'Function',
      Class.new(GraphQL::Functions::Array) { model Mock }
    )
  end

  after(:context) { ActiveRecordMock.teardown }

  context '#call' do
    it "'ids' return the elements targeted" do
      elements = create_and_filter(5) { |m| m.take(3) }
      ids = elements.map(&:id)

      expect(Function.create.call(nil, { ids: ids }, nil)).to eq(elements)
    end

    it "'limit' return only the first elements" do
      limit = 3
      elements = create_and_filter(5) { |m| m.take(limit) }

      expect(Function.create.call(nil, { limit: limit }, nil)).to eq(elements)
    end

    it "'offset' return only the first elements" do
      offset = 2
      elements = create_and_filter(2) { |m| m.offset(offset) }

      expect(Function.create.call(nil, { offset: offset }, nil)).to eq(elements)
    end

    it "'offset' and 'limit' combines to filter together" do
      limit = 2
      offset = 3
      elements = create_and_filter(10) { |m| m.offset(offset).limit(limit) }

      expect(
        Function.create.call(nil, { offset: offset, limit: limit }, nil)
      ).to eq(elements)
    end
  end

  context '#type' do
    it 'return the proper type' do
      expect(Function.create.type_class).to eq('Types::MockType'.constantize)
    end
  end
end
