extends Node

var current_state : Node = null

var state_map = {}

var is_active = false

export(NodePath) var start_state

func _ready():
	
	set_physics_process(false)
	
	for child in get_children():
		state_map[child.name] = child
		pass
		
	initiate()

func initiate():
	current_state = get_node(start_state)
	current_state.enter()
	set_active(true)
	pass
	
func set_active(value: bool):
	is_active = value
	set_physics_process(value)
	
	if value == false:
		current_state = null
	pass

func _physics_process(delta):
	current_state.update(delta)

func _input(event):
	current_state.handle_input(event)
	
func change_state(next_state : String):
	
	if current_state != null:
		current_state.exit()
	
	current_state = state_map[next_state]
	current_state.enter()
	pass
