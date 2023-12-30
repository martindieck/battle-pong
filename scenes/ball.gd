extends CharacterBody2D

var win_size : Vector2
const START_SPEED : int = 500
const ACCEL : int = 50
var speed : int
var dir : Vector2
const MAX_Y_VECTOR : float = 0.6
var isHolding : bool
var sprint : int = 1
var b_height : int
var win_height : int

@onready var player = $"../player"
@onready var audio_stream_player = $AudioStreamPlayer

var ball_pitch : float = 1.0

func _ready():
	win_size = get_viewport_rect().size
	win_height = get_viewport_rect().size.y
	b_height = $ColorRect.get_size().y
	
func new_ball():
	# Randomize start position and direction
	position.x = win_size.x / 2
	position.y = randi_range(200, win_size.y - 200)
	speed = START_SPEED
	ball_pitch = 1
	dir = random_direction()
	
func _physics_process(delta):
	var collision = move_and_collide(dir * speed * delta)
	var collider
	if isHolding:
		if Input.is_action_pressed("sprint"):
			sprint = get_parent().MAX_SPRINT
		else:
			sprint = 1
		if Input.is_action_pressed("up"):
			position.y -= get_parent().PADDLE_SPEED * delta * sprint
		elif Input.is_action_pressed("down"):
			position.y += get_parent().PADDLE_SPEED * delta * sprint
		position.y = clamp(position.y, b_height / 2, win_height - b_height / 2)
		if not Input.is_action_pressed("activate"):
			new_collision(collision)
			isHolding = false
	elif collision:
		new_collision(collision)
	
func new_collision(collision):
	var collider
	if collision:
		audio_stream_player.set_pitch_scale(ball_pitch)
		audio_stream_player.play()
		collider = collision.get_collider()
		if collider == $"../player" and Input.is_action_pressed("activate"):
			isHolding = true
		elif collider == $"../player" or collider == $"../cpu":
			ball_pitch += 0.01
			speed += ACCEL
			dir = new_direction(collider)
			#dir = dir.bounce(collision.get_normal())
		else:
			dir = dir.bounce(collision.get_normal())

func random_direction():
	var new_dir := Vector2()
	new_dir.x = [1, -1].pick_random()
	new_dir.y = randf_range(-1, 1)
	return new_dir.normalized()

func new_direction(collider):
	var ball_y = position.y
	var pad_y = collider.position.y
	var dist = ball_y - pad_y
	var new_dir := Vector2()
	
	#Flip the x coordinate
	if dir.x > 0:
		new_dir.x = -1
	else:
		new_dir.x = 1
	new_dir.y = (dist / (collider.p_height / 2)) * MAX_Y_VECTOR
	return new_dir.normalized()

