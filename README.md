# versioner-rails

API versioning that promotes convention over configuration

```curl -H 'Accept: application/javascript; version=1 shape=short' http://localhost:3000/foos```

```curl -H 'Accept: application/javascript; version=2 shape=short' http://localhost:3000/foos```

```curl -H 'Accept: application/javascript; version=1 shape=full' http://localhost:3000/foos```

```curl -H 'Accept: application/javascript; version=1 shape=full' http://localhost:3000/foos/1```
