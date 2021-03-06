# Shapeable

API versioning that promotes convention over configuration.

The premise of this gem is that consumers of your API need versioning and different shapes of your resources. Without proper thought into versioning and shaping, your codebase can quickly resolve into a redundant and confusing state. This gem tries to solve that problem by allowing the API owner to use simple conventions -- Accept headers and ActiveModelSerializer namespacing -- to achieve controller reuse by controllers delegating resource versioning and shaping to the consumer.


## Example


Let's say we have a resource of type `Foo` and `foos_controller.rb` that includes our gem and has a `show` action:

``` Ruby
class FoosController < ActionController::Base
  acts_as_shapeable(path: Serializers::Foo)

  def show
    render json: Foo.new(first_name: 'Shawn'), serializer: shape(default_version: 1, default_shape: 'short')
  end

end
```

Assume we have the following `ActiveModelSerializer` directory structure:

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

Inside our controller we can reference the `shape` method, which returns the serializer constant. The top level module path in which the serializer can be found must be specified using the `path` option on either the `acts_as_shapeable`, or the `shape` method. In this case it would be `Serializers::Foo`. If the path is not specified either in `acts_as_shapeable` or `shape`, then calling `shape` will raise an `ArgumentError`.

Now say we have several clients, each expecting a different serialized response.

---

A client on v1 would like a list of `foos` in short form:

`curl http://localhost:3000/foos -H 'Accept: application/json; version=1 shape=short'`

OR

`curl http://localhost:3000/foos?version=1&shape=short`

When we reference `shape` inside the controller, it returns the following constant: `Serializers::Foo::V1::FooShortSerializer`

---

A client on v2 would like a list of `foos` in short form:

`curl http://localhost:3000/foos -H 'Accept: application/json; version=2 shape=short'`

OR

`curl http://localhost:3000/foos?version=2&shape=short`

When we reference `shape` inside the controller, it returns the following constant: `Serializers::Foo::V2::FooShortSerializer`

---

A client on v1 would like a list of `foos` in full form:

`curl http://localhost:3000/foos -H 'Accept: application/json; version=1 shape=full'`

OR

`curl http://localhost:3000/foos?version=1&shape=full`

When we reference `shape` inside the controller, it returns the following constant: `Serializers::Foo::V1::FooFullSerializer`

---

Note: headers take precedence over query parameters if both are sent

## Configuring Defaults

Both `acts_as_shapeable` and `shape` accept the following arguments:

* `default_version`: The default version in cases where the version is not specified.
* `default_shape`: The deafault shape in cases where the shape is not specified.

The options defined on `shape` have greater precedence over those defined on `acts_as_shapeable`.

In cases where the version and/or the shape is not specified in the Accept Header Shapeable will instead use the provided defaults. If no default is provided, and nothing is specified in the header or query params, Shapeable will raise an `UnresolvedShapeError`.

Using the same example controller and directory structure from above, a client sends no headers:
`curl http://localhost:3000/foos -H 'Accept: application/json;`
Shapeable uses the defaults provided, and resolves `shape` to the following constant: `Serializers::Foo::V1::FooShortSerializer`


Shapeable can also be configured with a global configuration file. All options which can be passed to `acts_as_shapeable` and `shape` can also be configured using this method. Configuration options inside the config file have the lowest precedence.

You can configure shapeable by passing in all configuration options(`default_version`, `default_shape`, and `path`), to `Shapeable.configure` in block format. One approach is to put this in a config file that lives at `config/shapeable.rb`.

```Ruby
# config/shapeable.rb
Shapeable.configure do |config|
  config.default_version = 1
  config.default_shape = 'default'
  config.path = Serializers::Bar
end
```

## Enforce Versioning and Shaping

There are a few additional options which allow you to decide whether you want to enforce version or shape.

`enforce_versioning`, and `enforce_shape` can be passed to `Shapeable.configure`. By default both are set to true.

When `enforce_versioning` is set to false, version will be ignored, and the version module will not be prepended. So the following request

`curl http://localhost:3000/foos -H 'Accept: application/json; shape=default'`

Will be constructed as `Serializers::Foo::FooDefaultSerializer` without the version module prepended.

When `enforce_shape` is set to false, shape will be optional. When shape is not specified, the constant will be constructed with no shape. So the following request:

`curl http://localhost:3000/foos -H 'Accept: application/json; version=1'`

Will be constructed as `Serializers::Foo::V1::FooSerializer`.

## Gotchas

* Shapeable infers the resource name from the path. Specifically it expects that the last constant in the path is the resource. So in the case of `acts_as_shapeable(path: Serializers::Foo)` Shapeable assumes that the resource is `Foo`.
* If we want a shape of `FooSerializer` we must specify a default_shape of `''` (empty string).
