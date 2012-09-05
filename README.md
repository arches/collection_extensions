# CollectionExtensions

Sometimes an operation just doesn't fit well into a scope, but you don't want to lose your declarative code style
by operating on all the objects individually. This gem adds a few lines of code to make it easier to add methods
to collections of ActiveRecord objects.

<img src="https://secure.travis-ci.org/arches/collection_extensions.png" />

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'collection_extensions'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install collection_extensions
```

## Usage

A collections of records will be extended based on the naming convention `%sCollectionExtensions`, where the `%s` substitution
is the camel-cased name of the class. For example, collections of User objects will be extended with the methods in the
`UserCollectionExtensions` model and collections of BlogPost objects will be extended with the methods in the `BlogPostCollectionExtensions`
module.

```ruby
module BlogPostCollectionExtensions

  # hash key is user ID, hash value is the number of comments they've posted on this set of blog posts
  def comments_per_user
    comment_counts = {}
    
    # 'self' is the array of blog posts
    each do |blog_post|
      blog_post.comments.each do |comment|
        comment_counts[comment.user_id] ||= 0
        comment_counts[comment.user_id] += 1
      end
    end
    
    comment_counts
  end
end
```

### Naming Convention

If you want a different naming convention, set the config variable using `%s` string substitution:

```ruby
CollectionExtensions::Config.naming_convention = "MethodsForCollectionsOf%s"
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
