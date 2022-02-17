extends KinematicBody2D

enum States {ATTACK = 1, AIR, FLOOR }

const SPEED = 180
const GRAVITY = 9.8
const JUMPFORCE = -300

var coins = 0
var velocity = Vector2(0,0)
var state = States.AIR


func _physics_process(delta):
	match state:
		States.ATTACK:
			$AnimatedSprite.play("attack")
			if Input.is_action_pressed("right"):
				velocity.x = SPEED
				$AnimatedSprite.flip_h = false
			elif Input.is_action_pressed("left"):
				velocity.x = -SPEED
				$AnimatedSprite.flip_h = true

		States.AIR:
			if is_on_floor():
				state = States.FLOOR
				continue
			$AnimatedSprite.play("jump")
			if Input.is_action_pressed("right"):
				velocity.x = SPEED
				$AnimatedSprite.flip_h = false
			elif Input.is_action_pressed("left"):
				velocity.x = -SPEED
				$AnimatedSprite.flip_h = true
			else:
				velocity.x = lerp(velocity.x,0,0.2)
			move_and_fall()
			if Input.is_action_pressed("attack"):
				state = States.ATTACK
		
		States.FLOOR:
			if not is_on_floor():
				state = States.AIR
				continue
			if Input.is_action_pressed("right"):
				$AnimatedSprite.play("run")
				$AnimatedSprite.flip_h = false
				velocity.x = SPEED
			elif Input.is_action_pressed("left"):
				$AnimatedSprite.play("run")
				$AnimatedSprite.flip_h = true
				velocity.x = -SPEED
			else:
				$AnimatedSprite.play("idle")
				velocity.x = lerp(velocity.x,0,0.2)
			if Input.is_action_just_pressed("jump"):
				velocity.y = JUMPFORCE
				state = States.AIR
			move_and_fall()
			if Input.is_action_pressed("attack"):
				state = States.ATTACK

func _on_AnimatedSprite_animation_finished():
	if not is_on_floor():
		state = States.AIR
	else:
		state = States.FLOOR
		


func move_and_fall():
	velocity = move_and_slide(velocity,Vector2.UP)
	velocity.y = velocity.y + GRAVITY
		

func _on_fallzone_body_entered(body):
	get_tree().change_scene("res://11FB22-2D/assets/scenes/levels/level-1.tscn")
	print("death")
	

func bounce():
	velocity.y = JUMPFORCE
	
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





