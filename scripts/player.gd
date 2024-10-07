extends CharacterBody2D

@export var acceleration = 10
@export var max_speed = 6.5
@onready var sprite = $AnimatedSprite2D
@onready var hurtsoundplayer = $hurtSoundPlayer
@onready var dieSoundPlayer = $dieSoundPlayer
@onready var bounceSoundPlayer = $bounceSoundPlayer
@onready var animationplayer = $AnimationPlayer
@export var health = 3
signal health_changed(health)
signal died
signal won
@onready var invulnerability_timer = $Timer
@onready var blood_particles = $BloodParticles
@onready var cheese_particles = $CheeseParticles
@onready var collisionshape = $CollisionShape2D
var alive = true
var cheese_amount = 0

func die():
	alive = false
	sprite.speed_scale = 0
	dieSoundPlayer.play()
	animationplayer.play("die")
	await dieSoundPlayer.finished
	await animationplayer.animation_finished
	died.emit()

func eat_cheese():
	cheese_amount += 1
	cheese_particles.emitting = true
	if cheese_amount == 3:
		animationplayer.play("won")
		alive = false
		collisionshape.set_deferred("disabled", true)
		sprite.speed_scale = 0
		await animationplayer.animation_finished
		won.emit()

func take_damage():
	invulnerability_timer.start()
	health -= 1
	health_changed.emit(health)
	$BloodParticles.emitting = true
	if health == 0:
		die()
	else:
		animationplayer.play("hurt")
		hurtsoundplayer.play()
	
func _physics_process(delta: float) -> void:
	if alive:
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
			sprite.flip_h = true
			cheese_particles.position.x = -42
		elif direction.x == 1:
			sprite.flip_h = false
			cheese_particles.position.x = 42
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
		var collision = move_and_collide(velocity)
		if collision:
			velocity = velocity.bounce(collision.get_normal()) * .9
			#var bounceSoundVolume = linear_to_db(velocity.length())
			#bounceSoundVolume = max(bounceSoundVolume, 10)
			bounceSoundPlayer.play()
	else:
		velocity = Vector2(0,0)
	
func handle_enemy_collision():
	if invulnerability_timer.is_stopped():
		take_damage()
