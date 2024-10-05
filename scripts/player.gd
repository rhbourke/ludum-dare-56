extends CharacterBody2D

@export var acceleration = 10
@export var max_speed = 6.5

func _physics_process(delta: float) -> void:
	var is_running = false
	var direction = Vector2(0,0)
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if direction != Vector2(0,0) or velocity.length() > 5:
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("idle")	
	if direction.x == -1:
		$AnimatedSprite2D.flip_h = true
	elif direction.x == 1:
		$AnimatedSprite2D.flip_h = false
	if velocity.y > .01 * max_speed and direction.y == 0:
		direction.y = -1
	if velocity.y < -.01 * max_speed and direction.y == 0:
		direction.y = 1
	if velocity.x > .01 * max_speed and direction.x == 0:
		direction.x = -1
	if velocity.x < -.01 * max_speed  and direction.x == 0:
		direction.x = 1
	if direction.x == 0 and abs(velocity.x) <= .01 * max_speed:
		velocity.x = 0
	if direction.y == 0 and abs(velocity.y) <= .01 * max_speed:
		velocity.y = 0
	direction = direction.normalized()
	
	velocity += direction * acceleration * delta
	velocity = velocity.clamp(Vector2(-max_speed,-max_speed), Vector2(max_speed,max_speed))
	move_and_collide(velocity)
