extends GPUParticles3D
class_name SxGPUParticles3D
## Augmented [GPUParticles3D].

## Spawn a duplicated particle system at a specific position.
## Then emit, wait for particle lifetime, then remove the particle system.
func spawn_duplicate_at_position(position: Vector3, do_not_reparent: bool = false) -> void:
    # Connect node to parents' parent
    var parent = get_parent()

    if !do_not_reparent:
        parent = parent.get_parent()

    var dup := duplicate() as SxGPUParticles3D
    parent.call_deferred("add_child", dup)
    dup.set_deferred("global_position", position)
    dup.call_deferred("emit_and_remove")

## Emit, wait for particle lifetime, then remove the particle system.
func emit_and_remove() -> void:
    if is_inside_tree():
        emitting = true
        await get_tree().create_timer(lifetime).timeout
        queue_free()
