# SxFadingRichTextLabel

**[◀️ Back](../readme.md)**

|    |     |
|----|-----|
|*Source*|[SxFadingRichTextLabel.gd](../../../../nodes/ui/SxFadingRichTextLabel/SxFadingRichTextLabel.gd)|
|*Inherits from*|`RichTextLabel`|
|*Globally exported as*|`SxFadingRichTextLabel`|

> A wrapped RichTextLabel with a per-character fade-in effect.  
## Enums

### `Alignment`

*Prototype*: `enum Alignment { LEFT, RIGHT }`

## Signals

### `shown`

*Code*: `signal shown()`

> Text was completely shown  
## Exports

### `autoplay`

*Code*: `export var autoplay: bool = false`

> Autoplay the text animation  
### `char_delay`

*Code*: `export var char_delay: float = 0.1`

> Delay per character, in seconds  
### `fade_out_delay`

*Code*: `export var fade_out_delay: float = 2`

> Fade out delay, in seconds  
### `text_alignment`

*Code*: `export var text_alignment = Alignment.LEFT`

> Text alignment  
## Methods

### `fade_in`

*Prototype*: `func fade_in() -> void`

> Start the "fade in" animation  
>   
> Example:  
>   label.fade_in()  
### `update_text`

*Prototype*: `func update_text(text: String) -> void`

> Update text to display and reset the animation.  
> It will not automatically replay the animation, even with "autoplay" set.  
>   
> Example:  
>   label.update_text("MyText")  
>   label.fade_in()  
