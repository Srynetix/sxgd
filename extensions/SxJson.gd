extends Reference
class_name SxJson

# Read JSON file at path `path`.
static func read_json_file(path: String) -> Dictionary:
    var _logger = SxLog.get_logger("SxJson")

    var f = File.new()
    var error = f.open(path, File.READ)
    if error == OK:
        _logger.debug("Reading JSON data from path '%s'." % path)
        return JSON.parse(f.get_as_text()).result
    else:
        _logger.error("Could not read JSON file '%s': %s" % [path, error])
        return Dictionary()

# Write JSON to path `path`.
static func write_json_file(json: Dictionary, path: String):
    var _logger = SxLog.get_logger("SxJson")

    var f = File.new()
    var error = f.open(path, File.WRITE)
    if error == OK:
        _logger.debug("Writing JSON data to path '%s'." % path)
        f.store_line(JSON.print(json, "  "))
        f.close()
    else:
        _logger.error("Could not write JSON data to file '%s': %s" % [path, error])
