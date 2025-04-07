extends Node

var toppings_objects = {"pepperoni": [], "mushroom": [], "onion": []}
var toppings = {"pepperoni": 0, "mushroom": 0, "onion": 0}
@onready var line_edit: LineEdit = $"../LineEdit"
@onready var toppings_container: Node = $"../Toppings"
#var cleared = false
signal lossSound
@onready var solution_label: Label = $"../SolutionLabel"
@onready var pizza: Area2D = $"../Pizza"
var pizza_init_pos: Vector2 = Vector2(0,0);
var score: int = 0
@onready var score_label: Label = $"../ScoreLabel"
@onready var timer_ui: Control = $"../TimerUI"
@onready var pep_num_label: Label = $"../PepNumLabel"
@onready var mush_num_label: Label = $"../MushNumLabel"
@onready var onion_num_label: Label = $"../OnionNumLabel"

func _ready() -> void:
	pizza_init_pos = pizza.global_position

func managerSetEquations(pep, mush, onion):
	get_parent().setSpecificEquations(pep, mush, onion)

func slidePizzaOut() -> void:
	pizza.slide(pizza_init_pos + Vector2(800, 0), 1)
	for child in toppings_container.get_children():
		var tween = get_tree().create_tween()
		tween.tween_property(child, "position", child.global_position + Vector2(800, 0), 1)
	
func slidePizzaIn() -> void: 
	pizza.global_position = pizza_init_pos + Vector2(0, -2000)
	pizza.slide(pizza_init_pos, 1)

func updateScore() -> void:
	score += 1
	score_label.text = "Score: " + str(score)
	timer_ui.startMain()

func _on_pizza_topping_placed(topping: Sprite2D) -> void:
	toppings_objects[topping.topping_type].append(topping)
	toppings[topping.topping_type] += 1
	line_edit.text = str(toppings[topping.topping_type])
	updateToppingNumLabels()
	#print(toppings_objects)

func updateToppingNumLabels() -> void:
	pep_num_label.text = str(toppings["pepperoni"])
	mush_num_label.text = str(toppings["mushroom"])
	onion_num_label.text = str(toppings["onion"])

func clear_all() -> void:
	#print("cleared all")
	toppings_objects = {"pepperoni": [], "mushroom": [], "onion": []}
	toppings = {"pepperoni": 0, "mushroom": 0, "onion": 0}
	for child in toppings_container.get_children():
		child.queue_free()
	line_edit.text = "0"
	toppings = {"pepperoni": 0, "mushroom": 0, "onion": 0}
	updateToppingNumLabels()

func _on_pizza_topping_left(topping: Sprite2D) -> void:
	toppings[topping.topping_type] -= 1
	toppings_objects[topping.topping_type].remove_at(toppings_objects[topping.topping_type].rfind(topping))
	line_edit.text = str(toppings[topping.topping_type])
	if int(line_edit.text) < 0:
		line_edit.text = "0"
		toppings = {"pepperoni": 0, "mushroom": 0, "onion": 0}
	updateToppingNumLabels()
	#print(toppings_objects)


func _on_spawner_spawn_topping(topping: Sprite2D) -> void:
	toppings_container.add_child(topping)

func _on_submit_button_pressed() -> void:
	line_edit.text_submitted.emit(line_edit.text)

func _on_time_up() -> void:
	var isWin = get_parent()._on_Line_Edit_text_entered("")
	if (not isWin):
		pass
		#lossSound.emit()
	slidePizzaOut()
	timer_ui.startDelay()

func _on_win_timer_timeout() -> void:
	clear_all()
	slidePizzaIn()
	#clear_all()

func _on_timer_ui_delay_timeout() -> void:
	get_parent().resetEquations()
	_on_win_timer_timeout()
	timer_ui.startMain()
