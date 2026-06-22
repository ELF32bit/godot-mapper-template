extends Node


func _on_generic_signal() -> void:
	var animation_player = get_node("ANIMATIONS")
	if not animation_player is AnimationPlayer: return
	animation_player.play("dance")
