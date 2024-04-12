extends Node
class_name SxLoadCache
## A resource/scene loader, exposing a `load_resources` method to implement through inheritance and autoload.
## Useful to load every needed resources at game startup.

var _cache := Dictionary()
var _logger := SxLog.get_logger("SxLoadCache")

## Load resources in cache.[br]
##
## Should be overriden by child classes.
func load_resources() -> void:
    pass

## Store a scene in the cache from its path.[br]
##
## Usage:
## [codeblock]
## var cache := SxLoadCache.new()
## cache.store_scene("MyScene", "res://my_scene.tscn")
## [/codeblock]
func store_scene(scene_name: String, scene_path: String) -> void:
    var scene := load(scene_path) as PackedScene
    _cache[scene_name] = scene
    _logger.debug("Caching scene '%s' from path '%s'." % [scene_name, scene_path])

## Store a resource in the cache from its path.[br]
##
## Usage:
## [codeblock]
## var cache := SxLoadCache.new()
## cache.store_resource("MyResource", "res://my_resource.tscn")
## [/codeblock]
func store_resource(resource_name: String, resource_path: String) -> void:
    var resource := load(resource_path) as Resource
    _cache[resource_name] = resource
    _logger.debug("Caching resource '%s' from path '%s'." % [resource_name, resource_path])

## Test if the cache has a scene registered.[br]
##
## Usage:
## [codeblock]
## var cache := SxLoadCache.new()
## var v := cache.has_scene("MyScene")
## [/codeblock]
func has_scene(scene_name: String) -> bool:
    return _cache.has(scene_name)

## Test if the cache has a resource registered.[br]
##
## Usage:
## [codeblock]
## var cache := SxLoadCache.new()
## var v := cache.has_resource("MyResource")
## [/codeblock]
func has_resource(resource_name: String) -> bool:
    return _cache.has(resource_name)

## Load a stored scene.[br]
##
## Usage:
## [codeblock]
## var cache := SxLoadCache.new()
## var scene := cache.load_scene("MyScene")
## [/codeblock]
func load_scene(scene_name: String) -> PackedScene:
    assert(has_scene(scene_name), "Scene should be present in cache")
    _logger.trace("Loading scene '%s'." % scene_name)
    return _cache[scene_name]

## Load a stored resource.[br]
##
## Usage:
## [codeblock]
## var cache := SxLoadCache.new()
## var resource := cache.load_resource("MyResource")
## [/codeblock]
func load_resource(resource_name: String) -> Resource:
    assert(has_resource(resource_name), "Resource should be present in cache")
    _logger.trace("Loading resource '%s'." % resource_name)
    return _cache[resource_name]

## Instantiate a scene.[br]
##
## Usage:
## [codeblock]
## var cache := SxLoadCache.new()
## var instance := cache.instantiate_scene("MyScene") as MyScene
## [/codeblock]
func instantiate_scene(scene_name: String) -> Node:
    var scene := load_scene(scene_name)
    _logger.trace("Instantiating scene '%s'." % scene_name)
    return scene.instantiate()

func _init():
    load_resources()
    _logger.debug("All resources loaded.")
