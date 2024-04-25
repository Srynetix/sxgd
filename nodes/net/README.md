# SxNet nodes overview

The SxNet nodes can be used to quickly implement an quite opinionated multiplayer "strategy".
Each node is optional and can be replaced by a manual implementation.

You can check a quick multiplayer chat implementation in the `TestMultiplayerChat` scene.

## Multiplayer peers (SxNetServerPeer / SxNetClientPeer)

The multiplayer peers nodes (`SxNetServerPeer` for the server and `SxNetClientPeer` for the client) are scoped by default. Which means they use a custom MultiplayerAPI instance and handle a multiplayer tree as a child.

The main advantage of this strategy is that you can have as many servers and clients that you want at the same time, on the same game executable (perfect for ad-hoc multiplayer or listen server mode).

So let's say you want to create a server and/or a client in an existing scene.
Suppose you have this scene tree, with 2 buttons:

```
* MyScene (Control)
\--* HostButton (Button)
\--* JoinButton (Button)
```

To create a server (in script), you need to do this:

```gdscript
# MyScene.gd

@onready var _host_button := $HostButton as Button
@onready var _join_button := $JoinButton as Button

var server: SxNetServerPeer
var client: SxNetClientPeer

func _ready() -> void:
    # When "Host" button is pressed...
    _host_button.pressed.connect(func():
        # Create a server instance with a port and a max clients count.
        server = SxNetServerPeer.new()
        server.port = 12340
        server.max_clients = 16

        # Add the server to the scene tree.
        add_child(server)
    )

    # When "Join" button is pressed...
    _join_button.pressed.connect(func():
        # Create a client instance with an address and a port.
        # Here we will use "localhost" to connect to the local server instance.
        client = SxNetClientPeer.new()
        client.server_address = "localhost"
        client.server_port = 12340

        # Add the client to the scene tree.
        add_child(client)
    )
```

If you press the two buttons ("Host" at first then "Join"), you should end with the following scene tree:

```
* MyScene (Control)
\-* HostButton (Button)
\-* JoinButton (Button)
\-* SxNetServerPeer (SxNetServerPeer)
  \-* SxNetPeerProtocol (SxNetPeerProtocol)
\-* SxNetClientPeer (SxNetClientPeer)
  \-* SxNetPeerProtocol (SxNetPeerProtocol)
```

The two peers now manage their own multiplayer tree, and you can now use the `SxNetPeerProtocol` node (through the `protocol` attribute on both peers).

(This setting is mostly the `TestMultiplayerDummy` sample).

## Message protocol (SxNetPeerProtocol)

Okay, so now, you can communicate between the server and the client (both ways) using the `SxNetPeerProtocol` node, through each peer `protocol` attribute.

```gdscript
# In MyScene.gd

# Arbitrary enum which represents message sent to the server
enum MessageToServer {
  # Sent when a player is ready
  Ready,
}

# Arbitrary enum which represents message sent to clients
enum MessageToClient {
  # Sent when a player is ready
  PlayerReady
}

func _ready() -> void:
  # ...previous code...

  # Listen on successful connection to the server.
  client.server_connected.connect(func():

    # Let's say the client is ready after 3 seconds.
    await get_tree().create_timer(3).timeout

    # There we declare an arbitrary payload.
    # You can omit the payload if not needed.
    var payload = {"foo": "bar"}
    client.protocol.send_to_server(MessageToServer.Ready, payload)
  )

  # Listen on incoming messages from clients through the protocol.
  server.on_message_for_server(func(peer_id, kind, payload):
    if kind == MessageToServer.Ready:
      # Okay, do something with the info.
      # ...

      # Then send back to all peers that this specific player is ready, using the
      # payload to indicate the peer ID.
      server.protocol.send_to_all_clients(MessageToClient.PlayerReady, {"peer_id": peer_id})
  )

  # Listen on incoming messages from server through the protocol.
  client.on_message_for_client(func(kind, payload):
    if kind == MessageToClient.PlayerReady:
      var peer_id := payload["peer_id"] as int
      print("Player %d is ready!" % peer_id)
  )
```

And there you go.

## Helper handlers (SxNetServerHandler / SxNetClientHandler)

If you want some "structure" around peers and protocol, you can also use the helper handlers (SxNetServerHandler and SxNetClientHandler).

It's mostly like the usage above (with the SxNetPeerProtocol), but using methods to override instead of signal connections to make.

Here's a sample doing the same thing as previously, but with handlers.

```gdscript
# In MyScene.gd

# Arbitrary enum which represents message sent to the server
enum MessageToServer {
  # Sent when a player is ready
  Ready,
}

# Arbitrary enum which represents message sent to clients
enum MessageToClient {
  # Sent when a player is ready
  PlayerReady
}

class MyServerHandler:
  extends SxNetServerHandler

  # The handler exposes `peer` (SxNetServerPeer) and `protocol` (SxNetPeerProtocol).

  func _on_message(peer_id: int, kind: Variant, payload: Variant) -> void:
    if kind == MessageToServer.Ready:
      # Okay, do something with the info.
      # ...

      # Then send back to all peers that this specific player is ready, using the
      # payload to indicate the peer ID.
      protocol.send_to_all_clients(MessageToClient.PlayerReady, {"peer_id": peer_id})

class MyClientHandler
  extends SxNetClientHandler

  # The handler exposes `peer` (SxNetClientPeer) and `protocol` (SxNetPeerProtocol).

  func _connected_to_server() -> void:
    # Let's say the client is ready after 3 seconds.
    await get_tree().create_timer(3).timeout

    # There we declare an arbitrary payload.
    # You can omit the payload if not needed.
    var payload = {"foo": "bar"}
    protocol.send_to_server(MessageToServer.Ready, payload)

  func _on_message(kind: Variant, payload: Variant) -> void:
    if kind == MessageToClient.PlayerReady:
      var peer_id := payload["peer_id"] as int
      print("Player %d is ready!" % peer_id)
```

As I said, it's mostly the same thing, but organized differently.