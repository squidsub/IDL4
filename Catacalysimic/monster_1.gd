extends CharacterBody3D

@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("player")
@onready var detection_area : Area3D = $Area3D  # Assuming the Area2D node is named "DetectionArea"

const SPEED = 5.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")  # Get the gravity from the project settings to be synced with RigidBody nodes.
var dead = false
var is_attacking = false  
var attack_range = 2
var health = 50  # Add a health variable
var player_in_range = false  # Add a flag to check if the player is in range

func _ready():
	add_to_group("enemy")

func _physics_process(delta):
	if dead or not player_in_range:  # Check if the enemy is dead or if the player is not in range
		return

	if player == null:
		return

	var dir = player.global_position - global_position
	dir.y = 0.0
	dir = dir.normalized()

	# Only set the x and z components for the direction towards the player.
	velocity.x = dir.x * SPEED
	velocity.z = dir.z * SPEED

	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0.0

	move_and_slide()
	attack()

func attack():
	var dist_to_player = global_position.distance_to(player.global_position)
	if dist_to_player > attack_range:
		is_attacking = false  # Reset the attacking flag
		$AnimatedSprite3D.play("default")
		return
	else:
		is_attacking = true  # Set the attacking flag
		$AnimatedSprite3D.play("attack")

func take_damage(amount):  # Add a take_damage function
	health -= amount
	if health <= 0:
		die()

func die():
	dead = true  # Corrected variable scope
	$AnimatedSprite3D.play("die")
	$CollisionShape3D.disabled = true

func _on_area_3d_body_entered(body):
	if body == player:
		player_in_range = true

func _on_area_3d_body_exited(body):
	if body == player:
		player_in_range = false

