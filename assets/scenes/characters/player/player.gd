extends KinematicBody2D

enum States {ATTACK1 = 1, ATTACK2, ATTACK3, ATTACK4, AIR, FLOOR }

const SPEED = 180
const GRAVITY = 9.8
const JUMPFORCE = -300

var attackPoints = 4
var coins = 0
var velocity = Vector2(0,0)
var state = States.AIR


#-----Movement and gravity functions.


func move_and_fall():
	velocity = move_and_slide(velocity,Vector2.UP)
	velocity.y = velocity.y + GRAVITY


#-----Attack functions.


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "attack-1" || $AnimatedSprite.animation == "attack-2" || $AnimatedSprite.animation == "attack-3" || $AnimatedSprite.animation == "attack-4":
		checkState()


func _on_attacktimer_timeout():
	attackPoints = 4


#-----Damage and Death funstions.


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
	
	$"death-timer".start()


func _on_Timer_timeout():
	get_tree().change_scene("res://11FB22-2D/assets/scenes/levels/level-1.tscn")


#-----Game Loop.


func checkState():

	if Input.is_action_just_pressed("attack"):
		attackPoints = attackPoints - 1
		state = States.ATTACK1
	elif Input.is_action_just_pressed("attack-2"):
		state = States.ATTACK4
	else:
		if not is_on_floor():
			state = States.AIR
		else:
			state = States.FLOOR
	print(attackPoints)


func _physics_process(delta):
	match state:

		States.ATTACK1:
			$"attack-timer".start()
			$AnimatedSprite.play("attack-1")
			if Input.is_action_just_pressed("attack") and attackPoints == 3:
				attackPoints = attackPoints - 1
				state = States.ATTACK2
			if Input.is_action_just_pressed("attack-2") and attackPoints == 3:
				attackPoints = attackPoints - 1
				state = States.ATTACK4
			else:
				continue

		States.ATTACK2:
			$"attack-timer".start()
			$AnimatedSprite.play("attack-2")
			if Input.is_action_just_pressed("attack") and attackPoints == 2:
				attackPoints = attackPoints - 1
				state = States.ATTACK3
			else:
				continue

		States.ATTACK3:
			$"attack-timer".start()
			$AnimatedSprite.play("attack-3")
			if Input.is_action_just_pressed("attack-2") and attackPoints == 1:
				attackPoints = attackPoints - 1
				state = States.ATTACK4
			elif Input.is_action_just_pressed("attack") and attackPoints == 1:
				checkState()
			else:
				continue
			
		States.ATTACK4:
			attackPoints = 4
			$AnimatedSprite.play("attack-4")

		States.AIR:
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
			checkState()

		States.FLOOR:
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
			checkState()

