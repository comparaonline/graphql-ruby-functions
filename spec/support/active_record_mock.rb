module ActiveRecordMock
  module_function

  def setup(table_name = :mocks, &table_definition)
    ActiveRecord::Base.establish_connection(
      adapter: 'sqlite3',
      database: ':memory:'
    )
    ActiveRecord::Base.connection.create_table(table_name, &table_definition)
  end

  def teardown(table_name = :mocks)
    ActiveRecord::Base.connection.drop_table(table_name)
  end
end
