# versioner-rails

API versioning that promotes convention over configuration.

The premise of this gem is that consumers of your API need versioning and different shapes of your resources. Without proper thought into versioning and shaping, your codebase can quickly resolve into a redundant and confusing state. This gem tries to solve that problem by allowing the API owner to use simple conventions -- Accept headers and ActiveModelSerializer namespacing -- to achieve controller reuse by controllers delegating resource versioning and shaping to the serializers level.


## example



Let's say we have a resource of type `Foo` and `foos_controller.rb` that includes our gem and has an `index` action:

``` Ruby
class FoosController< ActionController::Base

  versioner Serializers::Foo

  def index
    render json: Foo.all
  end
  
end
```

A client on v1 would like a list of `foos` in short form:

`curl -H 'Accept: application/javascript; version=1 shape=short' http://localhost:3000/foos`

A client on v2 would like a list of `foos` in short form:

`curl -H 'Accept: application/javascript; version=2 shape=short' http://localhost:3000/foos`

A client on v1 would like a list of `foos` in full form:

`curl -H 'Accept: application/javascript; version=1 shape=full' http://localhost:3000/foos`

A client on v2 would like a list of `foos` in default form:

`curl -H 'Accept: application/javascript; version=2 http://localhost:3000/foos`

Assuming we have the following ActiveModelSerializer directory structure, we wouldn't have to change the above controller at all:
```
/app
  /serializers
    /foo
      /v1
        foo_short_serializer.rb
        foo_full_serializer.rb
      /v2
        foo_full_serializer.rb
        foo_serializer.rb
``` 
