extends CharacterBody3D

const SPEED = 11.0
const JUMP_VELOCITY = 4.5
var is_colliding = false
const FALL_THRESHOLD = -10.0
var fade_timer: Timer

func _ready() -> void:
	$Area3D.connect("area_entered", Callable(self, "_on_area_entered"))
	fade_timer = Timer.new()
	fade_timer.wait_time = 2.0
	fade_timer.one_shot = true
	fade_timer.connect("timeout", Callable(self, "_on_fade_timeout"))
	add_child(fade_timer)

func _physics_process(delta: float) -> void:
		
	# Add gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Stop player movement on Collision/Death
	if is_colliding:
		velocity.x = move_toward(velocity.x, 0.0, SPEED * delta)
		velocity.y = move_toward(velocity.y, 0.0, SPEED * delta)
		velocity.z = move_toward(velocity.z, 0.0, SPEED * delta)
		
		# Add gravity on Collision/Death.
		if not is_on_floor():
			velocity += get_gravity() * delta
	else:
		# Get input direction and handle movement/deceleration.
		var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _on_area_entered(area: Area3D) -> void:
	is_colliding = true
	fade_timer.start()

func _on_fade_timeout() -> void:
	get_tree().reload_current_scene()
