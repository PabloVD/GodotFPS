extends KinematicBody

# stats
var curHp : int = 10
var maxHp : int = 10
var ammo : int = 30
var score : int = 0
# physics
var moveSpeed : float = 5.0
var jumpForce : float = 5.0
var gravity : float = 12.0
# cam look
var minLookAngle : float = -90.0
var maxLookAngle : float = 90.0
var lookSensitivity : float = 0.1
# vectors
var vel : Vector3 = Vector3()
var mouseDelta : Vector2 = Vector2()
# player components
onready var camera = get_node("Camera")

onready var muzzle = get_node("Camera/GunModel/Muzzle")
onready var bulletScene = preload("res://Bullet.tscn")
onready var mainScene = get_node("/root/MainScene")

onready var ui : Control = get_node("/root/MainScene/CanvasLayer/UI")

var playing = false

func _ready ():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# set the UI
	ui.update_health_bar(curHp, maxHp)
	ui.update_ammo_text(ammo)
	ui.update_score_text(score)
	
	#$CollisionShape.disabled = true
	hide()

# called when an input is detected
func _input (event):
	# did the mouse move?
	if event is InputEventMouseMotion:
		mouseDelta = event.relative


# called every frame
func _process (delta):
	if playing:
		# rotate camera along X axis
		camera.rotation_degrees -= Vector3(rad2deg(mouseDelta.y), 0, 0) * lookSensitivity * delta
		# clamp the vertical camera rotation
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, minLookAngle, maxLookAngle)
	  
		# rotate player along Y axis
		rotation_degrees -= Vector3(0, rad2deg(mouseDelta.x), 0) * lookSensitivity * delta
	  
		# reset the mouse delta vector
		mouseDelta = Vector2()
		
		# check to see if we're shooting
		if Input.is_action_just_pressed("shoot") and ammo>0:
			shoot()

# called every physics step
func _physics_process (delta):
	
	if playing:
	
		if translation.y < -10:
			die()
		
		# reset the x and z velocity
		vel.x = 0
		vel.z = 0
		var input = Vector2()
		# movement inputs
		if Input.is_action_pressed("move_forward"):
			input.y -= 1
		if Input.is_action_pressed("move_backward"):
			input.y += 1
		if Input.is_action_pressed("move_left"):
			input.x -= 1
		if Input.is_action_pressed("move_right"):
			input.x += 1
		# normalize the input so we can't move faster diagonally
		input = input.normalized()
		
		# get our forward and right directions
		var forward = global_transform.basis.z
		var right = global_transform.basis.x
		
		# This is the direction vector in the 2d plane
		# forward and right are 3d vectors in those directions
		# Moves input.y in the forward direction, and input.x in the right direction
		# Quite confusing and inconsistent nomenclature
		var direc_vec = forward * input.y + right * input.x
		
		# set the velocity
		vel.z = direc_vec.z * moveSpeed
		vel.x = direc_vec.x * moveSpeed
		# apply gravity
		vel.y -= gravity * delta
		# move the player
		vel = move_and_slide(vel, Vector3.UP)
		
		# jump if we press the jump button and are standing on the floor
		if Input.is_action_pressed("jump") and is_on_floor():
			vel.y = jumpForce


# called when we press the shoot button - spawn a new bullet
func shoot():
	var bullet = bulletScene.instance()
	mainScene.add_child(bullet)
	bullet.global_transform = muzzle.global_transform
	bullet.scale = Vector3.ONE
	ammo -= 1
	ui.update_ammo_text(ammo)

func add_score(points):
	score += points
	ui.update_score_text(score)

# called when we get damaged by the player
func take_damage (damage):
	curHp -= damage
	ui.update_health_bar(curHp, maxHp)
	# if we've ran out of health - die
	if curHp <= 0:
		die()
		
func die():
	#queue_free()
	mainScene.gameover = true
	playing = false
	#get_tree().paused = true
	ui.game_over_text()
	
# adds an amount of health to the player
func add_health (amount):
	curHp = clamp(curHp + amount, 0, maxHp)
	ui.update_health_bar(curHp, maxHp)
	

# adds an amount of ammo to the player
func add_ammo (amount):
	ammo += amount
	ui.update_ammo_text(ammo)

func start_player(pos):
	# hide and lock the mouse cursor when playing
	# Uncomment to lock mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	translation = pos
	score = 0
	playing = true
	show()
	#$CollisionShape.disabled = false
