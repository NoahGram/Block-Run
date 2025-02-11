extends CharacterBody3D

const SPEED = 11.0
const JUMP_VELOCITY = 4.5
var is_colliding = false
const FALL_THRESHOLD = -10.0
var fade_timer: Timer

@export var transitioner: Transitioner  # Set in Inspector

func _ready() -> void:
	$Area3D.connect("area_entered", Callable(self, "_on_area_entered"))

func _physics_process(delta: float) -> void:
	# Check if player has fallen off the platform
	if global_transform.origin.y < FALL_THRESHOLD:
		trigger_transition_and_reload()

	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Stop player movement on Collision/Death
	if is_colliding:
		velocity.x = move_toward(velocity.x, 0.0, SPEED * delta)
		velocity.y = move_toward(velocity.y, 0.0, SPEED * delta)
		velocity.z = move_toward(velocity.z, 0.0, SPEED * delta)

		if not is_on_floor():
			velocity += get_gravity() * delta
	else:
		# Handle jump
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get input direction and handle movement/deceleration
		var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

		velocity.x = move_toward(velocity.x, 12.5, SPEED)
		if direction:
			velocity.z = direction.z * SPEED
		else:
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _on_area_entered(area: Area3D) -> void:
	is_colliding = true
	trigger_transition_and_reload()
	

func trigger_transition_and_reload() -> void:
	if transitioner:
		transitioner.start_transition()
