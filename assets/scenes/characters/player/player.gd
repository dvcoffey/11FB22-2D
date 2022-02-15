extends KinematicBody2D

const SPEED = 150
const GRAVITY = 9.8
const JUMPFORCE = -300

var coins = 0
var velocity = Vector2(0,0)

func _physics_process(delta):
	if Input.is_action_pressed("right"):
		velocity.x = SPEED
		$AnimatedSprite.play("run")
		$AnimatedSprite.flip_h = false
	elif Input.is_action_pressed("left"):
		velocity.x = -SPEED
		$AnimatedSprite.play("run")
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.play("idle")
	
	if not is_on_floor():
		$AnimatedSprite.play("jump")
	
	velocity.y = velocity.y + GRAVITY
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMPFORCE
	

	velocity = move_and_slide(velocity,Vector2.UP)
	
	velocity.x = lerp(velocity.x,0,0.2)
	
	if coins == 10:
		get_tree().change_scene("res://11FB22-2D/assets/scenes/levels/level-1.tscn")


func _on_fallzone_body_entered(body):
	get_tree().change_scene("res://11FB22-2D/assets/scenes/levels/level-1.tscn")
	print("death")

func add_coin():
	coins += 1
	print(coins)
