extends KinematicBody2D

var direction : Vector2 = Vector2()
var velocity : Vector2 = Vector2()

var inventory : Dictionary = {}
var current_inventory_space : int = 0
var max_inventory_space : int = 9

var steal_target = null

var knock_back_dir : Vector2

var pocketing_range = 30.0

var can_steal = false
var is_stealing = false

var sprint_value : float
var sprint_value_max : float = 100.0
var can_sprint : bool = true

var scent_collider : Array = []

var health : int
var max_health : int = 3

var is_dead : bool = false

var damaged_sound = load("res://audio/SFX/Damage.wav")
var open_bag_sound = load("res://audio/SFX/search 8 bit.wav")
var close_bag_sound = load("res://audio/SFX/search 8 bit canceld.wav")

func _ready():
	sprint_value = sprint_value_max
	init_inventory()
	health = max_health
	$pick_pocket_range/CollisionShape2D.shape.radius = pocketing_range
	event_handler.connect("game_loaded", self, "on_game_loaded")
	pass
	
func on_game_loaded():
	event_handler.emit_signal("update_player_hp", health)
	event_handler.emit_signal("update_sprint", sprint_value)
	pass

func _physics_process(delta):
	update()
	
	sprint_value += delta * 100.0
	sprint_value = clamp(sprint_value, 0.0, sprint_value_max)
	event_handler.emit_signal("update_sprint", sprint_value)
	
	if sprint_value >= sprint_value_max:
		can_sprint = true
	
	velocity = direction
	velocity += knock_back_dir
	velocity = move_and_slide(velocity)
	
	knock_back_dir = knock_back_dir.linear_interpolate(Vector2(), delta * 20.0)
	pass

func init_inventory():
	for i in range(0, max_inventory_space + 1):
		inventory[i] = null
	pass

func _on_pick_pocket_range_body_entered(body):
	if body.is_in_group("stealable"):
		can_steal = true
		steal_target = body
	pass
	
func _unhandled_input(event):
	if event.is_action_pressed("interact") and can_steal == true:
		if is_stealing == false:
			event_handler.emit_signal("pick_pocket_started", steal_target, self)
			$AudioStreamPlayer.stream = open_bag_sound
			$AudioStreamPlayer.play()
			MM.apply_filter()
			is_stealing = true
		elif is_stealing == true:
			cancel_stealing()
	pass
	
func cancel_stealing():
	if is_stealing == false:
		return
		
	MM.disable_filter()
	event_handler.emit_signal("pick_pocket_ended", steal_target, self)
	$AudioStreamPlayer.stream = close_bag_sound
	$AudioStreamPlayer.play()
	is_stealing = false
	pass
	
func _on_pick_pocket_range_body_exited(body):
	if body == steal_target:
		cancel_stealing()
		can_steal = false
		steal_target = null
	pass

func add_item(item_name):
	for key in inventory:
		if inventory[key] == null:
			inventory[key] = item_name
			return
	print("inventory is full")
	pass
	
func remove_item(item_name):
	var arr : Array = []
	
	for key in inventory:
		if inventory[key] == item_name:
			inventory.erase(key)
			current_inventory_space -= 1
		pass
	pass

func take_damage(enemy, damage : int, force : float):
	if is_dead == true:
		return
	
	health -= damage
	event_handler.emit_signal("update_player_hp", health)
	$status_animation.play("damaged")
	event_handler.emit_signal("start_camera_shake", 0.5)
	knock_back(enemy, force)
	$AudioStreamPlayer.stream = damaged_sound
	$AudioStreamPlayer.play()
	
	if health == 0:
		on_death()
	pass
	
func on_death():
	event_handler.emit_signal("player_died")
	is_dead = true
	#player death animation
	#restart the level
	#send signal to the level root
	pass
	
func knock_back(enemy, force = 0.0):
	knock_back_dir
	knock_back_dir = position - enemy.position
	knock_back_dir = knock_back_dir.normalized() * force
	pass


func scent_path():
	if scent_collider.size() >= 5:
		if scent_collider[0] != null:
			scent_collider[0].queue_free()
			scent_collider.pop_front()
		pass
	
	var scent = Area2D.new()
	
	scent.add_to_group("scent")
	
	scent.collision_layer = 32
	scent.collision_mask = 32
	
	get_viewport().add_child(scent)
	
	scent_collider.append(scent)
	
	var col = CollisionShape2D.new()
	col.shape = RectangleShape2D.new()
	
	col.shape.extents = Vector2(5.0, 5.0)
	
	scent.add_child(col)
	
	scent.position = position
	pass

func _on_scent_spawner_timeout():
	scent_path()
	pass
