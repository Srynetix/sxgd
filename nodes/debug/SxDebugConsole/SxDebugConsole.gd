extends MarginContainer
class_name SxDebugConsole
## In-Game debug console.

const AutocompletionItem := SxAutocompleteLineEdit.AutocompletionItem

const _FONT := preload("res://addons/sxgd/assets/fonts/OfficeCodePro-Regular.otf")
var _logger := SxLog.get_logger("SxDebugConsole")

class _Args:
    var command_name: String
    var args: PackedStringArray

    func _init(command: String):
        var parsed = command.split(" ")

        self.command_name = parsed[0]
        self.args = PackedStringArray()

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

var _scrollcontainer: ScrollContainer
var _scrollbuffer: Label
var _inputfield: SxDebugConsoleLineEdit

var _history := PackedStringArray()
var _history_cursor := 0

func _init() -> void:
    name = "SxDebugConsole"

## Focus the console input.
func focus_input() -> void:
    _inputfield.grab_focus()

func _build_ui() -> void:
    anchor_right = 1.0
    anchor_bottom = 1.0
    SxUi.set_margin_container_margins(self, 10.0)

    var panel := Panel.new()
    panel.self_modulate = SxColor.with_alpha_f(Color.BLACK, 0.75)
    panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
    add_child(panel)

    var container := MarginContainer.new()
    SxUi.set_margin_container_margins(container, 20.0)
    add_child(container)

    var vbox := VBoxContainer.new()
    vbox.add_theme_constant_override("separation", 10)
    container.add_child(vbox)

    _scrollcontainer = ScrollContainer.new()
    _scrollcontainer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    _scrollcontainer.size_flags_vertical = Control.SIZE_EXPAND_FILL
    vbox.add_child(_scrollcontainer)

    var margin_container = MarginContainer.new()
    margin_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    margin_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
    margin_container.add_theme_constant_override("margin_left", 2.0)
    margin_container.add_theme_constant_override("margin_bottom", 2.0)
    _scrollcontainer.add_child(margin_container)

    _scrollbuffer = Label.new()
    _scrollbuffer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    _scrollbuffer.size_flags_vertical = Control.SIZE_EXPAND_FILL
    _scrollbuffer.add_theme_font_override("font", _FONT)
    _scrollbuffer.add_theme_font_size_override("font_size", 11)
    _scrollbuffer.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
    margin_container.add_child(_scrollbuffer)

    _inputfield = SxDebugConsoleLineEdit.new()
    _inputfield.add_theme_font_override("font", _FONT)
    _inputfield.add_theme_font_size_override("font_size", 11)
    _inputfield.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    _inputfield.autocomplete_func = _autocomplete_func
    _inputfield.clear_screen.connect(func(): _clear_scrollbuffer())
    vbox.add_child(_inputfield)

func _autocomplete_func(words: Array, word_position: int) -> Array[AutocompletionItem]:
    if word_position == 0:
        return [
            AutocompletionItem.new("call", "Call a method on a node"),
            AutocompletionItem.new("clear", "Clear the screen"),
            AutocompletionItem.new("cvar_get", "Get a console variable"),
            AutocompletionItem.new("cvar_list", "List console variables"),
            AutocompletionItem.new("cvar_set", "Set a console variable"),
            AutocompletionItem.new("echo", "Echo something"),
            AutocompletionItem.new("get", "Get a node value"),
            AutocompletionItem.new("history", "Get command history"),
            AutocompletionItem.new("help", "Show help"),
            AutocompletionItem.new("motd", "Show the initial message"),
            AutocompletionItem.new("scene_reload", "Reload the current scene"),
            AutocompletionItem.new("set", "Set a node value"),
            AutocompletionItem.new("show", "Get node information"),
            AutocompletionItem.new("tree", "Show node tree"),
        ]

    elif word_position == 1:
        if words[0] == "cvar_set" || words[0] == "cvar_get":
            var items: Array[AutocompletionItem] = []
            for unit in SxCVars.list_units():
                items.push_back(AutocompletionItem.new(unit.name))
            return items

    return []

func _ready() -> void:
    _build_ui()

    _inputfield.text_submitted.connect(_process_input_field)
    _inputfield.history_up.connect(_history_up)
    _inputfield.history_down.connect(_history_down)

    _clear_scrollbuffer()
    _add_scrollbuffer_contents(_print_motd())

func _process_input_field(contents: String) -> void:
    if contents == "":
        return

    _add_scrollbuffer_contents("\n>>> %s" % contents)
    var output = _process_command(contents)
    if output:
        _add_scrollbuffer_contents(output)
    _inputfield.text = ""

