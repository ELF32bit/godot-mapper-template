extends RigidBody3D

@export var velocity_fast: float = 0.35
@export var velocity_normal: float = 0.25
@export var velocity_jumping: float = 4.0
@export var hit_impulse_threshold: float = 50.0
@export var orbit_limit_min := deg_to_rad(-89.0)
@export var orbit_limit_max := deg_to_rad(89.0)

@onready var _rid: RID = get_rid()
@onready var input: Node = $"Input"
@onready var camera: Camera3D = $"Camera3D"
@onready var spring_arm: SpringArm3D = $"SpringArm3D"
@onready var collision_shape: CollisionShape3D = $"CollisionShape3D"
@onready var _original_gravity_scale := float(gravity_scale)
@onready var jump_ray_cast: RayCast3D = $"RayCast3D"

var target_velocity: Vector3 = Vector3.ZERO


func _ready() -> void:
	# spring arm must pass through the body to work
	spring_arm.add_excluded_object(_rid)


func _physics_process(delta: float) -> void:
	# reading mouse motion and wheel inputs
	var free_look: Vector2 = input.get_free_look()
	var scroll_number: int = input.get_scroll_number()

	# spring arm ignores parents transform (set as `Top Level`)
	spring_arm.global_position = global_position
	# updating spring arm (third person camera distance)
	spring_arm.spring_length -= scroll_number * 0.15
	spring_arm.spring_length = clampf(spring_arm.spring_length, 0.0, 10.0)

	# orbiting spring arm around the ball
	_apply_free_look(spring_arm, free_look, delta)

	# obtaining camera vectors and projecting them on a plane
	var camera_forward := -camera.global_basis.z.normalized()
	var camera_right := camera.global_basis.x.normalized()

	var plane := Plane(Vector3.UP)
	var forward := plane.project(camera_forward).normalized()
	var right := plane.project(camera_right).normalized()

	# creating movement direction vector
	var direction := Vector3.ZERO
	direction += right * input.move_vector.x
	direction += forward * input.move_vector.y
	direction = direction.normalized()

	# adding global up or down vector to the direction
	if input.is_up_pressed: direction += Vector3.UP
	elif input.is_down_pressed: direction += Vector3.DOWN

	# setting target velocity vector
	target_velocity = direction * velocity_normal
	if input.is_fast_pressed:
		target_velocity = direction * velocity_fast

	# RayCast3D ignores parents transform (set as `Top Level`)
	jump_ray_cast.position = global_position
	if jump_ray_cast.is_colliding():
		if input.is_jump_pressed:
			target_velocity += Vector3.UP * velocity_jumping

	# disabling collisions if noclip is pressed for debugging
	collision_shape.disabled = input.is_noclip_pressed

	# disabling gravity if certain buttons are pressed
	gravity_scale = _original_gravity_scale
	gravity_scale *= int(not input.is_up_pressed)
	gravity_scale *= int(not input.is_down_pressed)
	gravity_scale *= int(not input.is_noclip_pressed)

	# iterating over contact collisions and detecting hard hits
	var physics_state := PhysicsServer3D.body_get_direct_state(_rid)
	for index in range(get_contact_count()):
		var hit_position := physics_state.get_contact_collider_position(index)
		var hit_impulse := physics_state.get_contact_impulse(index)
		if hit_impulse.length() >= hit_impulse_threshold:
			$CPUParticles3D.global_position = hit_position
			$CPUParticles3D.emitting = true
			$AudioStreamPlayer3D.play()
			break

	# applying impulse (constant velocity) to the body
	apply_central_impulse(mass * target_velocity)


func _apply_free_look(node: Node3D, free_look: Vector2, delta: float) -> void:
	node.rotation.x += free_look.y * delta
	node.rotation.x = clampf(node.rotation.x, orbit_limit_min, orbit_limit_max)
	node.rotate_y(free_look.x * delta)
