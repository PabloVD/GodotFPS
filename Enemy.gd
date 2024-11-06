extends KinematicBody


# stats
var health : int = 5
var moveSpeed : float = 1.0
# attacking
var damage : int = 1
var attackRate : float = 1.0
var attackDist : float = 2.0
var scoreToGive : int = 10
# components
onready var player : Node = get_node("/root/MainScene/Player")
onready var timer : Timer = get_node("Timer")

var path = []
var path_node = 0
onready var nav = get_node("/root/MainScene/Environment")

func _ready ():
	# setup the timer
	timer.set_wait_time(attackRate)
	timer.start()
	
func _physics_process (delta):
	if path_node < path.size():
		var dir = path[path_node] - global_transform.origin
		if dir.length() < 1:
			path_node += 1
		else:
			move_and_slide(dir.normalized() * moveSpeed, Vector3.UP)
	"""
	# calculate direction to the player
	var dir = (player.translation - translation).normalized()
	dir.y = 0
	# move the enemy towards the player
	move_and_slide(dir * moveSpeed, Vector3.UP)
	"""

func _on_TimerAttack_timeout():
	
	# if we're at the right distance, attack the player
	if translation.distance_to(player.translation) <= attackDist:
		attack()

# called when we get damaged by the player
func take_damage (damage):
	health -= damage
	# if we've ran out of health - die
	if health <= 0:
		die()
		
func die():
	
	player.add_score(scoreToGive)
	queue_free()

# deals damage to the player
func attack ():
	player.take_damage(damage)

func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_node = 0

func _on_TimerNav_timeout():
	move_to(player.global_transform.origin)
