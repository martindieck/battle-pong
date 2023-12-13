extends Sprite2D

var score := [0, 0] # 0:Player, 1:CPU
const PADDLE_SPEED : int = 500
const WIN_SCORE = 1

func _on_ball_timer_timeout():
	$ball.new_ball()
	
func _on_score_left_body_entered(body):
	score[1] += 1
	$hud/cpuScore.text = str(score[1])
	if score[1] >= WIN_SCORE:
		$hud/winAnnouncement.text = "CPU Wins!\n'R' to Restart"
		$hud/winAnnouncement.show()
	else:
		$ballTimer.start()

func _on_score_right_body_entered(body):
	score[0] += 1
	$hud/playerScore.text = str(score[0])
	if score[0] >= WIN_SCORE:
		$hud/winAnnouncement.text = "Player Wins!\n'R' to Restart"
		$hud/winAnnouncement.show()
	else:
		$ballTimer.start()
