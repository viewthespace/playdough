# Shapeable

API versioning that promotes convention over configuration.

The premise of this gem is that consumers of your API need versioning and different shapes of your resources. Without proper thought into versioning and shaping, your codebase can quickly resolve into a redundant and confusing state. This gem tries to solve that problem by allowing the API owner to use simple conventions -- Accept headers and ActiveModelSerializer namespacing -- to achieve controller reuse by controllers delegating resource versioning and shaping to the serializer level.


## example


Let's say we have a resource of type `Foo` and `foos_controller.rb` that includes our gem and has a `show` action:

``` Ruby
class FoosController < ActionController::Base
  acts_as_shapeable(path: Serializers::Foo)

  def show
    render json: Foo.new(first_name: 'Shawn'), serializer: shape(default_version: 1, default_shape: 'short')
  end

end
```

A client on v1 would like a list of `foos` in short form:

`curl http://localhost:3000/foos -H 'Accept: application/javascript; version=1 shape=short'`

A client on v2 would like a list of `foos` in short form:

`curl http://localhost:3000/foos -H 'Accept: application/javascript; version=2 shape=short'`

A client on v1 would like a list of `foos` in full form:

`curl http://localhost:3000/foos -H 'Accept: application/javascript; version=1 shape=full'`

A client on v2 would like a list of `foos` in default form, in this case short:

`curl http://localhost:3000/foos -H 'Accept: application/javascript;`

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


The `shape` method returns the serializer constant.

Both `acts_as_shapeable` and `shape` accept the following arguments:

* `path`: The top level module where the serializers are defined (required).
* `default_version`: The default version in cases where the header is not specified.
* `default_shape`: The deafault shape in cases where the shape is not specified.

All three options can be defined either on `acts_as_shapeable` or `shape`. The options defined on `shape` have greater precedence than those on `acts_as_shapeable`.
