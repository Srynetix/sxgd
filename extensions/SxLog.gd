extends Reference
class_name SxLog

# Log level
enum LogLevel { TRACE, DEBUG, INFO, WARN, ERROR, CRITICAL }

# Log message
class LogMessage:
    extends Node

    var level: int
    var logger_name: String
    var message: String
    var peer_id: int

    static func new_message(level: int, name: String, message: String):
        var msg = LogMessage.new()
        msg.level = level
        msg.name = name
        msg.message = message
        return msg

# Single logger handle
class Logger:
    extends Reference

    var name: String
    var max_level: int
    var display_in_console: bool
    var _messages := Array()

    func _init(name: String, max_level: int, display_in_console: bool):
        self.name = name
        self.max_level = max_level
        self.display_in_console = display_in_console

    # Set max log level for this logger
    func set_max_log_level(level: int) -> void:
        self.max_level = level

    # Show a trace message
    func trace(message: String, args: Array = []) -> void:
        _log(LogLevel.TRACE, message, args)

    # Show a debug message
    func debug(message: String, args: Array = []) -> void:
        _log(LogLevel.DEBUG, message, args)

    # Show an info message
    func info(message: String, args: Array = []) -> void:
        _log(LogLevel.INFO, message, args)

    # Show a warn message
    func warn(message: String, args: Array = []) -> void:
        _log(LogLevel.WARN, message, args)

    # Show an error message
    func error(message: String, args: Array = []) -> void:
        _log(LogLevel.ERROR, message, args)

    # Show a critical message
    func critical(message: String, args: Array = []) -> void:
        _log(LogLevel.CRITICAL, message, args)

    func _is_level_shown(level: int) -> bool:
        return level >= max_level

    static func _level_to_string(level: int) -> String:
        match level:
            LogLevel.TRACE:
                return "trace"
            LogLevel.DEBUG:
                return "debug"
            LogLevel.INFO:
                return "info"
            LogLevel.WARN:
                return "warn"
            LogLevel.ERROR:
                return "error"

        return "critical"

    func _show_log_line(level: int, line: String) -> void:
        if !display_in_console:
            return

        if level < LogLevel.WARN:
            print(line)
        else:
            printerr(line)

    func _format_args(message: String, args: Array = []) -> String:
        var output = message
        for a in args:
            output += " " + str(a)
        return output

    func _format_log(level: int, message: String, args: Array = []) -> String:
        var level_str = _level_to_string(level).to_upper()
        return "[{level_str}] [{name}] {args}".format({
            "level_str": level_str,
            "name": name,
            "args": _format_args(message, args)
        })

    func _log(level: int, message: String, args: Array = []) -> void:
        if !_is_level_shown(level):
            return

        _messages.append(
            LogMessage.new_message(
                level, name, _format_args(message, args)
            )
        )
        _show_log_line(level, _format_log(level, message, args))

static func _level_from_name(name: String) -> int:
    match name:
        "trace":
            return LogLevel.TRACE
        "debug":
            return LogLevel.DEBUG
        "info":
            return LogLevel.INFO
        "warn":
            return LogLevel.WARN
        "error":
            return LogLevel.ERROR
        "critical":
            return LogLevel.CRITICAL

    printerr("[SxLog] Unknown log level %s. Defaulting to INFO" % name)
    return LogLevel.INFO

const _static_data = {
    "loggers": {},
}

const SHOW_IN_CONSOLE = true
const DEFAULT_LOG_LEVEL = LogLevel.INFO

# Get logger from name.
#
# Example:
#   var logger = SxLog.get_logger("my_logger")
static func get_logger(name: String) -> Logger:
    var loggers = _static_data["loggers"]
    if loggers.has(name):
        return _static_data["loggers"][name]
    else:
        var logger = Logger.new(name, DEFAULT_LOG_LEVEL, SHOW_IN_CONSOLE)
        _static_data["loggers"][name] = logger
        return logger

# Configure log level for each loggers using a configuration string.
#
# Example:
#   SxLog.configure_log_levels("info,my_logger=debug")
static func configure_log_levels(conf: String) -> void:
    var all_split = conf.split(",")
    for log_conf in all_split:
        var split = log_conf.split("=")
        var len_split = len(split)
        if len_split == 0:
            continue
        elif len_split == 1:
            set_max_log_level("root", _level_from_name(split[0]))
        elif len_split == 2:
            set_max_log_level(split[0], _level_from_name(split[0]))

# Set maximum log level for a specific logger.
#
# Example:
#   SxLog.set_max_log_level("my_logger", LogLevel.WARN)
static func set_max_log_level(name: String, level: int) -> void:
    var logger = get_logger(name)
    logger.set_max_log_level(level)

# Show a trace message on the root logger
static func trace(message: String, args: Array = []) -> void:
    var root_logger = get_logger("root")
    root_logger.trace(message, args)

# Show a debug message on the root logger
static func debug(message: String, args: Array = []) -> void:
    var root_logger = get_logger("root")
    root_logger.debug(message, args)

# Show an info message on the root logger
static func info(message: String, args: Array = []) -> void:
    var root_logger = get_logger("root")
    root_logger.info(message, args)

# Show a warn message on the root logger
static func warn(message: String, args: Array = []) -> void:
    var root_logger = get_logger("root")
    root_logger.warn(message, args)

# Show an error message on the root logger
static func error(message: String, args: Array = []) -> void:
    var root_logger = get_logger("root")
    root_logger.error(message, args)

# Show a critical message on the root logger
static func critical(message: String, args: Array = []) -> void:
    var root_logger = get_logger("root")
    root_logger.critical(message, args)
