extends Object
class_name SxColor
## Color extensions.
##
## Additional methods to work with colors.

## Apply a float alpha value on a color.[br]
## Usage:
## [codeblock]
## var c := SxColor.with_alpha_f(Color.aqua, 0.5)
## [/codeblock]
static func with_alpha_f(color: Color, alpha: float) -> Color:
    var c := color
    c.a = alpha
    return c

## Apply an integer alpha value on a color.[br]
## Usage:
## [codeblock]
## var c := SxColor.with_alpha_i(Color.aqua, 127)
## [/codeblock]
static func with_alpha_i(color: Color, alpha: int) -> Color:
    return with_alpha_f(color, alpha / 255.0)

## Generate a random color without transparency.[br]
## Usage:
## [codeblock]
## var c := SxColor.rand()
## [/codeblock]
static func rand() -> Color:
    return Color8(
        SxRand.range_i(0, 255),
        SxRand.range_i(0, 255),
        SxRand.range_i(0, 255)
    )

## Generate a random color with a float alpha value.[br]
## Usage:
## [codeblock]
## var c := SxColor.rand_with_alpha_f(0.5)
## [/codeblock]
static func rand_with_alpha_f(alpha: float) -> Color:
    return Color8(
        SxRand.range_i(0, 255),
        SxRand.range_i(0, 255),
        SxRand.range_i(0, 255),
        int(alpha * 255.0)
    )

## Generate a random color with an integer alpha value.[br]
## Usage:
## [codeblock]
## var c := SxColor.rand_with_alpha_i(127)
## [/codeblock]
static func rand_with_alpha_i(alpha: int) -> Color:
    return Color8(
        SxRand.range_i(0, 255),
        SxRand.range_i(0, 255),
        SxRand.range_i(0, 255),
        alpha
    )
