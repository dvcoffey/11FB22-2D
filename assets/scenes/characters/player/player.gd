extends KinematicBody2D

enum States {ATTACK1 = 1, ATTACK2, ATTACK3, \
ATTACK4, AIR, FLOOR }

const SPEED = 180
const GRAVITY = 9.8
const JUMPFORCE = -300

var attackPoints = 4
var coins = 0
var velocity = Vector2(0,0)
var state = States.AIR
var playerHP = 32
var slashDMG = 10
var thrustDMG = 20
var sweepDMG = 30


#------------Movement and gravity.


func move_and_fall():
	velocity = move_and_slide(velocity,Vector2.UP)
	velocity.y = velocity.y + GRAVITY


#------------Attack.


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "attack-1" \
	|| $AnimatedSprite.animation == "attack-2" \
	|| $AnimatedSprite.animation == "attack-3" \
	|| $AnimatedSprite.animation == "attack-4":
		$"AnimatedSprite/slash-1/slash-1-hitbox".disabled = true
		$"AnimatedSprite/slash-3/slash-3-hitbox".disabled = true
		$"AnimatedSprite/slash-4/slash-4-hitbox".disabled = true
	checkState()


func _on_attacktimer_timeout():
	attackPoints = 4

func attack_motion():
	if Input.is_action_pressed("right"):
		velocity.x = SPEED
		$AnimatedSprite.scale.x = 1
	elif Input.is_action_pressed("left"):
		velocity.x = -SPEED
		$AnimatedSprite.scale.x = -1
	else:
		velocity.x = lerp(velocity.x,0,0.2)
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMPFORCE
	move_and_fall()


#----------Damage and Death.


func _on_fallzone_body_entered(body):
	get_tree().change_scene\
	("res://11FB22-2D/assets/scenes/levels/level-1.tscn")


func bounce():
	velocity.y = JUMPFORCE


func _on_Timer_timeout():
	get_tree().change_scene\
	("res://11FB22-2D/assets/scenes/levels/level-1.tscn")


#----------Game Loop.


func checkState():
	attackPoints = 4
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


func _physics_process(delta):
	
	match state:
		
		#----------Attack States

		States.ATTACK1:
			attack_motion()
			$"attack-timer".start()
			$AnimatedSprite.play("attack-1")
			$"AnimatedSprite/slash-1/slash-1-hitbox".disabled \
			= false

			if Input.is_action_just_pressed("attack") \
			and attackPoints == 3:
				attack_motion()
				attackPoints = attackPoints - 1
				state = States.ATTACK2

			if Input.is_action_just_pressed("attack-2") \
			and attackPoints == 3:
				attack_motion()
				attackPoints = attackPoints - 1
				state = States.ATTACK4

			else:
				continue

		States.ATTACK2:
			attack_motion()
			$"attack-timer".start()
			$AnimatedSprite.play("attack-2")
			$"AnimatedSprite/slash-1/slash-1-hitbox".disabled \
			= false

			if Input.is_action_just_pressed("attack") \
			and attackPoints == 2:
				attack_motion()
				attackPoints = attackPoints - 1
				state = States.ATTACK3

			else:
				continue

		States.ATTACK3:
			attack_motion()
			$"attack-timer".start()
			$AnimatedSprite.play("attack-3")
			$"AnimatedSprite/slash-3/slash-3-hitbox".disabled \
			= false

			if Input.is_action_just_pressed("attack-2") \
			and attackPoints == 1:
				attack_motion()
				attackPoints = attackPoints - 1
				state = States.ATTACK4

			elif Input.is_action_just_pressed("attack") \
			and attackPoints == 1:
				attack_motion()
				checkState()

			else:
				continue

		States.ATTACK4:
			attack_motion()
			$"AnimatedSprite/slash-4/slash-4-hitbox".disabled \
			= false
			$AnimatedSprite.play("attack-4")

		#----------Movement states

		States.AIR:
			$AnimatedSprite.play("jump")
			if Input.is_action_pressed("right"):
				velocity.x = SPEED
				$AnimatedSprite.scale.x = 1

			elif Input.is_action_pressed("left"):
				velocity.x = -SPEED
				$AnimatedSprite.scale.x = -1

			else:
				velocity.x = lerp(velocity.x,0,0.2)

			move_and_fall()
			checkState()

		States.FLOOR:
			if Input.is_action_pressed("right"):
				$AnimatedSprite.play("run")
				$AnimatedSprite.scale.x = 1
				velocity.x = SPEED

			elif Input.is_action_pressed("left"):
				$AnimatedSprite.play("run")
				$AnimatedSprite.scale.x = -1
				velocity.x = -SPEED

			else:
				$AnimatedSprite.play("idle")
				velocity.x = lerp(velocity.x,0,0.2)

			if Input.is_action_just_pressed("jump"):
				velocity.y = JUMPFORCE
				state = States.AIR

			move_and_fall()
			checkState()

