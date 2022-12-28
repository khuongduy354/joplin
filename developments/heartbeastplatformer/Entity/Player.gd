extends KinematicBody2D
class_name Player 
signal player_die
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum {CLIMB, MOVE}
var state = MOVE
export(Resource) var MovementData
var is_in_ladder=false  
onready var max_speed = MovementData.max_speed
onready var jump_height=MovementData.jump_height
onready var health = MovementData.health
onready var GRAVITY =MovementData.GRAVITY

var veloc = Vector2.ZERO

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var dir =get_input_direction()
	prepare_state()
	match state: 
		CLIMB: 
			climb(dir.x)
		MOVE: 
			move(dir.x)
	apply_x_accel(dir.x)

func prepare_state():
	if Input.is_action_pressed("ui_up") and is_in_ladder:
		set_state("climb")
	if not is_in_ladder: 
		set_state("move")

func climb(dir): 
	if Input.is_action_pressed("ui_up"):
		veloc.y=-50
	elif Input.is_action_pressed("ui_down"):
		veloc.y=50
	else: 
		veloc.y=0
	move_and_slide(veloc,Vector2.UP)
func hit_by_spikes():
	queue_free()

func move(dir): 
	veloc.y+=GRAVITY
	if is_on_floor():
		if Input.is_action_just_pressed("space"):
			veloc.y=-jump_height
	move_and_slide(veloc,Vector2.UP)

func set_in_ladder(isInLad:bool):
	is_in_ladder = isInLad
	print(is_in_ladder)
	
	
func set_state(state_str): 
	if state_str == "climb":
		state = CLIMB
	if state_str == "move":
		state = MOVE 
		


func get_input_direction():
	var input_dir: Vector2 = Vector2.ZERO
	input_dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_dir.y = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
	return input_dir

func take_damage(damage):
	health -= damage

func die(): 
	emit_signal("player_die")	
	
func _on_Hurtbox_body_entered(body):
	if body is Enemy: 
		self.take_damage(body.damage)

func apply_x_accel(dir):
	veloc.x=move_toward(veloc.x,dir*max_speed,20)
	
func apply_friction():
	veloc.x = move_toward(veloc.x,0,20)
