# SxLoadCache

**[◀️ Back](../readme.md)**

|    |     |
|----|-----|
|*Source*|[SxLoadCache.gd](../../../../nodes/utils/SxLoadCache/SxLoadCache.gd)|
|*Inherits from*|`Node`|
|*Globally exported as*|`SxLoadCache`|

> A resource/scene loader, exposing a `load_resources` method to implement through inheritance and autoload.  
> Useful to load every needed resources at game startup.  
## Methods

### `load_resources`

*Prototype*: `func load_resources()`

> Load resources in cache.  
>   
> Should be overriden by child classes.  
### `store_scene`

*Prototype*: `func store_scene(scene_name: String, scene_path: String) -> void`

> Store a scene in the cache from its path.  
>   
> Example:  
>   var cache := SxLoadCache.new()  
>   cache.store_scene("MyScene", "res://my_scene.tscn")  
### `store_resource`

*Prototype*: `func store_resource(resource_name: String, resource_path: String) -> void`

> Store a resource in the cache from its path.  
>   
> Example:  
>   var cache := SxLoadCache.new()  
>   cache.store_resource("MyResource", "res://my_resource.tscn")  
### `has_scene`

*Prototype*: `func has_scene(scene_name: String) -> bool`

> Test if the cache has a scene registered.  
>   
> Example:  
>   var cache := SxLoadCache.new()  
>   var v := cache.has_scene("MyScene")  
### `has_resource`

*Prototype*: `func has_resource(resource_name: String) -> bool`

> Test if the cache has a resource registered.  
>   
> Example:  
>   var cache := SxLoadCache.new()  
>   var v := cache.has_resource("MyResource")  
### `load_scene`

*Prototype*: `func load_scene(scene_name: String) -> PackedScene`

> Load a stored scene.  
>   
> Example:  
>   var cache := SxLoadCache.new()  
>   var scene := cache.load_scene("MyScene")  
### `load_resource`

*Prototype*: `func load_resource(resource_name: String) -> Resource`

> Load a stored resource.  
>   
> Example:  
>   var cache := SxLoadCache.new()  
>   var resource := cache.load_resource("MyResource")  
### `instantiate_scene`

*Prototype*: `func instantiate_scene(scene_name: String) -> Node`

> Instantiate a scene.  
>   
> Example:  
>   var cache := SxLoadCache.new()  
>   var instance := cache.instantiate_scene("MyScene") as MyScene  
