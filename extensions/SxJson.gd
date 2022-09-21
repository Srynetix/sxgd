extends Reference
class_name SxJson

static func _get_logger() -> SxLog.Logger:
    return SxLog.get_logger("SxJson")

# Read JSON file at path `path`.
static func read_json_file(path: String):
    var logger := _get_logger()

    var f := File.new()
    var error := f.open(path, File.READ)
    if error == OK:
        logger.debug("Reading JSON data from path '%s'." % path)
        return read_json_from_open_file(f)
    else:
        logger.error("Could not read JSON file '%s': %s" % [path, error])
        return Dictionary()

static func read_json_from_open_file(file: File):
    var logger := _get_logger()
    var result := JSON.parse(file.get_as_text())
    if result.error == OK:
        return result.result
    logger.error("Error while reading JSON data, error %s" % result.error)
    return Dictionary()

# Write JSON to path `path`.
static func write_json_file(json, path: String) -> void:
    var logger := _get_logger()

    var f := File.new()
    var error := f.open(path, File.WRITE)
    if error == OK:
        logger.debug("Writing JSON data to path '%s'." % path)
        f.store_line(JSON.print(json, "  "))
        f.close()
    else:
        logger.error("Could not write JSON data to file '%s': %s" % [path, error])
