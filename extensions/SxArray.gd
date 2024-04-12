extends Object
class_name SxArray
## Array extensions.
##
## Additional methods to work with arrays.

## Trim each strings from a string array.
static func trim_strings(array: Array) -> Array:
    for idx in range(len(array)):
        var value := array[idx] as String
        array[idx] = value.strip_edges()
    return array
