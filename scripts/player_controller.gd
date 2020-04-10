extends KinematicBody2D

var direction : Vector2 = Vector2()
var velocity : Vector2 = Vector2()

var inventory : Dictionary = {}
var current_inventory_space : int = 0
var max_inventory_space : int = 9

var steal_target = null

var knock_back_dir : Vector2

var pocketing_range = 20.0

var can_steal = false
var is_stealing = false

var scent_collider : Array = []

var health : int
var max_health : int = 3

func _ready():
	init_inventory()
	health = max_health
	pass

func _physics_process(delta):
	update()
	
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
			is_stealing = true
		elif is_stealing == true:
			cancel_stealing()
	pass
	
func cancel_stealing():
	event_handler.emit_signal("pick_pocket_ended", steal_target, self)
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
	health -= damage
	#play damage aniamtion
	#call to ui health -1 one
	knock_back(enemy, force)
	
	if health <= 0:
		on_death()
	pass
	
func on_death():
	print("you are dead")
	event_handler.emit_signal("player_died")
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
	if scent_collider.size() >= 6:
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
