extends Object
class_name SxShader
## Shader extensions.
##
## Additional methods to work with shaders.

## Get a shader parameter from a canvas item.[br]
## Handles edge cases like missing material or non-shader material.
static func get_shader_parameter(item: CanvasItem, name: String) -> Variant:
    var logger := SxLog.get_logger("SxShader")
    var material := item.material

    if material == null:
        logger.error("CanvasItem %s has no material" % item)
    elif material is ShaderMaterial:
        var shader_material := material as ShaderMaterial
        return shader_material.get_shader_parameter(name)
    else:
        logger.error("CanvasItem %s material is not a ShaderMaterial (but %s)" % [item, material])

    return null

## Set a shader parameter from a canvas item.[br]
## Handles edge cases like missing material or non-shader material.
static func set_shader_parameter(item: CanvasItem, name: String, value: Variant) -> void:
    var logger := SxLog.get_logger("SxShader")
    var material := item.material

    if material == null:
        logger.error("CanvasItem %s has no material" % item)
    elif material is ShaderMaterial:
        var shader_material := material as ShaderMaterial
        shader_material.set_shader_parameter(name, value)
    else:
        logger.error("CanvasItem %s material is not a ShaderMaterial (but %s)" % [item, material])
