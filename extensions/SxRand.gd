# Random helpers.
extends Object
class_name SxRand

# Generate a random integer between two values.
#
# Example:
#   var n := SxRand.range_i(1, 2)
static func range_i(from: int, to: int) -> int:
    return int(randf_range(from, to))

# Generate a random Vector2 between two values for each component.
#
# Example:
#   var n := SxRand.range_vec2(Vector2.ZERO, Vector2.ONE)
static func range_vec2(from: Vector2, to: Vector2) -> Vector2:
    return Vector2(
        randf_range(from.x, to.y),
        randf_range(from.y, to.y)
    )

# Generate a random unit Vector2.
#
# Example:
#   var n := SxRand.unit_vec2()
static func unit_vec2() -> Vector2:
    return Vector2(
        randf_range(-1, 1),
        randf_range(-1, 1)
    ).normalized()

# Generate a random boolean following a chance percentage.
#
# Example:
#   var n := SxRand.chance_bool(75)
static func chance_bool(chance: int) -> bool:
    return range_i(0, 100) <= chance

# Choose a random value from an array.
#
# Example:
#   var v = SxRand.choice_array(75)
static func choice_array(array: Array):
    return array[range_i(0, len(array))]
