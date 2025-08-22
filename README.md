# SoftTrash


Soft deletes for ActiveRecord done right. SoftTrash provides a simple and effective way to implement soft deletion in your Rails applications.

## Features

- Simple integration with ActiveRecord models
- Customizable column names for soft delete functionality
- Scopes for including/excluding soft-deleted records
- Callbacks for soft deletion events
- Works with associations
- Supports Rails 5.2+ and Ruby 2.6+

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'soft_trash'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install soft_trash
```

## Usage

### Basic Setup

1. Generate and run the migration for a model:

```bash
rails generate soft_trash:install Post
rails db:migrate
```

```ruby
add t.soft_trash 
example 

class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.string :name
      t.soft_trash
      t.timestamps
    end
  end
end

```

2. Include the module in your model:

```ruby
class Post < ApplicationRecord
  include SoftTrash::Model
end
```

### Default Behavior

By default, SoftTrash will:
- Add a `deleted_at` datetime column to track deletion
- Add a default scope to exclude soft-deleted records
- Override `destroy` to perform soft deletion
- Provide `really_destroy!` for permanent deletion

### Scopes

```ruby
# Get all records (default scope)
Post.all

# Get only non-deleted records
Post.active

# Get only deleted records
Post.deleted

```

### Instance Methods

```ruby
post = Post.find(1)

# Soft delete a record
post.trash!  # Sets deleted_at to current time

# Check if a record is soft-deleted
post.trashed?  # => true

# Restore a soft-deleted record
post.restore!

# Check if a record is not soft-deleted
post.active?  # => true

```




## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mahendraxceed/soft_trash. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/yourusername/soft_trash/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SoftTrash project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/yourusername/soft_trash/blob/main/CODE_OF_CONDUCT.md).

