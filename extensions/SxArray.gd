# Array extensions
extends Reference
class_name SxArray

# Trim each strings from a string array.
static func trim_strings(array: Array) -> Array:
    for idx in range(len(array)):
        var value := array[idx] as String
        array[idx] = value.strip_edges()
    return array
