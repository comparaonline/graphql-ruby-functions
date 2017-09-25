# graphql-functions

[![Gem Version](https://badge.fury.io/rb/graphql-functions.svg)](https://badge.fury.io/rb/graphql-functions)
[![CircleCI](https://circleci.com/gh/comparaonline/graphql-ruby-functions.svg?style=svg)](https://circleci.com/gh/comparaonline/graphql-ruby-functions)

Ruby gem made to simplify the standard query creation of the [graphql](http://graphql-ruby.org) gem in your `Active Record` models with predefined **functions**.

Using the provided functions your graphql **types** will gain standard and generic **query arguments** to limit the amount of rows, use an offset, or filter by an specific id among others; supporting queries like the following:

```graphql
{
  people(limit: 2) {
    id,
    first_name
  }  
}
```

```graphql
{
  people(ids: [1, 4, 9]) {
    id,
    age
  }
}
```

```graphql
{
  person(id: 3) {
    id,
    last_name
  }
}
```

The full list of features is shown [here](#features).


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'graphql-functions'
```

And then execute:
```
$ bundle
```

Or install it yourself as:
```
$ gem install graphql-functions
```

Please note that you should also have installed the base [graphql](http://graphql-ruby.org) gem.

## Usage

First of all you have to honor the following files structure convention:

```
app\
--controllers\
--models\
----person.rb
--graphql\
----types\
------query_type.rb
------person_type.rb
----mutations\
----functions\
------person.rb
------people.rb
----schema.rb
```

To help getting started is useful to use the `graphql` [generator](http://graphql-ruby.org/schema/generators#graphqlinstall).

Then you should create a class inside the functions folder subclassing of the two provided functions to the `query type` definition:

```ruby
# app/graphql/functions/people.rb
module Functions
  class People < GraphQL::Functions::Array
    model ::Person
    argument :country_code, types.String

    # optional custom logic code.
    # 'relation' represent the data filtered by the built-in array arguments (limit, offset, etc)
    def query(relation, obj, args, ctx)
      relation.where(country_code: args[:countryCode]) if args[:countryCode]
    end
  end
end
```

```ruby
# app/graphql/functions/person.rb

module Functions
  class Person < GraphQL::Functions::Element
    model ::Person
  end
end
```

```ruby
# app/graphql/types/query_type.rb
module Types
  QueryType = GraphQL::ObjectType.define do
    name "Query"

    field :person, function: Functions::Person.create
    field :people, function: Functions::People.create
  end
end
```

Above changes will in addition to the base query capabilities from `graphql-functions` allow the query to filter by `countryCode` in the `people` field like:

```graphql
{
  people(countryCode: 'us', limit: 2, offset: 5) {
    id,
    first_name,
    last_name
  }
}
```

## Features

### Element
Element function is intended to be used with a query with a single field output like `person` in the example: The only available argument is id:
- `id: Int` Filter by the specified id.

If `id` is not specified or if the subclass implements its own `query` method which does not return a single element, the first element of the model is returned.

### Array
Array function add filters-like arguments to the query:
- `offset: Int` Skip the specified argument of records.
- `limit: Int` Do not return more rows than the argument.
- `ids: [Int]` Filter by the specified ids.
- `order_by: String` Order by the specified argument.
- `desc: Boolean` Flag to order descending.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/comparaonline/graphql-functions.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
