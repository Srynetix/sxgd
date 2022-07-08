extends Reference
class_name SxMath

# Lerp a Vector3 towards another using weight.
#
# Example:
#   var vec3 := SxMath.lerp_vector3(vec1, vec2, 0.25)
static func lerp_vector3(from: Vector3, to: Vector3, weight: float) -> Vector3:
    return Vector3(
        lerp(from.x, to.x, weight),
        lerp(from.y, to.y, weight),
        lerp(from.z, to.z, weight)
    )

# Align a transform with a Y vector.
#
# Example:
#   var xform := SxMath.align_with_y(transform, Vector3(1, 1, 1))
static func align_with_y(transform: Transform, new_y: Vector3) -> Transform:
    transform.basis.y = new_y
    transform.basis.x = -transform.basis.z.cross(new_y)
    transform.basis = transform.basis.orthonormalized()
    return transform

# Align a transform with a Y vector using interpolation.
#
# Example:
#   var xform := SxMath.interpolate_align_with_y(transform, Vector3(1, 1, 1), 0.25)
static func interpolate_align_with_y(transform: Transform, new_y: Vector3, weight: float) -> Transform:
    var aligned := align_with_y(transform, new_y)
    return transform.interpolate_with(aligned, weight)

# Generate a random integer between two values.
#
# Example:
#   var n := SxMath.rand_range_i(1, 2)
static func rand_range_i(from: int, to: int) -> int:
    return int(rand_range(from, to))

# Generate a random Vector2 between two values for each component.
#
# Example:
#   var n := SxMath.rand_range_vec2(Vector2.ZERO, Vector2.ONE)
static func rand_range_vec2(from: Vector2, to: Vector2) -> Vector2:
    return Vector2(
        rand_range(from.x, to.y),
        rand_range(from.y, to.y)
    )

# Map a float value from one set of bounds to another.
#
# Example:
#   var n := SxMath.map(10, 0, 10, 0, 1)
static func map(value: float, istart: float, istop: float, ostart: float, ostop: float) -> float:
    return ostart + ((ostop - ostart) * ((value - istart) / (istop - istart)))
