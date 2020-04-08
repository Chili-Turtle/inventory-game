extends TextureButton

signal slot_pressed(self_reference)

var slot_index
var item = null;

func _ready():
	pass

func _on_item_container_pressed():
	emit_signal("slot_pressed", self)
	pass
