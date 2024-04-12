@tool
extends MeshInstance3D
class_name SxDecal
## Simple decal using a cube mesh.

const shader := preload("res://addons/sxgd/nodes/3d/SxDecal/SxDecal.gdshader")

## Texture to show.
@export var texture: Texture2D: set = _set_texture

## Align decal with normal vector.
func align_with_normal(normal: Vector3) -> void:
    transform.basis.y = normal
    transform.basis.x = -transform.basis.z.cross(normal)
    transform.basis = transform.basis.orthonormalized()

func _ready() -> void:
    var box_mesh := BoxMesh.new()
    box_mesh.size.y = 0.1
    mesh = box_mesh

    var shader_material := ShaderMaterial.new()
    shader_material.shader = shader
    material_override = shader_material

    shader_material.set_shader_parameter("albedo", Color.TRANSPARENT)
    shader_material.set_shader_parameter("cube_half_size", 0.5)
    shader_material.set_shader_parameter("texture_albedo", texture)

    rotate_object_local(Vector3.MODEL_LEFT, deg_to_rad(90))
    rotate_object_local(Vector3.MODEL_FRONT, deg_to_rad(90))

func _set_texture(value: Texture2D) -> void:
    texture = value
    if material_override == null:
        await self.ready

    material_override.set_shader_parameter("texture_albedo", texture)
