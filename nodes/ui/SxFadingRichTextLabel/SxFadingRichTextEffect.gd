@tool
extends RichTextEffect
## Fading text effect.

## BBCode to use.
var bbcode := "sxgd-fadein"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
    var chars_count := char_fx.env["charscount"] as int
    var char_delay := char_fx.env["chardelay"] as float
    var fade_out_delay := char_fx.env["fadeoutdelay"] as float

    var time_per_char := 1 * char_delay
    var char_amount := time_per_char * char_fx.relative_index
    var total_time := time_per_char * chars_count

    if char_fx.elapsed_time > char_amount - time_per_char:
        var diff := char_fx.elapsed_time - char_amount
        if diff <= time_per_char:
            char_fx.color = SxColor.with_alpha_f(char_fx.color, SxMath.map(diff, 0, time_per_char, 0, 1))
        else:
            char_fx.color = SxColor.with_alpha_f(char_fx.color, 1)
    else:
        char_fx.color = SxColor.with_alpha_f(char_fx.color, 0)

    # Fade out
    if char_fx.elapsed_time > total_time:
        if char_fx.elapsed_time <= total_time + fade_out_delay:
            var diff := (total_time - char_fx.elapsed_time + fade_out_delay) / fade_out_delay
            char_fx.color = SxColor.with_alpha_f(char_fx.color, diff)
        else:
            char_fx.color = SxColor.with_alpha_f(char_fx.color, 0)

    return true
