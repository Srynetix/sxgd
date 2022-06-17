# SxFAFont

**[◀️ Back](../readme.md)**

|    |     |
|----|-----|
|*Source*|[SxFAFont.gd](../../../modules/SxFontAwesome/SxFAFont.gd)|
|*Inherits from*|`Reference`|
|*Globally exported as*|`SxFAFont`|

> Font management wrapper around FontAwesome.  
## Enums

### `Family`

*Prototype*: `enum Family {`

> Font family  
## Static methods

### `create_fa_font`

*Prototype*: `static func create_fa_font(family: int, size: int) -> DynamicFont`

> Lazily create a FontAwesome font, using a specific font family and a size.  
> If the font already exists, it will be returned.  
> If not, it will be created.  
### `get_icon_code`

*Prototype*: `static func get_icon_code(name: String) -> int`

> Get the icon unicode from its string representation.  
