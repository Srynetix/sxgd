extends Object
class_name SxContainer

static func are_values_equal(v1, v2) -> bool:
    var v1_type := typeof(v1)
    var v2_type := typeof(v2)
    if v1_type != v2_type:
        return false

    match v1_type:
        TYPE_DICTIONARY:
            if !are_dictionaries_equal(v1 as Dictionary, v2 as Dictionary):
                return false
        TYPE_ARRAY:
            if !are_arrays_equal(v1 as Array, v2 as Array):
                return false
        _:
            if v1 != v2:
                return false
    return true

static func are_dictionaries_equal(d1: Dictionary, d2: Dictionary) -> bool:
    var d1_keys := d1.keys()
    var d2_keys := d2.keys()
    d1_keys.sort()
    d2_keys.sort()

    if !are_arrays_equal(d1_keys, d2_keys):
        return false

    for k in d1:
        if !are_values_equal(d1[k], d2[k]):
            return false
    return true

static func are_arrays_equal(a1: Array, a2: Array) -> bool:
    if len(a1) != len(a2):
        return false

    for x in range(0, len(a1)):
        if !are_values_equal(a1[x], a2[x]):
            return false

    return true
