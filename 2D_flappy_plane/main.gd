extends Node

var dynamic_object_speed : int = 700
var health_decrease_speed : int = 5
var health : float = 100
var score : float 

@export var obstacle : PackedScene
@export var coin : PackedScene

var last_obstacle_position : String 
var spawned_obeject_position_x : int = 1700



func _process(delta):
	#position.x -= delta * dynamic_object_speed
	for dynamic_object in get_tree().get_nodes_in_group("DynamicObject"):
		dynamic_object.position.x -= delta * dynamic_object_speed
	
	if health > 0:
		health -= delta * health_decrease_speed
		$UI/Health.value = health
	else:
		_game_over()
	score += delta
	var formatted : String  = str(score)
	var decimal_idx = formatted.find('.')
	formatted = formatted.left(decimal_idx + 3)
	$UI/Health/HealthLabel.text = formatted
	

func _on_spawner_timer_timeout():
	var rand : int = randi() % 2 
	var obstacle_inst : Area2D = obstacle.instantiate()
	add_child(obstacle_inst)
	obstacle_inst.position.x = spawned_obeject_position_x
	obstacle_inst.body_entered.connect(_on_obstacle_collided)
	if rand == 0:
		obstacle_inst.position.y = 200
		last_obstacle_position = "UP"
	if rand == 1:
		obstacle_inst.position.y = 800
		obstacle_inst.scale.y *= -1
		last_obstacle_position = "DOWN"


func _on_coin_timer_timeout():
	var rand_pos : int = randi() % 3
	
	if rand_pos == 0 and last_obstacle_position == "UP":
		return
	if rand_pos == 2 and last_obstacle_position == "DOWN":
		return
		
	var coin_instance : Area2D = coin.instantiate()
	add_child(coin_instance)
	coin_instance.position.x = spawned_obeject_position_x
	coin_instance.position.y = 280 + rand_pos * 200 
	coin_instance.body_entered.connect(_on_coin_collided.bind(coin_instance))
	
	
func _on_coin_collided(body : Node2D, coin_inst : Area2D) -> void:
	if body.is_in_group("Player"):
		$Player/coincollected.play()
		health += 4
		coin_inst.get_node("AnimationPlayer").play("coin_collected")
		
		
		
	if health > 100:
		health = 100

func _game_over() -> void:
	$Player/gameover.play()
	$GameOver.show()
	get_tree().paused = true

func _on_obstacle_collided(body: Node2D) -> void:
	if body.is_in_group('Player'):
		_game_over()
