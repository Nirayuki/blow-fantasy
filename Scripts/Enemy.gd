extends CharacterBody2D

@onready var anim = %Anim
@onready var collision = %Collision

var speed = 35
var player_chase = false
var player = null
var life = 1

func _physics_process(delta):
	if player_chase and life == 1:
		position += (player.position - position)/speed
		anim.play("run")
		
		if(player.position.x - position.x) < 0:
			anim.flip_h = true
		elif(player.position.x - position.x) > 0:
			anim.flip_h = false
	elif not player_chase and life == 1:
		anim.play("idle")
		

func _on_patrulhe_area_body_entered(body):
	if body.name == "Player":
		player = body
		player_chase = true
	
func _on_patrulhe_area_body_exited(body):
	if body.name == "Player":
		player = null
		player_chase = false
