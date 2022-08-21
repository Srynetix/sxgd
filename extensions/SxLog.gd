# Log utilities.
extends Reference
class_name SxLog

# Log level
enum LogLevel { TRACE, DEBUG, INFO, WARN, ERROR, CRITICAL }

class _LogData:
    const _static_data := {"messages": [], "cursor": 0}

    static func get_messages() -> Array:
        return _static_data["messages"]

    static func add_message(message: LogMessage) -> void:
        _static_data["messages"].append(message)

    static func pop_messages() -> Array:
        var messages := _static_data["messages"] as Array
        _static_data["messages"] = []
        return messages

class _LogUtils:
    static func level_to_string(level: int) -> String:
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

    static func level_from_name(name: String) -> int:
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

# Log message
class LogMessage:
    extends Node

    var time: float
    var level: int
    var logger_name: String
    var message: String
    var peer_id: int

    static func new_message(time: float, level: int, name: String, message: String, peer_id: int = -1) -> LogMessage:
        var msg := LogMessage.new()
        msg.time = time
        msg.level = level
        msg.logger_name = name
        msg.message = message
        msg.peer_id = peer_id
        return msg

# Single logger handle
class Logger:
    extends Reference

    var name: String
    var max_level: int
    var display_in_console: bool

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

    # Show a trace message for a method name
    func trace_m(method: String, message: String, args: Array = []) -> void:
        _log_method(LogLevel.TRACE, method, message, args)

    # Show a debug message for a method name
    func debug_m(method: String, message: String, args: Array = []) -> void:
        _log_method(LogLevel.DEBUG, method, message, args)

    # Show an info message for a method name
    func info_m(method: String, message: String, args: Array = []) -> void:
        _log_method(LogLevel.INFO, method, message, args)

    # Show a warn message for a method name
    func warn_m(method: String, message: String, args: Array = []) -> void:
        _log_method(LogLevel.WARN, method, message, args)

    # Show an error message for a method name
    func error_m(method: String, message: String, args: Array = []) -> void:
        _log_method(LogLevel.ERROR, method, message, args)

    # Show a critical message for a method name
    func critical_m(method: String, message: String, args: Array = []) -> void:
        _log_method(LogLevel.CRITICAL, method, message, args)

    # Show a trace message for a peer ID and method name
    func trace_mn(peer_id: int, method: String, message: String, args: Array = []) -> void:
        _log_method_network(LogLevel.TRACE, peer_id, method, message, args)

    # Show a debug message for a peer ID and method name
    func debug_mn(peer_id: int, method: String, message: String, args: Array = []) -> void:
        _log_method_network(LogLevel.DEBUG, peer_id, method, message, args)

    # Show an info message for a peer ID and method name
    func info_mn(peer_id: int, method: String, message: String, args: Array = []) -> void:
        _log_method_network(LogLevel.INFO, peer_id, method, message, args)

    # Show a warn message for a peer ID and method name
    func warn_mn(peer_id: int, method: String, message: String, args: Array = []) -> void:
        _log_method_network(LogLevel.WARN, peer_id, method, message, args)

    # Show an error message for a peer ID and method name
    func error_mn(peer_id: int, method: String, message: String, args: Array = []) -> void:
        _log_method_network(LogLevel.ERROR, peer_id, method, message, args)

    # Show a critical message for a peer ID and method name
    func critical_mn(peer_id: int, method: String, message: String, args: Array = []) -> void:
        _log_method_network(LogLevel.CRITICAL, peer_id, method, message, args)

    func _is_level_shown(level: int) -> bool:
        return level >= max_level

    func _show_log_line(level: int, line: String) -> void:
        if !display_in_console:
            return

        if level < LogLevel.WARN:
            print(line)
        else:
            printerr(line)

    func _format_args(message: String, args: Array = []) -> String:
        var output := message
        for a in args:
            output += " " + str(a)
        return output

    func _format_log(time: float, level: int, message: String, args: Array = []) -> String:
        var level_str := _LogUtils.level_to_string(level).to_upper()
        return "[{time}] [{level_str}] [{name}] {args}".format({
            "time": "%0.3f" % time,
            "level_str": level_str,
            "name": name,
            "args": _format_args(message, args)
        })

    func _format_log_method(time: float, level: int, method: String, message: String, args: Array = []) -> String:
        var level_str := _LogUtils.level_to_string(level).to_upper()
        return "[{time}] [{level_str}] [{name}::{method}] {args}".format({
            "time": "%0.3f" % time,
            "level_str": level_str,
            "name": name,
            "method": method,
            "args": _format_args(message, args)
        })

    func _format_log_method_network(time: float, level: int, peer_id: int, method: String, message: String, args: Array = []) -> String:
        var level_str := _LogUtils.level_to_string(level).to_upper()
        return "[{time}] [{level_str}] [{name}::{method}] *{peer_id}* {args}".format({
            "time": "%0.3f" % time,
            "level_str": level_str,
            "name": name,
            "method": method,
            "peer_id": peer_id,
            "args": _format_args(message, args)
        })

    func _get_elapsed_time() -> float:
        return OS.get_ticks_msec() / 1000.0

    func _log(level: int, message: String, args: Array = []) -> void:
        if !_is_level_shown(level):
            return

        var time := _get_elapsed_time()
        _show_log_line(level, _format_log(time, level, message, args))

        var log_message := LogMessage.new_message(
            time, level, name, _format_args(message, args)
        )
        _LogData.add_message(log_message)

    func _log_method_network(level: int, peer_id: int, method: String, message: String, args: Array = []) -> void:
        if !_is_level_shown(level):
            return

        var time := _get_elapsed_time()
        _show_log_line(level, _format_log_method_network(time, level, peer_id, method, message, args))

        var log_message := LogMessage.new_message(
            time, level, "%s::%s" % [name, method], _format_args(message, args), peer_id
        )
        _LogData.add_message(log_message)

    func _log_method(level: int, method: String, message: String, args: Array = []) -> void:
        if !_is_level_shown(level):
            return

        var time := _get_elapsed_time()
        _show_log_line(level, _format_log_method(time, level, method, message, args))

        var log_message := LogMessage.new_message(
            time, level, "%s::%s" % [name, method], _format_args(message, args)
        )
        _LogData.add_message(log_message)

