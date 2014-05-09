# DataMapper::Aspects

Aspect-Oriented modules to add commonly needed methods and properties to your DataMapper models.

## Installation

Add this line to your application's Gemfile:

    gem 'dm-aspects'

And then execute:

    $ bundle

## Usage

### DataMapper::Aspects::BSONID

Adds a primary key property called `:id` to your model that uses BSONID:

    property :id, String, length: 24, key: true, default: Moped::BSON::ObjectId.new

Moped::BSON has been found to be the fastest BSON ObjectId library for ruby, so it
was chosen for ObjectID generation and validation. However, `dm-aspects` has not declared
this as a dependency, since all `dm-aspects` are optional (and declaring `moped` as a
dependency would drag a bunch of unwanted code in and slow down your boot up time).

As such, you to add this to you Gemfile before using this module:

````ruby
gem 'moped', require: 'moped/bson'
````

Example:

````ruby
class MyModel
  include DataMapper::Resource
  include DataMapper::Aspects::BSONID

  # :id is added automatically
  property :name
  
end

MyModel.create(name: 'Example')
# => #<MyModel @id="53673b2c89d50f5c7400001f" @name="Example">
````

---


### DataMapper::Aspects::Slug

Adds a `:slug` property to your model:

    property :slug, String, length: 75, unique: true

Adds a `find_by_slug` class method to your model.

Slug generation is left up to you.

Example:

````ruby
class MyModel
  include DataMapper::Resource
  include DataMapper::Aspects::Slug

  property :id, Serial
end

MyModel.create(slug: 'my-slug')
MyModel.find_by_slug('')
# => #<MyModel @id=1 @slug="my-slug">
````

---

### DataMapper::Aspects::Status

Adds a `:status` property to your model that validates it was set to one of the followig options: `'draft'`, `'published'`, `'archived'`. The default value is `'draft'`. 

You can customize this by overwriting the `statuses` class method on your Model and have it return an array of strings. Just make sure the default status is first element in the array and that none of your statuses are over 50 characters long.

We use this module to give admin's simple controls over the visibility of content-oriented objects. This module has helped us avoid conflating domain concerns (validation, state management, content lifecycle, etc) by implementing a state machine on models too early in the development of new applications.

Example:

````ruby
class MyModel
  include DataMapper::Resource
  include DataMapper::Aspects::Status

  property :id, Serial
end

MyModel.all(status: 'published')
# => [#<MyModel @id=1 @status='published'>, #<MyModel @id=2 @status='published'>, ...]
````

Customized `statuses` example:

````ruby
class MyModel
  include DataMapper::Resource
  include DataMapper::Aspects::Status

  property :id, Serial

  def self.statuses
    %w(queued processing processed).freeze
  end
end
````

---

### DataMapper::Aspects::Utils

A collection of helper methods to make all your models a little more awesome.

Class Methods:

- `default_sequence_name` - Returns a string for the sequence name for your model's `Serial` property. PostgreSQL only. 
- `next_id` - Returns the next unused value in your model's `Serial` property sequence. Use this when you need to generate an ID for your model before you've saved the object to the database. Pass it the name of your sequence if it differs from the `default_sequence_name`. PostgreSQL only.
- `select_options` - Returns an array of hashes containing `:label` and `value` keys. Useful for building a `<select>` form input containing a list of all your objedts. Your model must have a property or method called `name`, which is set as the `label`.  The `:value` will be set to your model's `Serial` property (determined automatically) and can be named anything you like.

Instance Methods:

- `changed?` - Pass it the name of one of your model's properties and it will return a `Boolean` indicating whether or not the field has been changed since you queried it from the database. Use this to avoid performing some expensive operation (like generating a slug, or uploading an image) if the field hasn't changed. Relies on DataMapper's built-in dirty attributes tracking.
- `attributes_json` - Uses the super-fast `oj` gem  to serialize and return a json string of all of your model's attributes.

Example:

````ruby
class Thing
  include DataMapper::Resource
  include DataMapper::Aspects::Utils

  property :id, Serial
  property :name, String
end


Thing.default_sequence_name
# => "things_id_seq"

Thing.next_id
# => 2

Thing.select_options
# => [{:label => 'Thing 1', :value => 1},{:label => 'Thing 2', :value => 1}]

thing = Thing.first
thing.name = 'Thing-a-ma-jig'
thing.changed?(:name)
# => true
thing.save # once your object is persisted, dirty tracking is reset
thing.changed?(:name)
# => false

Thing.first.attributes_json
# => '{"id":1,"name":"Thing 1"}'
````

## Contributing

1. Fork it ( http://github.com/styleseek/dm-aspects/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
