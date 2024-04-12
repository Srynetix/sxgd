extends AudioStreamPlayer3D
class_name SxAudioStreamPlayer3D
## An augmented [AudioStreamPlayer3D].

## Spawn a duplicate player to the node parent at a specific position.
## Then play the sound and remove the node.
func spawn_duplicate_at_position(position: Vector3) -> void:
    # Connect node to parents' parent
    var parent = get_parent()
    var parent_parent = parent.get_parent()

    var dup := duplicate() as SxAudioStreamPlayer3D
    parent_parent.call_deferred("add_child", dup)
    dup.set_deferred("global_position", position)
    dup.call_deferred("play_and_remove")

## Play the sound and remove the node.
func play_and_remove() -> void:
    if is_inside_tree():
        play()
        await finished
        queue_free()
