# Global node utilities
extends Object
class_name SxNode

static func print_tree_to_string(node: Node) -> String:
    return _print_tree_to_string(node, node)

static func print_tree_pretty_to_string(node: Node) -> String:
    return _print_tree_pretty_to_string(node, "", true)

static func _print_tree_to_string(source: Node, target: Node) -> String:
    var output = ""
    if source != target:
        output = String(target.get_path_to(source)) + "\n"
    for child in source.get_children():
        var child_node := child as Node
        output += _print_tree_to_string(child_node, target)
    return output

static func _print_tree_pretty_to_string(node: Node, prefix: String, last: bool) -> String:
    var output = ""
    var new_prefix := " └ " if last else " ├ "
    output += prefix + new_prefix + node.name + "\n"

    var children := node.get_children()
    var child_count := len(children)
    for idx in range(child_count):
        var child_node := children[idx] as Node
        new_prefix = "   " if last else " │ "
        output += _print_tree_pretty_to_string(child_node, prefix + new_prefix, idx == child_count - 1)
    return output
