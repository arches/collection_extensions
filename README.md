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

### Syntax

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

### Examples

#### Complicated 'scopes'

Not all logical groupings of records can be easily represented by a scope. Say that you wanted to have a feature targeted
at people with G+ profiles. You might write psuedocode something like this:

```ruby
users = User.where("email like '%@gmail.com'").all
google_api_instance = GooglePlusAPI.new(ENV['google_plus_token'], ENV['google_plus_secret'])
users.select! { |u| profile = google_api_instance.get_profile(u.email); profile.confirmed }
```

Hitting an API isn't something I would normally put in a scope definition, so the first time I needed to get the G+
users I'd probably write code like the above.  Then over time, this block might be copied and pasted across my code.
Eventually perhaps I'd abstract it into a method:

```ruby
def google_plus(users)
  google_api_instance = GooglePlusAPI.new(ENV['google_plus_token'], ENV['google_plus_secret'])
  users.select! { |u| profile = google_api_instance.get_profile(u.email); profile.confirmed }
end

# now I can use a single line in the dozens of places I need to access the G+ users
users = google_plus(User.where("email like '%@gmail.com'").all)
```

Better, but conceptually I want to be able to say `User.google_plus`. That's where the collection_extension gem comes in.
Add the google_plus method to an user collection extension module and it will be available on any group of users:

```ruby
module UserCollectionExtensions
  def google_plus(users)
    google_api_instance = GooglePlusAPI.new(ENV['google_plus_token'], ENV['google_plus_secret'])
    select { |u| profile = google_api_instance.get_profile(u.email); profile.confirmed }
  end
end

User.where("email like '%@gmail.com'").google_plus
```

#### Bulk Actions

Rails provides
some methods that operate on collections of objects, such as `Comment.destroy_all`. The collection extension gem can be used
to write similar convenience methods for bulk actions:

```ruby
class CommentCollectionExtensions
  def moderated!
    each {|comment| comment.update_attributes(moderated: true)}
  end
end

Comment.created_by_trusted_user.moderated!  # let a bunch of comments through at once
```

#### Tell, Don't Ask

Collections of objects often encourage violation of the "Tell, Don't Ask" principle (Thoughtbot has a great [refresher](http://robots.thoughtbot.com/post/27572137956/tell-dont-ask)).
Most of the methods available on a collection are by their very nature asking for information about the contents
of the collection. Collect, each, select, detect, etc - their entire purpose is to expose the contents of the collection.
Yes, you can then follow tell-don't-ask when operating on each member, which is a start. But what if the thing you're trying
to do is really related to the collection, not the individual objects? There's a fine line and it's hard to find good examples
(email me if you think of one!)... but if you do run across a case where what you really want is essentially a unit method
on a collection, a collection extension is the place for it.

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
