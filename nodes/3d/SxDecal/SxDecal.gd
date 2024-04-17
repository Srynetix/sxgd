@tool
extends MeshInstance3D
class_name SxDecal
## Simple decal using a cube mesh.

const shader := preload("res://addons/sxgd/nodes/3d/SxDecal/SxDecal.gdshader")

## Texture to show.
@export var texture: Texture2D: set = _set_texture
@export var width: float = 1.0: set = _set_width
@export var height: float = 1.0: set = _set_height
@export var repeat: bool = false: set = _set_repeat

var _box_mesh: BoxMesh

## Align decal with normal vector.
func align_with_normal(normal: Vector3) -> void:
    transform = SxMath.align_with_normal(transform, normal)

func _ready() -> void:
    _box_mesh = BoxMesh.new()
    _box_mesh.size.y = 0.1
    mesh = _box_mesh

    _set_width(width)
    _set_height(height)

    var shader_material := ShaderMaterial.new()
    shader_material.shader = shader
    material_override = shader_material

    _set_texture(texture)
    _set_repeat(repeat)

    shader_material.set_shader_parameter("albedo", Color.TRANSPARENT)
    shader_material.set_shader_parameter("cube_half_size", 0.5)

func _set_texture(value: Texture2D) -> void:
    texture = value
    if material_override == null:
        await self.ready

    material_override.set_shader_parameter("texture_albedo", texture)

func _set_width(value: float) -> void:
    width = value
    if _box_mesh == null:
        await self.ready

    _box_mesh.size.x = width

func _set_height(value: float) -> void:
    height = value
    if _box_mesh == null:
        await self.ready

    _box_mesh.size.z = height

func _set_repeat(value: float) -> void:
    repeat = value
    if material_override == null:
        await self.ready

    material_override.set_shader_parameter("repeat", repeat)
