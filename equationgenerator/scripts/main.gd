extends Node2D

@onready var node_2d: Node2D = $Node2D
@onready var order_scene: Node2D = $OrderScene
@onready var title_screen: Node2D = $TitleScreen

func _on_title_screen_start() -> void:
	title_screen.hide()
	order_scene.show()
