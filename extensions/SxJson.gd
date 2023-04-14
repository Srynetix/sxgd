extends Object
class_name SxJson

static func _get_logger() -> SxLog.Logger:
    return SxLog.get_logger("SxJson")

# Read JSON file at path `path`.
static func read_json_file(path: String):
    var logger := _get_logger()

    var f := FileAccess.open(path, FileAccess.READ)
    logger.debug("Reading JSON data from path '%s'." % path)
    return read_json_from_open_file(f)

static func read_json_from_open_file(file: FileAccess):
    var logger := _get_logger()
    var json := JSON.new()
    var error := json.parse(file.get_as_text())
    if error == OK:
        return json.data
    logger.error("Error while reading JSON data, error %s" % error)
    return Dictionary()

# Write JSON to path `path`.
static func write_json_file(json, path: String) -> void:
    var logger := _get_logger()

    var f := FileAccess.open(path, FileAccess.WRITE)
    logger.debug("Writing JSON data to path '%s'." % path)
    f.store_line(JSON.stringify(json, "  "))
