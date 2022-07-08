# SxLog

**[◀️ Back](../readme.md)**

|    |     |
|----|-----|
|*Source*|[SxLog.gd](../../extensions/SxLog.gd)|
|*Inherits from*|`Reference`|
|*Globally exported as*|`SxLog`|

> Log utilities.  
## Enums

### `LogLevel`

*Prototype*: `enum LogLevel { TRACE, DEBUG, INFO, WARN, ERROR, CRITICAL }`

> Log level  
## Static methods

### `get_logger`

*Prototype*: `static func get_logger(name: String) -> Logger`

> Get logger from name.  
>   
> Example:  
>   var logger := SxLog.get_logger("my_logger")  
### `get_messages`

*Prototype*: `static func get_messages() -> Array`

### `pop_messages`

*Prototype*: `static func pop_messages() -> Array`

### `configure_log_levels`

*Prototype*: `static func configure_log_levels(conf: String) -> void`

> Configure log level for each loggers using a configuration string.  
>   
> Example:  
>   SxLog.configure_log_levels("info,my_logger=debug")  
### `set_max_log_level`

*Prototype*: `static func set_max_log_level(name: String, level: int) -> void`

> Set maximum log level for a specific logger.  
>   
> Example:  
>   SxLog.set_max_log_level("my_logger", LogLevel.WARN)  
### `trace`

*Prototype*: `static func trace(message: String, args: Array = []) -> void`

> Show a trace message on the root logger  
### `debug`

*Prototype*: `static func debug(message: String, args: Array = []) -> void`

> Show a debug message on the root logger  
### `info`

*Prototype*: `static func info(message: String, args: Array = []) -> void`

> Show an info message on the root logger  
### `warn`

*Prototype*: `static func warn(message: String, args: Array = []) -> void`

> Show a warn message on the root logger  
### `error`

*Prototype*: `static func error(message: String, args: Array = []) -> void`

> Show an error message on the root logger  
### `critical`

*Prototype*: `static func critical(message: String, args: Array = []) -> void`

> Show a critical message on the root logger  
## _LogData

|    |     |
|----|-----|
|*Inherits from*|`Node`|

### _LogData, Static methods

#### `get_messages`

*Prototype*: `static func get_messages() -> Array`

#### `add_message`

*Prototype*: `static func add_message(message: LogMessage) -> void`

#### `pop_messages`

*Prototype*: `static func pop_messages() -> Array`

## Utils

|    |     |
|----|-----|
|*Inherits from*|`Node`|

### Utils, Static methods

#### `level_to_string`

*Prototype*: `static func level_to_string(level: int) -> String`

#### `level_from_name`

*Prototype*: `static func level_from_name(name: String) -> int`

## LogMessage

|    |     |
|----|-----|
|*Inherits from*|`Node`|

> Log message  
### LogMessage, Public variables

#### `time`

*Code*: `var time: float`

#### `level`

*Code*: `var level: int`

#### `logger_name`

*Code*: `var logger_name: String`

#### `message`

*Code*: `var message: String`

#### `peer_id`

*Code*: `var peer_id: int`

### LogMessage, Static methods

#### `new_message`

*Prototype*: `static func new_message(time: float, level: int, name: String, message: String, peer_id: int = -1) -> LogMessage`

## Logger

|    |     |
|----|-----|
|*Inherits from*|`Reference`|

> Single logger handle  
### Logger, Public variables

#### `name`

*Code*: `var name: String`

#### `max_level`

*Code*: `var max_level: int`

#### `display_in_console`

*Code*: `var display_in_console: bool`

### Logger, Methods

#### `set_max_log_level`

*Prototype*: `func set_max_log_level(level: int) -> void`

> Set max log level for this logger  
#### `trace`

*Prototype*: `func trace(message: String, args: Array = []) -> void`

> Show a trace message  
#### `debug`

*Prototype*: `func debug(message: String, args: Array = []) -> void`

> Show a debug message  
#### `info`

*Prototype*: `func info(message: String, args: Array = []) -> void`

> Show an info message  
#### `warn`

*Prototype*: `func warn(message: String, args: Array = []) -> void`

> Show a warn message  
#### `error`

*Prototype*: `func error(message: String, args: Array = []) -> void`

> Show an error message  
#### `critical`

*Prototype*: `func critical(message: String, args: Array = []) -> void`

> Show a critical message  
