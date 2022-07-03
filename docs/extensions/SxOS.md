# SxOS

**[◀️ Back](../readme.md)**

|    |     |
|----|-----|
|*Source*|[SxOS.gd](../../extensions/SxOS.gd)|
|*Inherits from*|`Reference`|
|*Globally exported as*|`SxOS`|

> Helper methods around core functions  
## Static methods

### `set_window_size_str`

*Prototype*: `static func set_window_size_str(window_size: String) -> void`

> Set the window size from a WIDTHxHEIGHT string.  
>   
> Example:  
> ```gdscript  
> SxOS.set_window_size_str("1280x720")  
> ```  
### `is_mobile`

*Prototype*: `static func is_mobile() -> bool`

> Detect if the current system is a mobile environment.  
>   
> Example:  
> ```gdscript  
> if SxOS.is_mobile():  
>   print("Mobile !")  
> ```  
