# A general-purpose in-memory key-value store, to be used through inheritance and autoload.
extends Node
class_name SxGameData

var _data := Dictionary()
var _static_data := Dictionary()
var _logger = SxLog.get_logger("SxGameData")

# Store static value in game data.
# Static data is not persisted to disk.
#
# Example:
#   data.store_static_value("levels", json_levels)
#   data.store_static_value("my_data", my_data, "my_category")
func store_static_value(name: String, value, category: String = "default") -> void:
    _logger.debug("Storing static value '%s' in key '%s' [category: %s]." % [value, name, category])
    _set_value(_static_data, name, category, value)

# Load static value from game data.
# Static data is not persisted to disk.
#
# Example:
#   var levels = data.load_static_value("levels", Dictionary())
#   var levels = data.load_static_value("my_data", Dictionary(), "my_category")
func load_static_value(name: String, orDefault = null, category: String = "default"):
    if _has_value(_static_data, name, category):
        var value = _get_value(_static_data, name, category, null)
        _logger.debug("Loading stored static value '%s' from key '%s' [category: %s]." % [value, name, category])
        return value

    _logger.debug("Static key '%s' missing [category: %s], loading default '%s'." % [name, category, orDefault])
    return orDefault

# Store value in game data.
#
# Example:
#   data.store_value("key", 123)
#   data.store_value("key2", "hello")
#   data.store_value("key3", "hello", "my_category")
func store_value(name: String, value, category: String = "default") -> void:
    _logger.debug("Storing value '%s' in key '%s' [category: %s]." % [value, name, category])
    _set_value(_data, name, category, value)

# Load value from game data.
#
# Example:
#   var d1 = data.load_value("key")
#   var d2 = data.load_value("key", 123)  # returns 123 if key is missing
#   var d2 = data.load_value("key2", 123, "my_category")
func load_value(name: String, orDefault = null, category: String = "default"):
    if has_value(name, category):
        var value = _get_value(_data, name, category, null)
        _logger.debug("Loading stored value '%s' from key '%s' [category: %s]." % [value, name, category])
        return value

    _logger.debug("Key '%s' missing [category: %s], loading default '%s'." % [name, category, orDefault])
    return orDefault

# Increment key and returns the value.
# Starts from 0 if key does not exist.
#
# Example:
#   var value = data.increment("key")
#   var value = data.increment("key", "my_category")
func increment(name: String, category: String = "default") -> int:
    var num = load_value(name, 0, category) + 1
    store_value(name, num, category)
    return num

# Decrement key and returns the value.
# Starts from 0 if key does not exist.
#
# Example:
#   var value = data.decrement("key")
#   var value = data.decrement("key", "my_category")
func decrement(name: String, category: String = "default") -> int:
    var num = load_value(name, 0, category) - 1
    store_value(name, num, category)
    return num

# Remove key from game data.
# Returns true if key was found, false if not.
#
# Example:
#   data.remove("key")
#   data.remove("key", "my_category")
func remove(name: String, category: String = "default") -> bool:
    var found = _remove_value(_data, name, category)
    if found:
        _logger.debug("Key '%s' removed. [category: %s]" % [name, category])
    else:
        _logger.debug("Trying to remove key '%s' but its missing [category: %s]." % [name, category])
    return found

# Test if game data has a key.
#
# Example:
#   var exists = data.has_value("key")
#   var exists = data.has_value("key", "my_category")
func has_value(name: String, category: String = "default") -> bool:
    return _has_value(_data, name, category)

# Persist game data to disk at a specific path.
#
# Example:
#   data.persist_to_disk("user://my_path.dat")
func persist_to_disk(path: String = "user://save.dat") -> void:
    var f = File.new()
    var error = f.open(path, File.WRITE)
    if error == OK:
        f.store_line(JSON.print(_data))
        f.close()
        _logger.debug("Game data persisted to path '%s'." % path)
    else:
        _logger.error("Could not persist data to path '%s' (error: %s)" % [path, error])

# Load game data from disk at a specific path.
#
# Example:
#   data.load_from_disk("user://my_path.dat")
func load_from_disk(path: String = "user://save.dat") -> void:
    var f = File.new()
    var error = f.open(path, File.READ)
    if error == OK:
        _data = JSON.parse(f.get_as_text()).result
        _logger.debug("Game data loaded from path '%s'" % path)
    elif error == ERR_FILE_NOT_FOUND:
        _logger.debug("Missing saved game data, will create at path '%s'" % path)
        persist_to_disk(path)
    else:
        _logger.error("Could not load game data from path '%s'" % path)

# Clear all non-static data.
func clear() -> void:
    _data.clear()

# Clear all non-static data from category.
func clear_category(category: String) -> void:
    _clear_category(_data, category)

# Dump each variable from a specific category.
func dump_category(category: String) -> String:
    var cat = _get_or_create_category(_data, category)
    return JSON.print(cat, "", true)

# Dump all variables.
func dump_all() -> String:
    return JSON.print(_data, "", true)

func _clear_category(d: Dictionary, category: String) -> void:
    if d.has(category):
        d[category].clear()

func _set_value(d: Dictionary, key: String, category: String, value) -> void:
    var cat = _get_or_create_category(d, category)
    cat[key] = value

func _get_value(d: Dictionary, key: String, category: String, orDefault = null):
    var cat = _get_or_create_category(d, category)
    if !cat.has(key):
        return orDefault
    return cat[key]

func _get_or_create_category(d: Dictionary, category: String) -> Dictionary:
    if !d.has(category):
        d[category] = Dictionary()
    return d[category]

func _has_value(d: Dictionary, key: String, category: String) -> bool:
    var cat = _get_or_create_category(d, category)
    return cat.has(key)

func _remove_value(d: Dictionary, key: String, category: String) -> bool:
    var cat = _get_or_create_category(d, category)
    return cat.erase(key)
