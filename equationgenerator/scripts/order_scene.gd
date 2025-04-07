extends Node2D

const CUSTOMER = preload("res://customer.tscn")
var customers = []
var score = 0
signal forceClosePizza
@onready var customer_container: Node = $CustomerContainer
@onready var score_label: Label = $Control/ScoreLabel
@onready var order_rack: HBoxContainer = %OrderRack
@onready var customer_button: Button = $Control/CustomerButton
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# this shouild probably handle the button press and spawn a customer
# and be in charge of displaying the orders and moving to the pizza screen
# should disable everything in the pizza screen when in order screen
# add order to orderrack as child, butto should send a signal with arguments for
# the equations that brings it to pizza
# modify pizza scene so it just has the solutions always and doesnt have to 
# reset equations
# i am probably missing a lot but idk thats all i got for rn


func _on_customer_button_pressed() -> void:
	var new_customer = CUSTOMER.instantiate()
	#new_customer.hide()
	new_customer.connect("timeout", handleCustomerTimeout)
	new_customer.connect("animationOver", handleAnimationOver)
	customer_container.add_child(new_customer)
	#order_rack.add_child(new_customer.order)
	customer_button.disabled = true
	for child in order_rack.get_children():
		child.order_button.disabled = true
	
func handleCustomerTimeout(customer: Node2D) -> void:
	if (customer.order != null):
		order_rack.remove_child(customer.order)
	customer.queue_free()
	#show()
	#forceClosePizza.emit()
	updateScore(-1)

func handleAnimationOver(customer: Node2D) -> void:
	print("test")
	customer.showOrder()
	var order = customer.order
	customer.remove_child(order)
	order_rack.add_child(order)
	print(customer.order)
	customer.show()
	customer.sprite.hide()
	customer.speech_bubble.hide()
	customer.showOrder()
	customer.timer.start()
	customer_button.disabled = false
	for child in order_rack.get_children():
		child.order_button.disabled = false

func _on_node_2d_pizza_mode() -> void:
	hide()

func updateScore(num: int) -> void:
	score += num
	score_label.text = "Score: " + str(score)

func _on_node_2d_leave_pizza_mode(win: bool) -> void:
	show()
	if (win):
		updateScore(1)
