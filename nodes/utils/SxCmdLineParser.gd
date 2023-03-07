# Simple command-line parser
extends Node
class_name SxCmdLineParser

class Args:
    extends Object

    var positional := []
    var options := {}

    func _to_string() -> String:
        return "Args(\n  positional: %s,\n  options: %s\n)" % [positional, options]

func _ready() -> void:
    var args := _parse_args()
    _handle_args(args)

# Override this method to handle arguments.
func _handle_args(args: Args) -> void:
    pass

func _parse_args() -> Args:
    var args := Args.new()

    for arg in OS.get_cmdline_args():
        if arg.find("=") > -1:
            var key_value = arg.split("=")
            args.options[key_value[0].lstrip("--")] = key_value[1]
        elif arg.find("--") > -1:
            args.options[arg.lstrip("--")] = true
        else:
            args.positional.append(arg)

    return args
