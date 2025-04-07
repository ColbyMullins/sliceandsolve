extends Node2D

signal start
@onready var instructions: Control = $Instructions
@onready var title_label: Label = $TitleLabel
@onready var instructions_button: Button = $InstructionsButton
@onready var start_button: Button = $StartButton

func _on_instructions_back_to_title() -> void:
	title_label.show()
	start_button.show()
	instructions_button.show()
	instructions.hide()

func _on_instructions_button_pressed() -> void:
	title_label.hide()
	start_button.hide()
	instructions_button.hide()
	instructions.show()

func _on_start_button_pressed() -> void:
	start.emit()
