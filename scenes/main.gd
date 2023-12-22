extends Sprite2D

var score := [0, 0] # 0:Player, 1:CPU
const PADDLE_SPEED : int = 500
const WIN_SCORE = 1
const MAX_SPRINT = 2
@onready var audio_stream_player = $hud/AudioStreamPlayer
@onready var main_audio_player = $AudioStreamPlayer

var start_volume_db = -50
var end_volume_db = -10
var interpolation_factor = 0.0
var interpolation_speed = 0.7  # Adjust this based on how fast you want the volume to increase

func _ready():
	main_audio_player.set_stream(load("res://Mute City.mp3"))
	main_audio_player.play(19)

func _process(delta):
	interpolation_factor += interpolation_speed * delta
	interpolation_factor = clamp(interpolation_factor, 0.0, 1.0)

	var current_volume_db = lerp(start_volume_db, end_volume_db, interpolation_factor)
	main_audio_player.set_volume_db(current_volume_db)

func _on_ball_timer_timeout():
	$ball.new_ball()
	
func _on_score_left_body_entered(body):
	score[1] += 1
	$hud/cpuScore.text = str(score[1])
	if score[1] >= WIN_SCORE:
		audio_stream_player.set_stream(load("res://Fanfare_back.wav"))
		audio_stream_player.play()
		$hud/winAnnouncement.text = "CPU Wins!\n'R' to Restart"
		$hud/winAnnouncement.show()
	else:
		$ballTimer.start()

func _on_score_right_body_entered(body):
	score[0] += 1
	$hud/playerScore.text = str(score[0])
	if score[0] >= WIN_SCORE:
		audio_stream_player.set_stream(load("res://Fanfare.wav"))
		audio_stream_player.play()
		$hud/winAnnouncement.text = "Player Wins!\n'R' to Restart"
		$hud/winAnnouncement.show()
	else:
		$ballTimer.start()
