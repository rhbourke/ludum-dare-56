extends Area2D

signal cheese_grabbed
@onready var pickup_sound_player = $pickupSoundPlayer
@onready var munch_sound_player = $munchSoundPlayer
@onready var collisionshape = $CollisionShape2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		cheese_grabbed.emit()
		hide()
		collisionshape.set_deferred("disabled", true)
		pickup_sound_player.play()
		await pickup_sound_player.finished
		munch_sound_player.play()
		body.eat_cheese()
		await munch_sound_player.finished
		queue_free()
