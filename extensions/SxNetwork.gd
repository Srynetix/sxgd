# Network utilities.
#
# UUID generation was extracted from https://github.com/binogure-studio/godot-uuid/blob/master/uuid.gd

extends Object
class_name SxNetwork

const _MODULO_8_BIT = 256

# Shortcut to get the network unique ID
static func get_nuid(node: Node, multiplayer_node_path: NodePath) -> int:
    var multiplayer_api := node.get_tree().get_multiplayer(multiplayer_node_path)
    if multiplayer_api.multiplayer_peer:
        return multiplayer_api.get_unique_id()
    else:
        return -1

# Shortcut to get the sender network unique ID
static func get_sender_nuid(node: Node, multiplayer_node_path: NodePath) -> int:
    var multiplayer_api := node.get_tree().get_multiplayer(multiplayer_node_path)
    if multiplayer_api.multiplayer_peer:
        return multiplayer_api.get_remote_sender_id()
    else:
        return -1

# Shortcut to check if the current NUID is root
static func is_root(node: Node, multiplayer_node_path := NodePath("")) -> bool:
    return get_nuid(node, multiplayer_node_path) == 1

# Generate a network name from a node name and a UUID
static func generate_network_name(name: String, guid: String) -> String:
    # Edge case: if the name and the GUID is the same, just return the name
    if name == guid:
        return name

    if guid != "":
        return "%s#%s" % [name, guid]
    else:
        return name

# Check if a node is a network master
static func is_multiplayer_authority(node: Node, multiplayer_node_path: NodePath) -> bool:
    var multiplayer_api = node.get_tree().get_multiplayer(multiplayer_node_path)
    if multiplayer_api.multiplayer_peer == null:
        return true
    else:
        return node.is_multiplayer_authority()

# Get a node network master ID
static func get_multiplayer_authority(node: Node, multiplayer_node_path: NodePath) -> int:
    var multiplayer_api = node.get_tree().get_multiplayer(multiplayer_node_path)
    if multiplayer_api.multiplayer_peer == null:
        return 1
    else:
        return node.get_multiplayer_authority()

# Check if a node is a network server
static func is_server(tree: SceneTree, multiplayer_node_path: NodePath) -> bool:
    var multiplayer_api := tree.get_multiplayer(multiplayer_node_path)
    if multiplayer_api.multiplayer_peer == null:
        return true
    else:
        return multiplayer_api.is_server()

# Check if a network peer is enabled for a scene tree
static func is_network_enabled(tree: SceneTree, multiplayer_node_path: NodePath) -> bool:
    var multiplayer_api := tree.get_multiplayer(multiplayer_node_path)
    return multiplayer_api.multiplayer_peer != null

# Generate a UUID4 string
static func uuid4() -> String:
    # 16 random bytes with the bytes on index 6 and 8 modified
    var b := _uuidbin()

    return '%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x' % [
        # low
        b[0], b[1], b[2], b[3],

        # mid
        b[4], b[5],

        # hi
        b[6], b[7],

        # clock
        b[8], b[9],

        # clock
        b[10], b[11], b[12], b[13], b[14], b[15]
    ]

static func _rand_u8() -> int:
    # Randomize every time to minimize the risk of collisions
    randomize()

    return randi() % _MODULO_8_BIT

static func _uuidbin() -> Array:
    # 16 random bytes with the bytes on index 6 and 8 modified
    return [
        _rand_u8(), _rand_u8(), _rand_u8(), _rand_u8(),
        _rand_u8(), _rand_u8(), ((_rand_u8()) & 0x0f) | 0x40, _rand_u8(),
        ((_rand_u8()) & 0x3f) | 0x80, _rand_u8(), _rand_u8(), _rand_u8(),
        _rand_u8(), _rand_u8(), _rand_u8(), _rand_u8(),
    ]
