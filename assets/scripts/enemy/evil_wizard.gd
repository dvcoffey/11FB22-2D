extends KinematicBody2D

var velocity = Vector2()
var speed = 50
export var direction = 1
export var detects_cliffs = true

func _ready():
	if direction == -1:
		$AnimatedSprite.flip_h = true
	$floorcheck.position.x = $CollisionShape2D.shape.get_extents().x * direction
	$floorcheck.enabled = detects_cliffs

func _physics_process(delta):
	
	if is_on_wall() or not $floorcheck.is_colliding() and detects_cliffs and is_on_floor():
		direction = direction * -1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
		$floorcheck.position.x = $CollisionShape2D.shape.get_extents().x * direction
	
	velocity.y +=20
	
	velocity.x = speed * direction
	
	velocity = move_and_slide(velocity,Vector2.UP)


func _on_top_checker_body_entered(body):
	print("hit")
	$AnimatedSprite.play("death")
	speed = 0
	set_collision_layer_bit(4,false)
	set_collision_mask_bit(0,false)
	$top_checker.set_collision_layer_bit(4,false)
	$top_checker.set_collision_mask_bit(0,false)
	$sides_checker.set_collision_layer_bit(4,false)
	$sides_checker.set_collision_mask_bit(0,false)
	$Timer.start()
	body.bounce()



func _on_Timer_timeout():
	queue_free()


func _on_wizardarea_area_entered(area):
	if area.is_in_group("slash"):
		queue_free()
