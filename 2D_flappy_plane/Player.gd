extends RigidBody2D

var impulse_force : int = 1200


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("click"):
		apply_central_impulse(Vector2.UP * impulse_force)
	$Particles.position = Vector2(position.x -50 , position.y - 10)
