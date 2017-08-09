require 'spec_helper'

RSpec.describe GraphQL::Functions::Array do
  def create(quantity)
    quantity.times { Mock.create }
    (yield(Mock) if block_given?) || Mock
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

  let(:default_args) do
    GraphQL::Query::Arguments.new({}, argument_definitions: {})
  end

  describe '#call' do
    it 'return all elements when no args are specified' do
      elements = create(5, &:all)
      expect(Function.create.call(nil, default_args, nil)).to eq(elements)
    end

    it "'ids' return the elements targeted" do
      elements = create(5) { |m| m.take(3) }
      ids = elements.map(&:id)

      expect(Function.create.call(nil, { ids: ids }, nil)).to eq(elements)
    end

    it "'limit' return only the first elements" do
      limit = 3
      elements = create(5) { |m| m.take(limit) }

      expect(Function.create.call(nil, { limit: limit }, nil)).to eq(elements)
    end

    it "'offset' return only the first elements" do
      offset = 2
      elements = create(2) { |m| m.offset(offset) }

      expect(Function.create.call(nil, { offset: offset }, nil)).to eq(elements)
    end

    it "'offset' and 'limit' combines to filter together" do
      limit = 2
      offset = 3
      elements = create(10) { |m| m.offset(offset).limit(limit) }

      expect(
        Function.create.call(nil, { offset: offset, limit: limit }, nil)
      ).to eq(elements)
    end

    it "'order_by' return the elements sorted asc by param" do
      elements = create(5) { |m| m.order(:id) }
      expect(
        Function.create.call(nil, { order_by: 'id' }, nil)
      ).to eq(elements)
    end

    it "'desc' return the elements sorted desc" do
      elements = create(5) { |m| m.order(id: :desc) }
      expect(
        Function.create.call(nil, { order_by: 'id', desc: true }, nil)
      ).to eq(elements)
    end
  end

  context '#query method on the subclass' do
    before(:example) do
      stub_const(
        'Function',
        Class.new(GraphQL::Functions::Array) do
          model Mock
          def query(relation, *_)
            relation.order(id: :desc)
          end
        end
      )
    end

    it 'filters the returned relation' do
      elements = create(5) { |m| m.order(id: :desc) }
      expect(
        Function.create.call(nil, default_args, nil)
      ).to eq(elements)
    end
  end

  describe '#type' do
    it 'return the proper type' do
      expect(Function.create.type_class).to eq('Types::MockType'.constantize)
    end
  end
end
