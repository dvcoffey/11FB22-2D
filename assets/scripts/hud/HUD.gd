extends CanvasLayer

var coins = 0

func _ready():
	$Coins.text = String(coins)

func _physics_process(delta):
	if coins == 10:
		get_tree().change_scene("res://11FB22-2D/assets/scenes/levels/level-1.tscn")


func _on_coin_collected():
	coins += 1
	_ready()
