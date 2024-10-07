extends Node2D

@export var spider: PackedScene
@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var timer = $Timer
@export var spawn_time: int

func _ready():
	sprite.rotation = randf_range(0, 360)
	timer.start(randf_range(0, spawn_time))

func spawn():
	var enemies = get_tree().get_nodes_in_group("Enemy")
	if enemies.size() < 100:
		animation_player.play("spawn_anim")
		await animation_player.animation_finished
		var spider = spider.instantiate()
		add_child(spider)
	

func _on_timer_timeout() -> void:
	spawn()
	timer.start(spawn_time)
