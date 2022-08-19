# Random helpers.
extends Reference
class_name SxRand

# Generate a random integer between two values.
#
# Example:
#   var n := SxRand.range_i(1, 2)
static func range_i(from: int, to: int) -> int:
    return int(rand_range(from, to))

# Generate a random Vector2 between two values for each component.
#
# Example:
#   var n := SxRand.range_vec2(Vector2.ZERO, Vector2.ONE)
static func range_vec2(from: Vector2, to: Vector2) -> Vector2:
    return Vector2(
        rand_range(from.x, to.y),
        rand_range(from.y, to.y)
    )

# Generate a random boolean following a chance percentage.
#
# Example:
#   var n := SxRand.chance_bool(75)
static func chance_bool(chance: int) -> bool:
    return rand_range_i(0, 100) <= chance

# Choose a random value from an array.
#
# Example:
#   var v = SxRand.choice_array(75)
static func choice_array(array: Array):
    return array[range_i(0, len(array))]
