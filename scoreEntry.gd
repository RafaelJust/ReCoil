extends Resource

@export var name: String;
@export var score: int;

func _init(p_name = "NUL", p_score = 0) -> void:
	name = p_name;
	score = p_score;
