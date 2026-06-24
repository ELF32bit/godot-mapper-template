extends Area3D

signal generic

@export var rotation_speed: float = 4.0


func _physics_process(delta: float) -> void:
	rotate_y(rotation_speed * delta)


func _on_body_entered(body: Node3D) -> void:
	if not body is RigidBody3D: return
	GameState.coins_collected += 1
	generic.emit()
	queue_free()
