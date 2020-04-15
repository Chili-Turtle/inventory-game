extends Navigation2D

#onready var dummy = $npc
#
#onready var start = $start
#onready var end = $end
#
#var draw_test = Node2D.new()
#
#var direction : Vector2
#var speed : float = 30.0
#
#var velocity : Vector2
#
#var index = 0
#
#func _ready():
##	$draw_node.poolvector = get_simple_path(start.position, end.position)
#

#	pass
#
#func _physics_process(delta):
#
#	if get_simple_path(start.position, end.position)[index%3].distance_to(dummy.position) <= 1.0:
#		index += 1
#
#	direction = get_simple_path(start.position, end.position)[index%3] - dummy.position
#	direction = direction.normalized()
#
#	velocity = direction * speed
#
#	velocity = dummy.move_and_slide(velocity)
#
#	pass
#
#func walk_to_path():
#	pass
