extends CharacterBody3D

@onready var head = $CollisionShape3D/head

var current_speed = 5.0
const walking_speed = 5.0
const sprinting_speed = 8.0
const crouching_speed = 3.0
const jump_velocity = 4.5
const mouse_sens = 0.010
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var ui_script = $"../ui"
@onready var ray = $CollisionShape3D/head/Camera3D/RayCast3D
var player_health = 100

func _ready():
	add_to_group("player")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sens)
		head.rotate_x(-event.relative.y * mouse_sens)
		head.rotation.x = clamp(head.rotation.x,deg_to_rad(-89), deg_to_rad(89))
		
func _physics_process(delta):
	
	if Input.is_action_pressed("sprint"):
		current_speed = sprinting_speed
	else:
		current_speed = walking_speed
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	
	if Input.is_action_pressed("ui_accept"):
		if ui_script.can_shoot:
			shoot()
			
	move_and_slide()

func shoot():
	if ray.is_colliding() and ray.get_collider().has_method("take_damage"):
		ray.get_collider().take_damage(1)  # Inflict 1 damage point per shot

func damage():
	player_health -= 10
	print(player_health)
	if player_health <= 0:
		queue_free()
