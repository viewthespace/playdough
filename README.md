# versioner-rails

API versioning that promotes convention over configuration.

The premise of this gem is that consumers of your API need versioning and different shapes of your resources. Without proper thought into versioning and shaping, your codebase can quickly resolve into a redundant and confusing state. This gem tries to solve that problem by allowing the API owner to use simple conventions -- Accept headers and ActiveModelSerializer namespacing -- to achieve controller reuse by delegating resource versioning and shaping solely to the serializers level.


## example



Let's say we have a resource of type `Foo` and `foos_controller.rb` with one `index` action that includes our gem:

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

`curl -H 'Accept: application/javascript; version=2 shape=short' http://localhost:3000/foos`

`curl -H 'Accept: application/javascript; version=1 shape=full' http://localhost:3000/foos`

`curl -H 'Accept: application/javascript; version=1 http://localhost:3000/foos`
