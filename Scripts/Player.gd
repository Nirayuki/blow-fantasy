extends CharacterBody2D

@onready var sprite = %Sprite
@onready var anim_tree = %AnimationTree
@onready var timer_attack = %Timer_attack

const SPEED = 100
const accel = 100
var is_attacking = false
var state

func _ready():
	state = anim_tree["parameters/playback"]

func _physics_process(delta):

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("left", "right", "up", "down")

		
	handle_movement(direction)
	state_animation(direction)
	handle_attack()
	move_and_slide()
	
func state_animation(direction):
	if is_attacking:
		state.travel("attack")
		return
	if velocity.length() > 1:
		state.travel("walk")
		return
		
	state.travel("idle")

func handle_movement(direction):
	velocity.x = move_toward(velocity.x, SPEED * direction.x, accel)
	velocity.y = move_toward(velocity.y, SPEED * direction.y, accel)
	
	if direction != Vector2.ZERO:
		# Entrando no anim_tree, no parameters nas animações e setando a direção delas.
		anim_tree["parameters/idle/blend_position"] = direction
		anim_tree["parameters/walk/blend_position"] = direction
		anim_tree["parameters/attack/blend_position"] = direction

func handle_attack():
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		timer_attack.start()


func _on_timer_attack_timeout():
	is_attacking = false


func _on_hitbox_body_entered(body):
	if body.is_in_group("enemy"):
		body.player_chase = false
		body.life = 0
		body.anim.play("death")
		body.collision.disabled = true
		await body.anim.animation_finished
		body.queue_free()
