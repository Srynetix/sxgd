extends Node
class_name SxGameData

var _data := Dictionary()
var _logger = SxLog.get_logger("SxGameData")

# Store value in game data.
#
# Example:
#   data.store_value("key", 123)
#   data.store_value("key2", "hello")
func store_value(name: String, value) -> void:
    _logger.debug("Storing value '%s' in key '%s'." % [value, name])
    _data[name] = value

# Load value from game data.
#
# Example:
#   var d1 = data.load_value("key")
#   var d2 = data.load_value("key", 123)  # returns 123 if key is missing
func load_value(name: String, orDefault = null):
    if _data.has(name):
        var value = _data[name]
        _logger.debug("Loading stored value '%s' from key '%s'." % [value, name])
        return value

    _logger.debug("Key '%s' missing, loading default '%s'." % [name, orDefault])
    return orDefault

# Increment key and returns the value.
# Starts from 0 if key does not exist.
#
# Example:
#   var value = data.increment("key")
func increment(name: String) -> int:
    var num = load_value(name, 0) + 1
    store_value(name, num)
    return num

# Decrement key and returns the value.
# Starts from 0 if key does not exist.
#
# Example:
#   var value = data.decrement("key")
func decrement(name: String) -> int:
    var num = load_value(name, 0) - 1
    store_value(name, num)
    return num

# Remove key from game data.
# Returns true if key was found, false if not.
#
# Example:
#   data.remove("key")
func remove(name: String) -> bool:
    var found = _data.erase(name)
    if found:
        _logger.debug("Key '%s' removed." % [name])
    else:
        _logger.debug("Trying to remove key '%s' but its missing." % [name])
    return found

# Test if game data has a key.
#
# Example:
#   var exists = data.has_value("key")
func has_value(name: String) -> bool:
    return _data.has(name)

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
