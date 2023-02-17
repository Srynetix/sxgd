extends Node
class_name SxRpcService

var client: SxClientRpc
var server: SxServerRpc
var sync_input: SxSyncInput

func _ready():
    client = SxClientRpc.new()
    add_child(client)

    server = SxServerRpc.new()
    add_child(server)

    sync_input = SxSyncInput.new()
    add_child(sync_input)

    client.link_service(self)
    server.link_service(self)

static func get_from_tree(tree: SceneTree):
    var target := tree.root.get_node_or_null("MainRpcService")
    if target == null:
        push_error("Cannot get MainRpcService from current tree %s. Make sure it exists at the location /root/MainRpcService." % tree)
    return target
