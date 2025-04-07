extends Control

@export var pepLabel: String
@export var mushLabel: String
@export var onionLabel: String
@onready var pepperoni_label: Label = $MarginContainer/VBoxContainer/PepperoniContainer/PepperoniLabel
@onready var pepperoni_sprite: TextureRect = $MarginContainer/VBoxContainer/PepperoniContainer/PepperoniSprite
@onready var mushroom_label: Label = $MarginContainer/VBoxContainer/MushroomContainer/MushroomLabel
@onready var mushroom_sprite: TextureRect = $MarginContainer/VBoxContainer/MushroomContainer/MushroomSprite
@onready var onion_label: Label = $MarginContainer/VBoxContainer/OnionContainer/OnionLabel
@onready var onion_sprite: TextureRect = $MarginContainer/VBoxContainer/OnionContainer/OnionSprite
@onready var time_remaining_label: Label = $MarginContainer/VBoxContainer/TimeRemainingLabel
@onready var pepperoni_container: HBoxContainer = $MarginContainer/VBoxContainer/PepperoniContainer
@onready var mushroom_container: HBoxContainer = $MarginContainer/VBoxContainer/MushroomContainer
@onready var onion_container: HBoxContainer = $MarginContainer/VBoxContainer/OnionContainer
@onready var pizzaButton: Button = $MarginContainer/VBoxContainer/OrderButton
@onready var order_button: Button = $MarginContainer/VBoxContainer/OrderButton
@onready var time_remaining_bar: ProgressBar = $MarginContainer/VBoxContainer/TimeRemainingBar

var pepNum
var mushNum
var onionNum
var totalTime
var currentTime
@onready var order_rack: HBoxContainer = get_node("/root/Main/OrderScene/Control/OrderRack")
@onready var manager: Node = get_node("/root/Main/Node2D/Manager")


signal orderSignal(pep, mush, onion)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pepperoni_label.text = pepLabel
	mushroom_label.text = mushLabel
	onion_label.text = onionLabel
	orderSignal.connect(manager.managerSetEquations)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	currentTime = float(time_remaining_label.text.split("s")[0])
	time_remaining_bar.value = currentTime / totalTime * 100

func _on_order_button_pressed() -> void:
	orderSignal.emit(pepLabel, mushLabel, onionLabel)
	queue_free()
