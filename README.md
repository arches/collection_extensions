# CollectionExtensions

Sometimes an operation just doesn't fit well into a scope, but you don't want to lose your declarative code style
by operating on all the objects individually. This gem adds a few lines of code to make it easier to add methods to collections of objects.

<img src="https://secure.travis-ci.org/arches/collection_extensions.png" />

## Installation

Add this line to your application's Gemfile:

    gem 'collection_extensions'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install collection_extensions

## Usage

Include the module in your model and specify what collections you want to extend:

    class User < ActiveRecord::Base
        include CollectionExtensions
        
        has_many :orders, :preferences
        
        extend_collections :orders, :preferences
    end

This will use the modules OrdersCollectionExtensions and PreferencesCollectionExtensions to extend those associations
whenever you use them. For example:

    module OrdersCollectionExtensions
      def for_product_id(product_id)
        # 'self' is the array of orders
        select {|o| o.line_items.collect(&:product).include? product}
      end
    end
    
    > User.find(1).orders.for_product_id(2)

If you want a different naming convention, set the config variable using `%s` string substitution:

    CollectionExtensions::Config.naming_convention = "MethodsForCollectionsOf%s"


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
