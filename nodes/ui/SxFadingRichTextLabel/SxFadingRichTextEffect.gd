tool
extends RichTextEffect
class_name SxFadingRichTextEffect

var bbcode: String = "sxgd-fadein"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
    var chars_count: int = char_fx.env["charscount"]
    var char_delay: float = char_fx.env["chardelay"]
    var fade_out_delay: float = char_fx.env["fadeoutdelay"]

    var time_per_char = 1 * char_delay
    var char_amount = time_per_char * char_fx.absolute_index
    var total_time = time_per_char * chars_count

    if char_fx.elapsed_time > char_amount - time_per_char:
        var diff = char_fx.elapsed_time - char_amount
        if diff <= time_per_char:
            char_fx.color = SxColor.with_alpha_f(char_fx.color, SxMath.map(diff, 0, time_per_char, 0, 1))
        else:
            char_fx.color = SxColor.with_alpha_f(char_fx.color, 1)
    else:
        char_fx.color = SxColor.with_alpha_f(char_fx.color, 0)

    # Fade out
    if char_fx.elapsed_time > total_time:
        if char_fx.elapsed_time <= total_time + fade_out_delay:
            var diff = (total_time - char_fx.elapsed_time + fade_out_delay) / fade_out_delay
            char_fx.color = SxColor.with_alpha_f(char_fx.color, diff)
        else:
            char_fx.color = SxColor.with_alpha_f(char_fx.color, 0)

    return true
