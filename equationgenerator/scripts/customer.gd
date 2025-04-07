extends Node2D

# var timer = get_children()[get_children().rfind(Timer)]
var pepperoniEquation = null
var mushroomEquation = null
var onionEquation = null
var animationNum = 1
const ORDER = preload("res://order.tscn")
@onready var timer: Timer = $Timer
@onready var animation_timer: Timer = $AnimationTimer
@onready var sprite: Sprite2D = $Sprite2D
@onready var speech_bubble: Sprite2D = $SpeechBubble

signal animationOver(customer: Node2D)

signal timeout(node: Node2D)
var order
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pepperoniEquation = generateEquation()
	mushroomEquation = generateEquation()
	onionEquation = generateEquation()
	order = ORDER.instantiate()
	order.pepLabel = pepperoniEquation
	order.mushLabel = mushroomEquation
	order.onionLabel = onionEquation
	add_child(order)
	#order.hide()
	order.mushroom_container.hide()
	order.onion_container.hide()
	order.time_remaining_label.hide()
	order.time_remaining_bar.hide()
	order.pizzaButton.hide()
	timer.wait_time = randi_range(60, 90)
	order.totalTime = timer.wait_time
	timer.start()
	animation_timer.start()
	order.set_position(Vector2(550, 270), false)

func _process(delta: float) -> void:
	if (order != null):
		if (order.is_visible()):
			if (order.time_remaining_label != null):
				order.time_remaining_label.text = str(int(timer.time_left)) + "s"
	
	# may have to make it dynamically select timer in here instead of outside w get_children
	
###########################################################
#  Planning
# 
# Put order scene into main scene
# 
# make customer button spawn a new customer
# 	should put the customer's order on the orderrack
# 
# button on ordershould go to pizza screen with that order
# 	if it is right, instantly serves, player gets money
# 	if it is wrong, just goes back to order screen and maybe lose some money
# 
# if customer times out, order goes away
# 	what to do if it goes away during pizza screen
#   		leave pizza screen and say time up, order is right/wrong 
# 			regular timeup behavior with right and wrong just makeit so that it goes back toorder screen
# 
# just realized i dont have any customer sprites but oh well
# 


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

func generateOperator() -> String:
	var rand = randi_range(1, 3)
	if (rand == 1):
		return "+"
	if (rand == 2):
		return "-"
	if (rand == 3):
		return "*"
	return "/"

func _on_timer_timeout() -> void:
	timeout.emit(self)

func showOrder() -> void:
	print("doing something")
	order.show()
	
	order.pepperoni_container.show()
	order.mushroom_container.show()
	order.onion_container.show()
	#order.time_remaining_label.show()
	order.time_remaining_bar.show()
	order.pizzaButton.show()

func _on_animation_timer_timeout() -> void:
	if (animationNum == 0):
		order.pepperoni_container.show()
		order.mushroom_container.hide()
		order.onion_container.hide()
		order.time_remaining_label.hide()
		order.time_remaining_bar.hide()
		order.pizzaButton.hide()
	elif (animationNum == 1):
		order.pepperoni_container.hide()
		order.mushroom_container.show()
		order.onion_container.hide()
		order.time_remaining_label.hide()
		order.time_remaining_bar.hide()
		order.pizzaButton.hide()
	elif (animationNum == 2):
		order.pepperoni_container.hide()
		order.mushroom_container.hide()
		order.onion_container.show()
		order.time_remaining_label.hide()
		order.time_remaining_bar.hide()
		order.pizzaButton.hide()
	else:
		order.hide()
	if (animationNum > 2):
		animationOver.emit(self)
		animation_timer.wait_time = 100
		animation_timer.stop()
		animation_timer.one_shot = true
	animationNum += 1
		
