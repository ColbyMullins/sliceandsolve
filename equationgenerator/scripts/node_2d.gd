extends Node2D

@onready var line_edit: LineEdit = $LineEdit
@onready var solution_label: Label = $SolutionLabel
@onready var pepperoni_label: Label = $Pepperoni
@onready var mushroom_label: Label = $Mushroom
@onready var manager: Node = $Manager
signal solved
@onready var win_timer: Timer = $WinTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	line_edit.text_submitted.connect(_on_Line_Edit_text_entered)
	resetEquations()
	
func resetEquations() -> void:
	setEquation(pepperoni_label)
	setEquation(mushroom_label)

func setEquation(label: Label) -> void:
	label.text = generateEquation()

func validateEquation(equation: String) -> bool:
	var expression = Expression.new()
	expression.parse(equation)
	var result = expression.execute()
	print(result)
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
			print(equation)
	return equation
		

func solveEquation(number: int, label: Label) -> bool:
	var expression = Expression.new()
	expression.parse(label.text)
	var result = expression.execute()
	if (int(result) == number):
		#solution_label.text = "Correct!"
		win_timer.start()
		return true
	else:
		#solution_label.text = "Incorrect, try again!"
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

func _on_Line_Edit_text_entered(new_text: String) -> void:
	if (new_text == "r"):
		resetEquations()
	else:
		if (solveEquation(manager.toppings["mushroom"], mushroom_label) and solveEquation(manager.toppings["pepperoni"], pepperoni_label)):
			solution_label.text = "Correct! Moving to next order..."
		else:
			solution_label.text = "Incorrect, try again."
		

func _on_button_pressed() -> void:
	resetEquations()
	solution_label.text = ""
