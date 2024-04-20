# Network utilities.
#
# UUID generation was extracted from https://github.com/binogure-studio/godot-uuid/blob/master/uuid.gd

extends Object
class_name SxNetwork

const _MODULO_8_BIT = 256

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
