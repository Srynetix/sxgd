# SxNetwork

**[◀️ Back](../readme.md)**

|    |     |
|----|-----|
|*Source*|[SxNetwork.gd](../../extensions/SxNetwork.gd)|
|*Inherits from*|`Reference`|
|*Globally exported as*|`SxNetwork`|

> Network utilities.  
>   
> UUID generation was extracted from https://github.com/binogure-studio/godot-uuid/blob/master/uuid.gd  
## Static methods

### `get_nuid`

*Prototype*: `static func get_nuid(node: Node) -> int`

> Shortcut to get the network unique ID  
### `get_sender_nuid`

*Prototype*: `static func get_sender_nuid(node: Node) -> int`

> Shortcut to get the sender network unique ID  
### `generate_network_name`

*Prototype*: `static func generate_network_name(name: String, guid: String) -> String`

> Generate a network name from a node name and a UUID  
### `is_network_master`

*Prototype*: `static func is_network_master(node: Node) -> bool`

> Check if a node is a network master  
### `is_network_enabled`

*Prototype*: `static func is_network_enabled(tree: SceneTree) -> bool`

> Check if a network peer is enabled for a scene tree  
### `uuid4`

*Prototype*: `static func uuid4() -> String`

> Generate a UUID4 string  
