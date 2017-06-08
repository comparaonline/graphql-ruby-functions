require 'spec_helper'

RSpec.describe GraphQL::Functions::Element do
  before(:example) do
    ActiveRecordMock.setup
    stub_const('Mock', Class.new(ActiveRecord::Base))
    stub_const('Types::MockType', Class.new)
    stub_const(
      'Function',
      Class.new(GraphQL::Functions::Element) { model Mock }
    )
  end

  after(:context) { ActiveRecordMock.teardown }

  context '#call' do
    it 'return the proper element' do
      mock = Mock.create
      expect(Function.create.call(nil, { id: mock.id }, nil)).to eq(mock)
    end
  end

  context '#type' do
    it 'return the proper type' do
      expect(Function.create.type).to eq('Types::MockType'.constantize)
    end
  end
end
