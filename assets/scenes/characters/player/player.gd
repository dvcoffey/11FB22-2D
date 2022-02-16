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
	

func _on_fallzone_body_entered(body):
	get_tree().change_scene("res://11FB22-2D/assets/scenes/levels/level-1.tscn")
	print("death")
	

func bounce():
	velocity.y = JUMPFORCE * .5
	
func hit(var enemyposx):
	set_modulate(Color(1,0.3,0.3,0.3))
	velocity.y = JUMPFORCE * .5
	
	if position.x < enemyposx:
		velocity.x = - 750
	elif position.x > enemyposx:
		velocity.x = 750
		
	Input.action_release("left")
	Input.action_release("right")
	
	$Timer.start()


func _on_Timer_timeout():
	get_tree().change_scene("res://11FB22-2D/assets/scenes/levels/level-1.tscn")
