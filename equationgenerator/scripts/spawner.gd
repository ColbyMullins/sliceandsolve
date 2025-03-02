extends Sprite2D

@export var drop_area: Area2D
@export var topping_type: String
@export var topping_texture: CompressedTexture2D
@onready var sprite_2d: Sprite2D = $Sprite2D

var topping = preload("res://dragable_sprite.tscn");
signal spawn_topping(topping: Sprite2D)

func _ready() -> void:
	sprite_2d.texture = topping_texture

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			
			if get_rect().has_point(to_local(event.position)):
				var new_topping = topping.instantiate()
				#get_tree().root.add_child(new_topping)
				spawn_topping.emit(new_topping)
				new_topping.global_position = get_global_mouse_position()
				new_topping.is_dragging = true
				new_topping.pizza = self.drop_area
				new_topping.topping_type = self.topping_type
				new_topping.texture = topping_texture
				
				
		else:
			pass
