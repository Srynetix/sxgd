extends Object
class_name SxMath
## Math extensions.
##
## Additional methods to work with maths.

## Lerp a [Vector3] towards another using weight.[br]
##
## Usage:
## [codeblock]
## var vec3 := SxMath.lerp_vector3(vec1, vec2, 0.25)
## [/codeblock]
static func lerp_vector3(from: Vector3, to: Vector3, weight: float) -> Vector3:
    return Vector3(
        lerp(from.x, to.x, weight),
        lerp(from.y, to.y, weight),
        lerp(from.z, to.z, weight)
    )

## Align a transform with a Y vector.[br]
##
## Useful to align an object with the floor or a wall.[br]
##
## Usage:
## [codeblock]
## var xform := SxMath.align_with_y(transform, Vector3(1, 1, 1))
## [/codeblock]
static func align_with_y(transform: Transform3D, new_y: Vector3) -> Transform3D:
    transform.basis.y = new_y
    transform.basis.x = -transform.basis.z.cross(new_y)
    transform.basis = transform.basis.orthonormalized()
    return transform

static func align_with_normal(transform: Transform3D, new_y: Vector3) -> Transform3D:
    # Source: https://github.com/godotengine/godot/issues/85903#issuecomment-1846245217
    var normalized_y := transform.basis.y.normalized()
    var cos_value := normalized_y.dot(new_y)
    if cos_value >= 0.99:
        # No need to align
        return transform

    var alpha_angle := acos(cos_value)
    var axis := normalized_y.cross(new_y).normalized()
    if axis == Vector3.ZERO:
        axis = Vector3.FORWARD

    var prev_position = transform.origin
    var rotated = transform.rotated(axis, alpha_angle)
    rotated.origin = prev_position
    return rotated

## Align a transform with a Y vector using interpolation.[br]
## See [method align_with_y].
static func interpolate_align_with_y(transform: Transform3D, new_y: Vector3, weight: float) -> Transform3D:
    var aligned := align_with_y(transform, new_y)
    return transform.interpolate_with(aligned, weight)

## Map a float value from one set of bounds to another.[br]
##
## Usage:
## [codeblock]
## var n := SxMath.map(10, 0, 10, 0, 1)
## [/codeblock]
static func map(value: float, istart: float, istop: float, ostart: float, ostop: float) -> float:
    return ostart + ((ostop - ostart) * ((value - istart) / (istop - istart)))
