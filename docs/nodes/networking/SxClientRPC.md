# SxClientRPC

**[◀️ Back](../readme.md)**

|    |     |
|----|-----|
|*Source*|[SxClientRPC.gd](../../../nodes/networking/SxClientRPC.gd)|
|*Inherits from*|`Node`|
|*Globally exported as*|`SxClientRPC`|

## Signals

### `spawned_from_server`

*Code*: `signal spawned_from_server(node)`

### `removed_from_server`

*Code*: `signal removed_from_server(node)`

### `players_updated`

*Code*: `signal players_updated(players)`

## Methods

### `link_service`

*Prototype*: `func link_service(service: Node) -> void`

### `pong`

*Prototype*: `func pong(peer_id: int) -> void`

### `spawn_synchronized_scene_on`

*Prototype*: `func spawn_synchronized_scene_on(peer_id: int, parent: NodePath, name: String, scene_path: String, guid: String, owner_peer_id: int, master_configuration: Dictionary) -> void`

### `spawn_synchronized_scene_broadcast`

*Prototype*: `func spawn_synchronized_scene_broadcast(parent: NodePath, name: String, scene_path: String, guid: String, owner_peer_id: int, master_configuration: Dictionary) -> void`

### `synchronize_node_broadcast`

*Prototype*: `func synchronize_node_broadcast(path: NodePath, data: Dictionary) -> void`

### `remove_synchronized_node_on`

*Prototype*: `func remove_synchronized_node_on(peer_id: int, path: NodePath) -> void`

### `remove_synchronized_node_broadcast`

*Prototype*: `func remove_synchronized_node_broadcast(path: NodePath) -> void`

### `synchronize_players_broadcast`

*Prototype*: `func synchronize_players_broadcast(players: Dictionary) -> void`