func _get_font_height() -> int:
    return int(_scrollbuffer.get_theme_font("font").get_height()) * 2

func _count_nl(contents: String) -> int:
    return contents.count("\n")

func _add_scrollbuffer_contents(contents: String) -> void:
    var newlines = _count_nl(contents) + 1
    _scrollbuffer.text += contents + "\n"
    await get_tree().process_frame
    _scrollcontainer.scroll_vertical += _get_font_height() * newlines

func _clear_scrollbuffer() -> void:
    _scrollbuffer.text = ""
    await get_tree().process_frame
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
- show: Get node information (args: nodepath).
- tree: Show node tree."""

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
        "tree":
            return _cmd_tree()
    return "Unknown command: %s" % command

func _parse_command(command: String) -> _Args:
    return _Args.new(command)

func _cmd_echo(args: PackedStringArray) -> String:
    return " ".join(args)

func _cmd_history() -> String:
    return "\n".join(_history)

func _cmd_scene_reload() -> String:
    get_tree().reload_current_scene()
    return ""

func _cmd_get(args: PackedStringArray) -> String:
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

func _cmd_show(args: PackedStringArray) -> String:
    if len(args) != 1:
        return _cmd_error("'show' should take one argument: the 'nodepath'.")

    var nodepath := args[0] as String
    var node := get_node_or_null(nodepath)
    if !node:
        return _error_unknown_node(nodepath)

    var node_name = str(node)
    var output = "Node: " + node_name + "\n" + "Props: " + "\n"
    var node_props = node.get_property_list()

    for prop in node_props:
        var usage = prop["usage"]
        if usage & PROPERTY_USAGE_GROUP != 0:
            continue
        if usage & PROPERTY_USAGE_CATEGORY != 0:
            continue
        if usage & PROPERTY_USAGE_INTERNAL != 0:
            continue
        if usage & PROPERTY_USAGE_SUBGROUP != 0:
            continue

        output += " - " + prop["name"] + " = " + str(node.get(prop["name"])) + " (" + str(prop["usage"]) + ")\n"

    return output

func _cmd_set(args: PackedStringArray) -> String:
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
    elif source is Vector2:
        return _to_vec2(value)
    elif source is Vector3:
        return _to_vec3(value)
    elif source is Color:
        return _to_color(value)
    elif value == "null":
        return null
    return str(value)

func _to_bool(value: String) -> bool:
    return value.to_lower() == "true"

func _to_vec2(value: String) -> Vector2:
    var parsed = value.split(",")
    var first = float(parsed[0])
    var second = float(parsed[1])
    return Vector2(first, second)

func _to_vec3(value: String) -> Vector3:
    var parsed = value.split(",")
    var first = float(parsed[0])
    var second = float(parsed[1])
    var third = float(parsed[2])
    return Vector3(first, second, third)

func _to_color(value: String) -> Color:
    var parsed = value.split(",")
    var first = float(parsed[0])
    var second = float(parsed[1])
    var third = float(parsed[2])
    var alpha = float(parsed[3])
    return Color(first, second, third, alpha)

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
        await get_tree().process_frame
        _inputfield.caret_column = len(_inputfield.text)

func _history_down() -> void:
    if _history:
        _history_cursor = int(clamp(_history_cursor + 1, 0, len(_history) - 1))
        _inputfield.text = _history[_history_cursor]

func _cmd_cvar_set(args: PackedStringArray) -> String:
    if len(args) != 2:
        return _cmd_error("'cvar_set' should take two arguments: the 'cvar_name', and the 'cvar_value'.")

    var cvar_name = args[0] as String
    var cvar_value = args[1] as String

    var current = SxCVars.get_unit(cvar_name)
    var converted_value = _convert_value(current.value, cvar_value)
    _logger.info("Will set CVar %s to value %s (was: %s)" % [cvar_name, converted_value, current.value])
    current.value = converted_value
    return str(current.value)

func _cmd_cvar_get(args: PackedStringArray) -> String:
    if len(args) != 1:
        return _cmd_error("'cvar_get' should take one argument: the 'cvar_name'.")

    return str(SxCVars.get_cvar(args[0]))

func _cmd_cvar_list() -> String:
    var output = ""
    for unit in SxCVars.list_units():
        output += "%s (%s)\n" % [unit.name, str(unit.value)]
    return output

func _cmd_call(args: PackedStringArray) -> String:
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

func _cmd_tree() -> String:
    return SxNode.print_tree_pretty_to_string(get_tree().root)