const _static_data := {
    "loggers": {},
}

const SHOW_IN_CONSOLE := true
const DEFAULT_LOG_LEVEL := LogLevel.INFO

# Get logger from name.
#
# Example:
#   var logger := SxLog.get_logger("my_logger")
static func get_logger(name: String) -> Logger:
    var loggers := _static_data["loggers"] as Dictionary
    if loggers.has(name):
        return _static_data["loggers"][name]
    else:
        var logger := Logger.new(name, DEFAULT_LOG_LEVEL, SHOW_IN_CONSOLE)
        _static_data["loggers"][name] = logger
        return logger

static func get_messages() -> Array:
    return _LogData.get_messages()

static func pop_messages() -> Array:
    return _LogData.pop_messages()

# Configure log level for each loggers using a configuration string.
#
# Example:
#   SxLog.configure_log_levels("info,my_logger=debug")
static func configure_log_levels(conf: String) -> void:
    var all_split := conf.split(",")
    for log_conf in all_split:
        var split := log_conf.split("=") as Array
        var len_split := len(split)
        if len_split == 0:
            continue
        elif len_split == 1:
            set_max_log_level("root", Utils.level_from_name(split[0]))
        elif len_split == 2:
            set_max_log_level(split[0], Utils.level_from_name(split[0]))

# Set maximum log level for a specific logger.
#
# Example:
#   SxLog.set_max_log_level("my_logger", LogLevel.WARN)
static func set_max_log_level(name: String, level: int) -> void:
    var logger := get_logger(name)
    logger.set_max_log_level(level)

# Show a trace message on the root logger
static func trace(message: String, args: Array = []) -> void:
    var root_logger := get_logger("root")
    root_logger.trace(message, args)

# Show a debug message on the root logger
static func debug(message: String, args: Array = []) -> void:
    var root_logger := get_logger("root")
    root_logger.debug(message, args)

# Show an info message on the root logger
static func info(message: String, args: Array = []) -> void:
    var root_logger := get_logger("root")
    root_logger.info(message, args)

# Show a warn message on the root logger
static func warn(message: String, args: Array = []) -> void:
    var root_logger := get_logger("root")
    root_logger.warn(message, args)

# Show an error message on the root logger
static func error(message: String, args: Array = []) -> void:
    var root_logger := get_logger("root")
    root_logger.error(message, args)

# Show a critical message on the root logger
static func critical(message: String, args: Array = []) -> void:
    var root_logger := get_logger("root")
    root_logger.critical(message, args)
