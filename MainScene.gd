extends Spatial

var playing = false
var gameover = false

func _ready ():
	#$EnemyInstancer.set_process(false)
	#get_tree().paused = true
	#$GameOverMusic.stop()
	pass

#"""
func new_game():
	playing = true
	$EnemyInstancer.playing = true
	$Player.start_player(Vector3(0,0,0))
	#$Player.start($StartPosition.position)
	#$EnemyInstancer.set_process(true)
	#$StartTimer.start()
	#get_tree().paused = false
	$MainMusic.play()

#"""
func _process(delta):
	
	if gameover:
		if $GameOverMusic.playing==false:
			$GameOverMusic.play()
