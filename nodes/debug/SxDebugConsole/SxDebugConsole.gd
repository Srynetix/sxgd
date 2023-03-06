extends MarginContainer
class_name SxDebugConsole

var _logger := SxLog.get_logger("SxDebugConsole")

class _Args:
    var command_name: String
    var args: PoolStringArray

    func _init(command: String):
        var parsed = command.split(" ")

        self.command_name = parsed[0]
        self.args = PoolStringArray()

        var i = 1
        while i < len(parsed):
            self.args.append(parsed[i])
            i += 1

const MOTD_HEADER := """
  _____     _____       _                  _____                      _
 / ____|   |  __ \\     | |                / ____|                    | |
| (_____  _| |  | | ___| |__  _   _  __ _| |     ___  _ __  ___  ___ | | ___
 \\___ \\ \\/ / |  | |/ _ \\ '_ \\| | | |/ _` | |    / _ \\| '_ \\/ __|/ _ \\| |/ _ \\
 ____) >  <| |__| |  __/ |_) | |_| | (_| | |___| (_) | | | \\__ \\ (_) | |  __/
|_____/_/\\_\\_____/ \\___|_.__/ \\__,_|\\__, |\\_____\\___/|_| |_|___/\\___/|_|\\___|
                                     __/ |
                                    |___/"""

onready var _scrollcontainer := $MarginContainer/VBoxContainer/ScrollContainer as ScrollContainer
onready var _scrollbuffer := $MarginContainer/VBoxContainer/ScrollContainer/Buffer as Label
onready var _inputfield := $MarginContainer/VBoxContainer/InputField as SxLineEdit

var _history := PoolStringArray()
var _history_cursor := 0

func _ready() -> void:
    _inputfield.connect("text_entered", self, "_process_input_field")
    _inputfield.connect("history_up", self, "_history_up")
    _inputfield.connect("history_down", self, "_history_down")

    _clear_scrollbuffer()
    _add_scrollbuffer_contents(_print_motd())

func _process_input_field(contents: String) -> void:
    if !contents:
        return

    _add_scrollbuffer_contents("\n>>> %s" % contents)
    var output = _process_command(contents)
    if output:
        _add_scrollbuffer_contents(output)
    _inputfield.text = ""

func _get_font_height() -> int:
    return int(_scrollbuffer.get_font("font").get_height()) * 2

func _count_nl(contents: String) -> int:
    return contents.count("\n")

func _add_scrollbuffer_contents(contents: String) -> void:
    var newlines = _count_nl(contents) + 1
    _scrollbuffer.text += contents + "\n"
    yield(get_tree(), "idle_frame")
    _scrollcontainer.scroll_vertical += _get_font_height() * newlines

func _clear_scrollbuffer() -> void:
    _scrollbuffer.text = ""
    yield(get_tree(), "idle_frame")
    _scrollcontainer.scroll_vertical = 0

func _print_motd() -> String:
    var current_dt = Time.get_datetime_dict_from_system()
    var current_dt_str = "%02d/%02d/%04d %02d:%02d:%02d" % [
        current_dt["month"],
        current_dt["day"],
        current_dt["year"],
        current_dt["hour"],
        current_dt["minute"],
        current_dt["second"],
    ]

    return """%s
Welcome on the SxDebugConsole!
Date: %s.
Type 'help' to get a list of commands.""" % [
        MOTD_HEADER,
        current_dt_str
    ]

func _print_help() -> String:
    return """Here are some commands:
- call: Call a method on a node (args: nodepath methodpath args?).
- clear: Clear the screen (you will lost the actual scrollbuffer contents).
- cvar_get: Get a CVar (args: cvar_name).
- cvar_list: List known CVars.
- cvar_set: Set a CVar (args: cvar_name cvar_value).
- echo: Echo something on screen.
- get: Get a parameter value from a node (args: nodepath parameter).
- history: Get command history.
- help: Show this message.
- motd: Show the initial message.
- scene_reload: Reload the current scene.
- set: Set a parameter value from a node (args: nodepath parameter value).
- show: Get node information (args: nodepath)."""

func _process_command(command: String) -> String:
    _add_history(command)

    var args = _parse_command(command)
    match args.command_name:
        "call":
            return _cmd_call(args.args)
        "clear":
            _clear_scrollbuffer()
            return ""
        "cvar_get":
            return _cmd_cvar_get(args.args)
        "cvar_list":
            return _cmd_cvar_list()
        "cvar_set":
            return _cmd_cvar_set(args.args)
        "echo":
            return _cmd_echo(args.args)
        "get":
            return _cmd_get(args.args)
        "help":
            return _print_help()
        "history":
            return _cmd_history()
        "motd":
            return _print_motd()
        "scene_reload":
            return _cmd_scene_reload()
        "set":
            return _cmd_set(args.args)
        "show":
            return _cmd_show(args.args)
    return "Unknown command: %s" % command

