# SxServerPeer

**[◀️ Back](../readme.md)**

|    |     |
|----|-----|
|*Source*|[SxServerPeer.gd](../../../nodes/networking/SxServerPeer.gd)|
|*Inherits from*|`Node`|
|*Globally exported as*|`SxServerPeer`|

## Signals

### `peer_connected`

*Code*: `signal peer_connected(peer_id)`

### `peer_disconnected`

*Code*: `signal peer_disconnected(peer_id)`

### `players_updated`

*Code*: `signal players_updated(players)`

## Public variables

### `server_port`

*Code*: `var server_port := 0`

### `max_players`

*Code*: `var max_players := 0`

### `rpc_service`

*Code*: `var rpc_service: SxRPCService`

## Methods

### `get_players`

*Prototype*: `func get_players() -> Dictionary`

### `spawn_synchronized_scene`

*Prototype*: `func spawn_synchronized_scene(parent: NodePath, scene_path: String, owner_peer_id: int = 1, master_configuration: Dictionary = {}) -> Node`

### `spawn_synchronized_named_scene`

*Prototype*: `func spawn_synchronized_named_scene(parent: NodePath, scene_path: String, scene_name: String, owner_peer_id: int = 1, master_configuration: Dictionary = {}) -> Node`

### `spawn_synchronized_scene_mapped`

*Prototype*: `func spawn_synchronized_scene_mapped(parent: NodePath, name: String, server_scene_path: String, client_scene_path: String, owner_peer_id: int = 1, master_configuration: Dictionary = {}) -> Node`

### `remove_synchronized_node`

*Prototype*: `func remove_synchronized_node(node: Node) -> void`

## SxSynchronizedScenePath

|    |     |
|----|-----|
|*Inherits from*|`Reference`|

### SxSynchronizedScenePath, Public variables

#### `guid`

*Code*: `var guid: String`

#### `name`

*Code*: `var name: String`

#### `parent`

*Code*: `var parent: NodePath`

#### `scene_path`

*Code*: `var scene_path: String`

#### `owner_peer_id`

*Code*: `var owner_peer_id: int`

#### `master_configuration`

*Code*: `var master_configuration: Dictionary`

