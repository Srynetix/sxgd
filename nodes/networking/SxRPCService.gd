extends Node
class_name SxRPCService

var client: SxClientRPC
var server: SxServerRPC
var sync_input: SxSyncInput

func _ready():
    client = SxClientRPC.new()
    add_child(client)

    server = SxServerRPC.new()
    add_child(server)

    sync_input = SxSyncInput.new()
    add_child(sync_input)

    client.link_service(self)
    server.link_service(self)

static func get_from_tree(tree: SceneTree):
    var target := tree.root.get_node_or_null("MainRPCService")
    if target == null:
        push_error("Cannot get MainRPCService from current tree %s. Make sure it exists at the location /root/MainRPCService." % tree)
    return target
