extends Control

signal backToTitle

func _on_back_button_pressed() -> void:
	backToTitle.emit()
