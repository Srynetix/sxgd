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
### `list_files_in_directory`

*Prototype*: `static func list_files_in_directory(path: String, filters: Array) -> Array`

> List all files in a directory.  
## DirOrFile

|    |     |
|----|-----|
|*Inherits from*|`Reference`|

> Represents a path: a directory or a file  
### DirOrFile, Enums

#### `Type`

*Prototype*: `enum Type {`

### DirOrFile, Public variables

#### `name`

*Code*: `var name := "" as String`

#### `path`

*Code*: `var path := "" as String`

#### `type`

*Code*: `var type := Type.DIRECTORY as int`

### DirOrFile, Static methods

#### `type_to_string`

*Prototype*: `static func type_to_string(type: int) -> String`

### DirOrFile, Methods

#### `is_file`

*Prototype*: `func is_file() -> bool`

#### `is_directory`

*Prototype*: `func is_directory() -> bool`

