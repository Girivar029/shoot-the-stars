extends Node3D

@export var event_scene: PackedScene
@export var spawn_interval: float = 5.0
@export var spawn_radius: float = 50.0

var time_since_spawn: float = 0.0

func _ready() -> void:
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_since_spawn += delta
	
	if time_since_spawn >= spawn_interval:
		spawn_random_event()
		time_since_spawn = 0.0

func spawn_random_event():
	if event_scene == null:
		return
	
	var event = event_scene.instantiate()
	add_child(event)
	
	var angle_h = randf_range(0,2 * PI)
	var angle_v = randf_range(-PI/4 , PI/2)
	
	var x = cos(angle_h) * cos(angle_v) * spawn_radius
	var y = sin(angle_v) * spawn_radius
	var z = sin(angle_h) * cos(angle_v) * spawn_radius
	
	event.position = Vector3(x,y,z)
	
	var rarities = ["common", "common", "common", "uncommon", "uncommon", "rare", "epic", "legendary"]
	event.rarity = rarities[randi() % rarities.size()]
	
	print("Spawned event with rarity: ", event.rarity)
