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

  let(:default_args) do
    GraphQL::Query::Arguments.new({}, argument_definitions: {})
  end

  describe '#call' do
    context 'when id arg is passed' do
      it 'return the proper element' do
        mock = Mock.create
        expect(Function.create.call(nil, { id: mock.id }, nil)).to eq(mock)
      end
    end

    context 'when id arg is not passed' do
      context 'and #query method is not implemented in subclass' do
        it 'returns the first element' do
          Mock.create
          expect(Function.create.call(nil, {}, nil)).to eq(Mock.first)
        end
      end

      context 'when #query method is implemented in subclass' do
        context 'and #query returns an array' do
          it 'defaults to the first element' do
            5.times { Mock.create }
            Function.class_eval do
              def query(*_)
                Mock.all
              end
            end
            expect(Function.create.call(nil, default_args, nil))
              .to eq(Mock.first)
          end
        end

        context 'and #query returns a single element' do
          it 'returns the proper element' do
            5.times { Mock.create }
            Function.class_eval do
              def query(relation, *attrs)
                _, args, = attrs
                relation.where(id: args[:index])
              end
            end

            second = Mock.second
            expect(Function.create.call(nil, { index: second.id }, nil))
              .to eq(second)
          end
        end
      end
    end
  end

  describe '#type' do
    it 'return the proper type' do
      expect(Function.create.type).to eq('Types::MockType'.constantize)
    end
  end
end
