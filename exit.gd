extends Area3D

@onready var collision_shape_3d = $CollisionShape3D
@onready var win_text = $"../Player/UI/win_text"
func enable_exit():
	collision_shape_3d.disabled = false
	self.visible = true

func interacted_with():
	win_text.visible = true
	print("WIN")
	self.queue_free()
