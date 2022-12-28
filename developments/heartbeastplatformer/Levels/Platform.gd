extends TileMap


var player = load("res://Entity/Player.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_player()

func spawn_player(): 
	var player_instance:Player = player.instance()
	player_instance.position = $spawnpoint.position
	player_instance.connect("player_die",self,"spawn_player")
	add_child(player_instance)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
