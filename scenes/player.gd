extends StaticBody2D

var win_height : int
var p_height : int
var sprint : int = 1
const MAX_SPRINT = 2

func _ready():
	win_height = get_viewport_rect().size.y
	p_height = $ColorRect.get_size().y

func _process(delta):
	if Input.is_action_pressed("sprint"):
		sprint = MAX_SPRINT
	else:
		sprint = 1
	
	if Input.is_action_pressed("up"):
		position.y -= get_parent().PADDLE_SPEED * delta * sprint
	elif Input.is_action_pressed("down"):
		position.y += get_parent().PADDLE_SPEED * delta * sprint
	
	
	# Limit the paddle movement to window
	position.y = clamp(position.y, p_height / 2, win_height - p_height / 2)
	
	if Input.is_action_pressed("reset"):
		get_tree().reload_current_scene()
