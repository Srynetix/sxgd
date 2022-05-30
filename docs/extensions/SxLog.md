# SxLog - Global logging facility

*Source*: [SxLog.gd](../../extensions/SxLog.gd)

This extension (which is a kind of global node) allows to manipulate loggers with log levels (as in `Python`), with a global configuration mechanism based on a string value (as in `Rust`).

Six log levels are available, from lowest to highest: *TRACE*, *DEBUG*, *INFO*, *WARN*, *ERROR* and *CRITICAL*

## Static methods

### `get_logger`
`SxLog.get_logger(name: String) -> Logger`  
Get or create a logger with a specific name.  
*Example*: `SxLog.get_logger("my_logger")`

### `configure_log_levels`
`SxLog.configure_log_levels(conf: String) -> void`  
Configure log level for each loggers using a configuration string.  
*Example*: `SxLog.configure_log_levels("info,my_logger=debug")`

### `set_max_log_level`
`SxLog.set_max_log_level(name: String, level: int) -> void`  
Set maximum log level for a specific logger.  
*Example*: `SxLog.set_max_log_level("my_logger", SxLog.LogLevel.ERROR)`

### `trace`
`SxLog.trace(message: String, args: Array = []) -> void`  
Show a trace message on the root logger.

### `debug`
`SxLog.debug(message: String, args: Array = []) -> void`  
Show a debug message on the root logger.

### `info`
`SxLog.info(message: String, args: Array = []) -> void`  
Show an info message on the root logger.

### `warn`
`SxLog.warn(message: String, args: Array = []) -> void`  
Show a warn message on the root logger.

### `error`
`SxLog.error(message: String, args: Array = []) -> void`  
Show an error message on the root logger.

### `critical`
`SxLog.critical(message: String, args: Array = []) -> void`  
Show a critical message on the root logger.

## `Logger` class, methods

### `set_max_log_level`
`Logger.set_max_log_level(level: int) -> void`  
Set maximum log level on current logger.  
*Example*:

```
var my_logger = SxLog.get_logger("my_logger")
my_logger.set_max_log_level(SxLog.LogLevel.ERROR)
```

### `trace`
`Logger.trace(message: String, args: Array = []) -> void`  
Show a trace message on current logger.

### `debug`
`Logger.debug(message: String, args: Array = []) -> void`  
Show a debug message on current logger.

### `info`
`Logger.info(message: String, args: Array = []) -> void`  
Show an info message on current logger.

### `warn`
`Logger.warn(message: String, args: Array = []) -> void`  
Show a warn message on current logger.

### `error`
`Logger.error(message: String, args: Array = []) -> void`  
Show an error message on current logger.

### `critical`
`Logger.critical(message: String, args: Array = []) -> void`  
Show a critical message on current logger.