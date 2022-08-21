extends Spatial

onready var enemyScene = preload("res://Enemy.tscn")
onready var mainScene = get_node("/root/MainScene")
var min_x : int = 0
var max_x : int = 55
var min_z : int = -5
var max_z : int = 5

var playing = false

func _on_Timer_timeout():
	
	if playing:
	
		var enemy = enemyScene.instance()
		
		mainScene.add_child(enemy)
		var posenemy = Vector3(rand_range(min_x, max_x), 0, rand_range(min_z, max_z))

		enemy.translation = posenemy
