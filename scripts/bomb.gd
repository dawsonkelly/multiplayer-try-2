extends RigidBody2D

@export var _explosion : PackedScene

func _ready() -> void:
	await get_tree().create_timer(3).timeout
	explode()

func explode() -> void:
	var explosion = _explosion.instantiate()
	explosion.position = global_position
	explosion.rotation = global_rotation
	explosion.emitting = true
	get_tree().current_scene.add_child(explosion)
	
	queue_free()
