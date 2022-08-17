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
    var sz_split := window_size.split("x")
    var sz_vec := Vector2(int(sz_split[0]), int(sz_split[1]))
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

class DirOrFile:
    # Represents a path: a directory or a file
    extends Reference

    enum Type {
        DIRECTORY = 0,
        FILE = 1
    }

    var name := "" as String
    var path := "" as String
    var type := Type.DIRECTORY as int

    static func type_to_string(type: int) -> String:
        match type:
            Type.DIRECTORY:
                return "Directory"
            Type.FILE:
                return "File"
        return "???"

    func _init(name_: String, path_: String, type_: int) -> void:
        name = name_
        path = path_
        type = type_

    func is_file() -> bool:
        return type == Type.FILE

    func is_directory() -> bool:
        return type == Type.DIRECTORY

    func _to_string() -> String:
        return "%s (%s) (%s)" % [name, type_to_string(type), path]

# List all files in a directory.
static func list_files_in_directory(path: String, filters: Array) -> Array:
    var files := []
    var directory := Directory.new()
    directory.open(path)
    directory.list_dir_begin()
    var file_name := directory.get_next()

    while file_name != "":
        # Edge case: ignore . & ..
        if file_name in [".", ".."]:
            file_name = directory.get_next()
            continue

        var dir_or_file := DirOrFile.Type.DIRECTORY as int
        var file_path := path
        if !path.ends_with("/"):
            file_path += "/"
        file_path += file_name

        if directory.file_exists(file_path):
            dir_or_file = DirOrFile.Type.FILE

        var collect := true
        if dir_or_file == DirOrFile.Type.FILE:
            if len(filters) > 0:
                collect = false
                for filter in filters:
                    collect = collect || file_name.match(filter)

        if collect:
            files.append(DirOrFile.new(file_name, file_path, dir_or_file))
        file_name = directory.get_next()
    return files
