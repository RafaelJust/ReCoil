extends MeshInstance2D

@onready var is_child = self.get_parent().name == "childHolder"
@export var childHolder: Node2D
@export var Area: Area2D


func _process(delta: float) -> void:
	if self.self_modulate.a < 0.1:
		self.self_modulate.a += delta * 0.1
	if is_child:
		self.scale -= Vector2(delta * 200, delta * 200)
		if self.scale.x < 0.1:
			self.queue_free()
	else:
		for obj in Area.get_overlapping_bodies():
			if not obj == get_parent().get_parent() and obj is RigidBody2D:
				obj.apply_central_force((self.global_position - obj.global_position) * 2)

func _on_timer_timeout() -> void:
	var child: Node2D = self.duplicate(14)
	child.self_modulate.a = 0
	child.visible = true
	childHolder.add_child(child)
