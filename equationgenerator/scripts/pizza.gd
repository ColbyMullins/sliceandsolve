extends Area2D

signal topping_placed(topping: Sprite2D)
signal topping_left(topping: Sprite2D)

var is_sliding: bool = false
var direction: int = 1

func slide(position: Vector2, delay: int) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position, delay)

func _on_area_entered(area: Area2D) -> void:
	area.get_parent().is_in_pizza = true
	topping_placed.emit(area.get_parent())

func _on_area_exited(area: Area2D) -> void:
	area.get_parent().is_in_pizza = false
	topping_left.emit(area.get_parent())
