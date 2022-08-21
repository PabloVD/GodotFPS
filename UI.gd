extends Control


onready var healthBar : TextureProgress = get_node("HealthBar")
onready var ammoText : Label = get_node("AmmoText")
onready var scoreText : Label = get_node("ScoreText")

#onready var mainScene = get_node("/root/MainScene")
onready var mainmusic = get_node("/root/MainScene/MainMusic")
onready var gameovermusic = get_node("/root/MainScene/GameOverMusic")
onready var player = get_node("/root/MainScene/Player")

signal start_game

func _ready():
	
	healthBar.hide()
	ammoText.hide()
	scoreText.hide()

func update_health_bar (curHp, maxHp):
  
	healthBar.max_value = maxHp
	healthBar.value = curHp
  
func update_ammo_text (ammo):
  
	ammoText.text = "Ammo: " + str(ammo)
  
func update_score_text (score):
  
	scoreText.text = "Score: " + str(score)

func game_over_text ():
  
	show_message("Game Over\nScore: "+str(player.score))
	
	#mainScene.MainMusic.stop()
	#mainScene.GameOverMusic.play()
	mainmusic.stop()
	#var gameovermusic = get_node("/root/MainScene/GameOverMusic")
	#gameovermusic.play()
	#$GameOver.text = "Game Over"
	#$Timer.start()
	
	#yield($MessageTimer, "timeout")
	"""
	$Message.text = "Title\nScreen!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()
	"""
	yield(get_tree().create_timer(4), "timeout")
	
	get_tree().reload_current_scene()
	get_tree().paused = false
	
	#get_tree().paused = false
	#get_tree().reload_current_scene()

func show_message(text):
	$Message.text = text
	$Message.show()
	#$MessageTimer.start()

#func _on_MessageTimer_timeout():
#	$Message.hide()

func _process(delta):
	if Input.is_action_pressed("enter"):
		$StartButton.hide()
		$Message.hide()
		emit_signal("start_game")
		#get_tree().reload_current_scene()
		healthBar.show()
		ammoText.show()
		scoreText.show()
