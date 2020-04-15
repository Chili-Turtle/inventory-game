extends TextureRect
class_name Item



var item_name;
var item_icon;
var item_value;
var item_width;

var picked = false

func _ready():
	pass
	
func _init(_item_name, _item_value, _item_width = 60.0):
	item_name = _item_name
	item_value = _item_value
	item_width = _item_width
	
func bumped(body):
	pass
