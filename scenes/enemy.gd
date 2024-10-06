extends CharacterBody2D

var speed = 150
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var navigation_agent_2d = $NavigationAgent2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var eye_light_pos = $"AnimatedSprite2D/Eye Light".position
@onready var shadow_pos = $AnimatedSprite2D/Shadow.position
@onready var collision_shape_pos = $CollisionShape2D.position

func _ready():
	call_deferred("setup")

func setup():
	await get_tree().physics_frame
	if player:
		navigation_agent_2d.target_position = player.global_position
	
func _physics_process(delta: float) -> void:
	if navigation_agent_2d.is_navigation_finished():
		return
	var next_path_position = navigation_agent_2d.get_next_path_position()
	var new_velocity = global_position.direction_to(next_path_position) * speed
	
	if navigation_agent_2d.avoidance_enabled:
		navigation_agent_2d.velocity = new_velocity
	else:
		velocity = new_velocity
	
	if new_velocity.x > 0:
		animated_sprite_2d.flip_h = false
		$"AnimatedSprite2D/Eye Light".position.x = eye_light_pos.x
		$AnimatedSprite2D/Shadow.position.x = shadow_pos.x
		$CollisionShape2D.position.x = collision_shape_pos.x
	else:
		animated_sprite_2d.flip_h = true
		$"AnimatedSprite2D/Eye Light".position.x = -eye_light_pos.x
		$AnimatedSprite2D/Shadow.position.x = -shadow_pos.x
		$CollisionShape2D.position.x = -collision_shape_pos.x
		
	move_and_slide()
		
func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity


func _on_timer_timeout() -> void:
	if player:
		navigation_agent_2d.target_position = player.global_position
