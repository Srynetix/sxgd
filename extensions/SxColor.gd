extends Reference
class_name SxColor

# Apply a float alpha value on a color.
#
# Example:
#   var c := SxColor.with_alpha_f(Color.aqua, 0.5)
static func with_alpha_f(color: Color, alpha: float) -> Color:
    var c := color
    c.a = alpha
    return c

# Apply an integer alpha value on a color.
#
# Example:
#   var c := SxColor.with_alpha_i(Color.aqua, 127)
static func with_alpha_i(color: Color, alpha: int) -> Color:
    return with_alpha_f(color, alpha / 255.0)

# Generate a random color without transparency.
#
# Example:
#   var c := SxColor.rand()
static func rand() -> Color:
    return Color8(
        SxMath.rand_range_i(0, 255),
        SxMath.rand_range_i(0, 255),
        SxMath.rand_range_i(0, 255)
    )

# Generate a random color with a float alpha value.
#
# Example:
#   var c := SxColor.rand_with_alpha_f(0.5)
static func rand_with_alpha_f(alpha: float) -> Color:
    return Color8(
        SxMath.rand_range_i(0, 255),
        SxMath.rand_range_i(0, 255),
        SxMath.rand_range_i(0, 255),
        alpha * 255
    )

# Generate a random color with an integer alpha value.
#
# Example:
#   var c := SxColor.rand_with_alpha_i(127)
static func rand_with_alpha_i(alpha: int) -> Color:
    return Color8(
        SxMath.rand_range_i(0, 255),
        SxMath.rand_range_i(0, 255),
        SxMath.rand_range_i(0, 255),
        alpha
    )