func _parse_command(command: String) -> _Args:
    return _Args.new(command)

func _cmd_echo(args: PoolStringArray) -> String:
    return args.join(" ")

func _cmd_history() -> String:
    return _history.join("\n")

func _cmd_scene_reload() -> String:
    get_tree().reload_current_scene()
    return ""

func _cmd_get(args: PoolStringArray) -> String:
    if len(args) != 2:
        return _cmd_error("'get' should take two arguments: the 'nodepath' and the 'parameter'.")

    var nodepath := args[0] as String
    var parameter := args[1] as String

    var node = get_node_or_null(nodepath)
    if !node:
        return _error_unknown_node(nodepath)

    return str(node.get(parameter))

func _cmd_error(msg: String) -> String:
    return "Error: %s" % msg

func _cmd_show(args: PoolStringArray) -> String:
    if len(args) != 1:
        return _cmd_error("'show' should take one argument: the 'nodepath'.")

    var nodepath := args[0] as String
    var node = get_node_or_null(nodepath)
    if !node:
        return _error_unknown_node(nodepath)
    return str(node)

func _cmd_set(args: PoolStringArray) -> String:
    if len(args) != 3:
        return _cmd_error("'set' should take three arguments: the 'nodepath', the 'parameter', and the 'value'.")

    var nodepath := args[0] as String
    var parameter := args[1] as String
    var value := args[2] as String
    var node = get_node_or_null(nodepath)
    if !node:
        return _error_unknown_node(nodepath)

    # Determine type
    var current = node.get(parameter)
    var converted_value = _convert_value(current, value)

    node.set(parameter, converted_value)
    return str(node.get(parameter))

func _convert_value(source, value):
    if source is bool:
        return _to_bool(value)
    elif source is float:
        return float(value)
    elif source is int:
        return int(value)
    elif value == "null":
        return null
    return str(value)

func _to_bool(value: String) -> bool:
    return value.to_lower() == "true"

func _error_unknown_node(nodepath: String) -> String:
    return _cmd_error("Unknown node: %s" % nodepath)

func _add_history(command: String) -> void:
    if len(_history) > 0 && _history[len(_history) - 1] == command:
        # Ignore doubled commands
        _history_cursor = len(_history)
        return

    _history.append(command)
    _history_cursor = len(_history)

func _history_up() -> void:
    if _history:
        _history_cursor = int(clamp(_history_cursor - 1, 0, len(_history) - 1))
        _inputfield.text = _history[_history_cursor]
        yield(get_tree(), "idle_frame")
        _inputfield.caret_position = len(_inputfield.text)

func _history_down() -> void:
    if _history:
        _history_cursor = int(clamp(_history_cursor + 1, 0, len(_history) - 1))
        _inputfield.text = _history[_history_cursor]

func _cmd_cvar_set(args: PoolStringArray) -> String:
    if len(args) != 2:
        return _cmd_error("'cvar_set' should take two arguments: the 'cvar_name', and the 'cvar_value'.")

    var cvar_name = args[0] as String
    var cvar_value = args[1] as String

    var current = GameCVars.get_cvar(cvar_name)
    var converted_value = _convert_value(current, cvar_value)
    _logger.info("Will set CVar %s to value %s (was: %s)" % [cvar_name, converted_value, current])
    GameCVars.set_cvar(cvar_name, converted_value)
    return str(GameCVars.get_cvar(cvar_name))

func _cmd_cvar_get(args: PoolStringArray) -> String:
    if len(args) != 1:
        return _cmd_error("'cvar_get' should take one argument: the 'cvar_name'.")

    return str(GameCVars.get_cvar(args[0]))

func _cmd_cvar_list() -> String:
    return GameCVars.print_cvars()

func _cmd_call(args: PoolStringArray) -> String:
    if len(args) < 2:
        return _cmd_error("'call' should take at least two arguments: the 'nodepath', the 'methodpath', then optional 'args'.")

    var nodepath := args[0] as String
    var node = get_node_or_null(nodepath)
    if !node:
        return _error_unknown_node(nodepath)

    var remaining_args = []
    var i = 2
    while i < len(args):
        remaining_args.append(args[i])
        i += 1

    return str(node.callv(args[1], remaining_args))
