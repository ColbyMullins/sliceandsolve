extends Node

var toppings_objects = {"pepperoni": [], "mushroom": [], "ham": []}
var toppings = {"pepperoni": 0, "mushroom": 0, "ham": 0}
@onready var line_edit: LineEdit = $"../LineEdit"
@onready var toppings_container: Node = $"../Toppings"
#var cleared = false
@onready var solution_label: Label = $"../SolutionLabel"


func _on_pizza_topping_placed(topping: Sprite2D) -> void:
	toppings_objects[topping.topping_type].append(topping)
	toppings[topping.topping_type] += 1
	line_edit.text = str(toppings[topping.topping_type])
	print(toppings_objects)

func clear_all() -> void:
	toppings_objects = {"pepperoni": [], "mushroom": [], "ham": []}
	toppings = {"pepperoni": 0, "mushroom": 0, "ham": 0}
	for child in toppings_container.get_children():
		child.queue_free()
	line_edit.text = "0"
	#cleared = true



func _on_pizza_topping_left(topping: Sprite2D) -> void:
	toppings[topping.topping_type] -= 1
	toppings_objects[topping.topping_type].remove_at(toppings_objects[topping.topping_type].rfind(topping))
	line_edit.text = str(toppings[topping.topping_type])
	if int(line_edit.text) < 0:
		line_edit.text = "0"
		toppings = {"pepperoni": 0, "mushroom": 0, "ham": 0}
	print(toppings_objects)


func _on_spawner_spawn_topping(topping: Sprite2D) -> void:
	toppings_container.add_child(topping)


func _on_submit_button_pressed() -> void:
	line_edit.text_submitted.emit(line_edit.text)


func _on_win_timer_timeout() -> void:
	clear_all()
