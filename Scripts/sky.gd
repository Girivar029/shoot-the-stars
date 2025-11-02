extends Node3D

enum EventType { SHOOTING_STAR, AURORA, SATELLITE, COMET}

@export var event_type: EventType =  EventType.SHOOTING_STAR
@export var rarity: String = "common"
@export var move_speed: float = 5.0


func _ready() -> void:
	match event_type:
		EventType.SHOOTING_STAR:
			setup_shooting_star()
		EventType.AURORA:
			setup_aurora()

func setup_shooting_star():
	pass
	
func setup_aurora():
	pass


func _process(delta: float) -> void:
	if event_type == EventType.SHOOTING_STAR:
		position.x += move_speed * delta
		
		if position.x > 100:
			queue_free()
