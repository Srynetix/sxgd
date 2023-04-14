extends Object
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
static func align_with_y(transform: Transform3D, new_y: Vector3) -> Transform3D:
    transform.basis.y = new_y
    transform.basis.x = -transform.basis.z.cross(new_y)
    transform.basis = transform.basis.orthonormalized()
    return transform

# Align a transform with a Y vector using interpolation.
#
# Example:
#   var xform := SxMath.interpolate_align_with_y(transform, Vector3(1, 1, 1), 0.25)
static func interpolate_align_with_y(transform: Transform3D, new_y: Vector3, weight: float) -> Transform3D:
    var aligned := align_with_y(transform, new_y)
    return transform.interpolate_with(aligned, weight)

# Map a float value from one set of bounds to another.
#
# Example:
#   var n := SxMath.map(10, 0, 10, 0, 1)
static func map(value: float, istart: float, istop: float, ostart: float, ostop: float) -> float:
    return ostart + ((ostop - ostart) * ((value - istart) / (istop - istart)))
