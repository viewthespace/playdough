# Shapeable

API versioning that promotes convention over configuration.

The premise of this gem is that consumers of your API need versioning and different shapes of your resources. Without proper thought into versioning and shaping, your codebase can quickly resolve into a redundant and confusing state. This gem tries to solve that problem by allowing the API owner to use simple conventions -- Accept headers and ActiveModelSerializer namespacing -- to achieve controller reuse by controllers delegating resource versioning and shaping to the serializer level.


## example



Let's say we have a resource of type `Foo` and `foos_controller.rb` that includes our gem and has a `show` action:

``` Ruby
class FoosController < ActionController::Base
  versioner Serializers::Foo

  def show
    render json: Foo.new(first_name: 'Shawn'), serializer: versioner_serializer
  end

end
```

A client on v1 would like a list of `foos` in short form:

`curl http://localhost:3000/foos -H 'Accept: application/javascript; version=1 shape=short'`

A client on v2 would like a list of `foos` in short form:

`curl http://localhost:3000/foos -H 'Accept: application/javascript; version=2 shape=short'`

A client on v1 would like a list of `foos` in full form:

`curl http://localhost:3000/foos -H 'Accept: application/javascript; version=1 shape=full'`

A client on v2 would like a list of `foos` in default form:

`curl http://localhost:3000/foos -H 'Accept: application/javascript; version=2`

Assuming we have the following ActiveModelSerializer directory structure, we wouldn't have to change the above controller at all to fulfill these requests:
```
app
  serializers
    foo
      v1
        foo_short_serializer.rb
        foo_full_serializer.rb
      v2
        foo_full_serializer.rb
        foo_serializer.rb
```

To specify that the versioner should be applied to or excluded from given controller actions, use the :only and :except parameters.
```
versioner Serializers::Foo, :except => [:index, :show]
versioner Serializers::Foo, :only => :delete
```

