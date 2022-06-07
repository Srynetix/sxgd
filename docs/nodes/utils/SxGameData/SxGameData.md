# SxGameData

**[◀️ Back](../readme.md)**

|    |     |
|----|-----|
|*Source*|[SxGameData.gd](../../../../nodes/utils/SxGameData/SxGameData.gd)|
|*Inherits from*|`Node`|
|*Globally exported as*|`SxGameData`|

> A general-purpose in-memory key-value store, to be used through inheritance and autoload.  
## Methods

### `store_static_value`

*Prototype*: `func store_static_value(name: String, value, category: String = "default") -> void`

> Store static value in game data.  
> Static data is not persisted to disk.  
>   
> Example:  
>   data.store_static_value("levels", json_levels)  
>   data.store_static_value("my_data", my_data, "my_category")  
### `load_static_value`

*Prototype*: `func load_static_value(name: String, orDefault = null, category: String = "default")`

> Load static value from game data.  
> Static data is not persisted to disk.  
>   
> Example:  
>   var levels = data.load_static_value("levels", Dictionary())  
>   var levels = data.load_static_value("my_data", Dictionary(), "my_category")  
### `store_value`

*Prototype*: `func store_value(name: String, value, category: String = "default") -> void`

> Store value in game data.  
>   
> Example:  
>   data.store_value("key", 123)  
>   data.store_value("key2", "hello")  
>   data.store_value("key3", "hello", "my_category")  
### `load_value`

*Prototype*: `func load_value(name: String, orDefault = null, category: String = "default")`

> Load value from game data.  
>   
> Example:  
>   var d1 = data.load_value("key")  
>   var d2 = data.load_value("key", 123)  # returns 123 if key is missing  
>   var d2 = data.load_value("key2", 123, "my_category")  
### `increment`

*Prototype*: `func increment(name: String, category: String = "default") -> int`

> Increment key and returns the value.  
> Starts from 0 if key does not exist.  
>   
> Example:  
>   var value = data.increment("key")  
>   var value = data.increment("key", "my_category")  
### `decrement`

*Prototype*: `func decrement(name: String, category: String = "default") -> int`

> Decrement key and returns the value.  
> Starts from 0 if key does not exist.  
>   
> Example:  
>   var value = data.decrement("key")  
>   var value = data.decrement("key", "my_category")  
### `remove`

*Prototype*: `func remove(name: String, category: String = "default") -> bool`

> Remove key from game data.  
> Returns true if key was found, false if not.  
>   
> Example:  
>   data.remove("key")  
>   data.remove("key", "my_category")  
### `has_value`

*Prototype*: `func has_value(name: String, category: String = "default") -> bool`

> Test if game data has a key.  
>   
> Example:  
>   var exists = data.has_value("key")  
>   var exists = data.has_value("key", "my_category")  
### `persist_to_disk`

*Prototype*: `func persist_to_disk(path: String = "user://save.dat") -> void`

> Persist game data to disk at a specific path.  
>   
> Example:  
>   data.persist_to_disk("user://my_path.dat")  
### `load_from_disk`

*Prototype*: `func load_from_disk(path: String = "user://save.dat") -> void`

> Load game data from disk at a specific path.  
>   
> Example:  
>   data.load_from_disk("user://my_path.dat")  
### `clear`

*Prototype*: `func clear() -> void`

> Clear all non-static data.  
### `clear_category`

*Prototype*: `func clear_category(category: String) -> void`

> Clear all non-static data from category.  
### `dump_category`

*Prototype*: `func dump_category(category: String) -> String`

> Dump each variable from a specific category.  
### `dump_all`

*Prototype*: `func dump_all() -> String`

> Dump all variables.  
