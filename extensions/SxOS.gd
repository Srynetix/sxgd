# Helper methods around core functions
extends Reference
class_name SxOS

# Set the window size from a WIDTHxHEIGHT string.
#
# Example:
# ```gdscript
# SxOS.set_window_size_str("1280x720")
# ```
static func set_window_size_str(window_size: String) -> void:
    var sz_split = window_size.split("x")
    var sz_vec = Vector2(sz_split[0], sz_split[1])
    OS.set_window_size(sz_vec)

# Detect if the current system is a mobile environment.
#
# Example:
# ```gdscript
# if SxOS.is_mobile():
#   print("Mobile !")
# ```
static func is_mobile() -> bool:
    return OS.get_name() in ["Android", "iOS"]
