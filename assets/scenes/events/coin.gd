extends Area2D


func _on_coin_body_entered(body):
	print("collect")
	$AnimationPlayer.play("collect")
	body.add_coin()



func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
