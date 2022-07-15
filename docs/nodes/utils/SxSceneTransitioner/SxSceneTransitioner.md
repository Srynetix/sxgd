# SxSceneTransitioner

**[◀️ Back](../readme.md)**

|    |     |
|----|-----|
|*Source*|[SxSceneTransitioner.gd](../../../../nodes/utils/SxSceneTransitioner/SxSceneTransitioner.gd)|
|*Inherits from*|`CanvasLayer`|
|*Globally exported as*|`SxSceneTransitioner`|

> A simple scene transition node, with a fade-in/fade-out effect.  
## Signals

### `animation_finished`

*Code*: `signal animation_finished()`

> Transition is finished.  
## Methods

### `fade_to_scene`

*Prototype*: `func fade_to_scene(scene: PackedScene) -> void`

> Fade current scene to another loaded scene.  
>   
> Example:  
>   SxSceneTransitioner.fade_to_scene(my_scene)  
### `fade_to_scene_path`

*Prototype*: `func fade_to_scene_path(scene_path: String) -> void`

> Fade current scene to another scene, loaded before the process.  
>   
> Example:  
>   SxSceneTransitioner.fade_to_scene_path("res://my_scene.tscn")  
### `fade_to_cached_scene`

*Prototype*: `func fade_to_cached_scene(cache: SxLoadCache, scene_name: String) -> void`

> Fade current scene to another scene, using a SxLoadCache.  
>   
> Example:  
>   SxSceneTransitioner.fade_to_cached_scene(cache, "MyScene")  
### `fade_out`

*Prototype*: `func fade_out(speed: float = 1.0) -> void`

> Apply a "fade out" effect.  
>   
> Example:  
>   SxSceneTransitioner.fade_out()  
### `fade_in`

*Prototype*: `func fade_in(speed: float = 1.0) -> void`

> Apply a "fade in" effect.  
>   
> Example:  
>   SxSceneTransitioner.fade_in()  
