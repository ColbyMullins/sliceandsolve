extends Node2D

@onready var line_edit: LineEdit = $LineEdit
@onready var solution_label: Label = $SolutionLabel
@onready var pepperoni_label: Label = $Pepperoni
@onready var mushroom_label: Label = $Mushroom
@onready var onion_label: Label = $Onion
@onready var manager: Node = $Manager
signal solved
signal winSound
signal pizzaMode
signal leavePizzaMode
@onready var win_timer: Timer = $WinTimer
@onready var pizza: Area2D = $Pizza
const CHECKMARK = preload("res://pics/checkmark.webp")
const RED_X = preload("res://pics/Red_x.svg")
@onready var pepperoni_checkmark: Sprite2D = $Pepperoni/PepperoniCheckmark
@onready var mushroom_checkmark: Sprite2D = $Mushroom/MushroomCheckmark
@onready var onion_checkmark: Sprite2D = $Onion/OnionCheckmark
@onready var pepperoni_sprite: Sprite2D = $PepperoniSprite
@onready var mushroom_sprite: Sprite2D = $MushroomSprite
@onready var onion_sprite: Sprite2D = $OnionSprite



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	line_edit.text_submitted.connect(_on_Line_Edit_text_entered)
	resetEquations()
	resetCheckmarks()

func setSpecificEquations(pepEq, mushEq, onionEq):
	pepperoni_label.text = pepEq
	mushroom_label.text = mushEq
	onion_label.text = onionEq
	pizzaMode.emit()
	setCheckmarks()
	setSprites()
	show()
	

func resetEquations() -> void:
	var numToppings: int = randi_range(1, 3)
	if (numToppings == 3):
		setEquation(pepperoni_label)
		setEquation(mushroom_label)
		setEquation(onion_label)
	elif (numToppings == 2):
		var toppingChoice: int = randi_range(1, 3)
		if (toppingChoice == 1):
			setEquation(pepperoni_label)
			setEquation(mushroom_label)
			onion_label.text = ""
		elif (toppingChoice == 2):
			setEquation(pepperoni_label)
			setEquation(onion_label)
			mushroom_label.text = ""
		else:
			setEquation(mushroom_label)
			setEquation(onion_label)
			pepperoni_label.text = ""
	else:
		var toppingChoice: int = randi_range(1, 3)
		if (toppingChoice == 1):
			setEquation(pepperoni_label)
			mushroom_label.text = ""
			onion_label.text = ""
		elif (toppingChoice == 2):
			pepperoni_label.text = ""
			setEquation(onion_label)
			mushroom_label.text = ""
		else:
			setEquation(mushroom_label)
			onion_label.text = ""
			pepperoni_label.text = ""
	#setCheckmarks()
	resetCheckmarks()
	setSprites()
	
func setSprites() -> void:
	if (pepperoni_label.text == ""):
		pepperoni_sprite.hide()
	else:
		pepperoni_sprite.show()
	if (mushroom_label.text == ""):
		mushroom_sprite.hide()
	else:
		mushroom_sprite.show()
	if (onion_label.text == ""):
		onion_sprite.hide()
	else:
		onion_sprite.show()
		

func setCheckmarks() -> void:
	if (pepperoni_label.text == ""):
		pepperoni_checkmark.texture = null
		#pepperoni_sprite.hide()
	#else:
		#pepperoni_sprite.show()
	if (mushroom_label.text == ""):
		mushroom_checkmark.texture = null
		#mushroom_sprite.hide()
	#else:
		#mushroom_sprite.show()
	if (onion_label.text == ""):
		#onion_sprite.hide()
		onion_checkmark.texture = null
	#else:
		#onion_sprite.show()

func setEquation(label: Label) -> void:
	label.text = generateEquation()

func validateEquation(equation: String) -> bool:
	var expression = Expression.new()
	expression.parse(equation)
	var result = expression.execute()
	#print(result)
	if (not expression.has_execute_failed()):
		if (result <= 0 or typeof(result) != 2 or result > 10):
			return false
	return true

func generateEquation() -> String:
	var parentheses: int = randi_range(0, 2)
	var equation: String = ""
	var length: int = randi_range(1, 3)
	
	for i in length:
		equation += str(randi_range(1, 7)) + generateOperator()
	equation += str(randi_range(1, 7))
	
	while (not validateEquation(equation)):
		equation = ""
		for i in length:
			equation += str(randi_range(1, 9)) + generateOperator()
		equation += str(randi_range(1, 9))
		if (length > 1):
			if (parentheses == 1):
				equation = equation.insert(0, "(")
				equation = equation.insert(4, ")")
			if (parentheses == 2):
				equation = equation.insert(2, "(")
				equation = equation.insert(6, ")")
			#print(equation)
	return equation
		

func solveEquation(number: int, label: Label) -> bool:
	print(label.text == "")
	print(label)
	print(number)
	if (label.text == ""):
		if (number <= 0):
			return true
		else:
			return false
	var expression = Expression.new()
	expression.parse(label.text)
	var result = expression.execute()
	if (int(result) == number):
		#solution_label.text = "Correct!"
		for child in label.get_children():
			child.texture = CHECKMARK
		return true
	else:
		#solution_label.text = "Incorrect, try again!"
		for child in label.get_children():
			child.texture = RED_X
		return false

func generateOperator() -> String:
	var rand = randi_range(1, 3)
	if (rand == 1):
		return "+"
	if (rand == 2):
		return "-"
	if (rand == 3):
		return "*"
	return "/"

func _on_Line_Edit_text_entered(new_text: String) -> bool:
	if (new_text == "r"):
		resetEquations()
		return true
	else:
		var pepBool: bool = solveEquation(manager.toppings["pepperoni"], pepperoni_label)
		var mushBool: bool = solveEquation(manager.toppings["mushroom"], mushroom_label)
		var onionBool: bool = solveEquation(manager.toppings["onion"], onion_label)
		if (pepBool and mushBool and onionBool):
			solution_label.text = "Correct! Moving to next order..."
			#manager.slidePizzaOut()
			manager.clear_all()
			manager.updateScore()
			win_timer.start()
			winSound.emit()
			leavePizzaMode.emit(true)
			hide()
			return true
		else:
			solution_label.text = "Incorrect, try again."
			return false
		

func resetCheckmarks() -> void:
	pepperoni_checkmark.texture = null
	mushroom_checkmark.texture = null
	onion_checkmark.texture = null

func _on_button_pressed() -> void:
	resetCheckmarks()
	resetEquations()
	solution_label.text = ""


func _on_exit_button_pressed() -> void:
	leavePizzaMode.emit(false)
	hide()


func _on_order_scene_force_close_pizza() -> void:
	hide()
