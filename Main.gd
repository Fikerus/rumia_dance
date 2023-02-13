extends Node2D


const ratio = 0.1
var img_size := Vector2(450, 450)

var mouse_to_window: Vector2
var mouse_global: Vector2

var current_window_position: Vector2

var has_pressed_left_mouse := false
var has_pressed_right_mouse := false
var is_borderless := true

func _ready():
	get_tree().get_root().set_transparent_background(true)
	OS.set_borderless_window(is_borderless)
	OS.set_window_always_on_top(true)


func _process(delta):
	
	fix_window_ratio()
	
	if Input.get_action_strength("left_mouse") > 0:
		current_window_position = OS.get_window_position()
		if not has_pressed_left_mouse:
			mouse_to_window = get_real_mouse_position()
		mouse_global = current_window_position + get_real_mouse_position()
		OS.set_window_position(mouse_global - mouse_to_window)
		has_pressed_left_mouse = true
#		print(mouse_to_window)
#		print(get_real_mouse_position())
	else:
		has_pressed_left_mouse = false
	
	if Input.get_action_strength("right_mouse") > 0:
		if not has_pressed_right_mouse:
			is_borderless = not is_borderless
			OS.set_borderless_window(is_borderless)
		has_pressed_right_mouse = true
	else:
		has_pressed_right_mouse = false
	
#	if Input.get_action_strength("wheel_up") > 0:
#		print('something')
#		current_window_size = OS.get_window_size()
#		var increase := current_window_size * ratio
#		var new_size := current_window_size + increase
#		OS.set_window_position(OS.get_window_position() + increase / 2)

func _input(event):
	if event.is_action_pressed("wheel_up"):
		var window_size := OS.get_window_size()
		var new_size := window_size * (1 + ratio)
		OS.set_window_size(new_size)
		fix_window_ratio()
		var increase := OS.get_window_size() - window_size
		OS.set_window_position(OS.get_window_position() - increase / 2)
	
	if event.is_action_pressed("wheel_down"):
		var window_size := OS.get_window_size()
		var new_size := window_size * (1 - ratio)
		OS.set_window_size(new_size)
		fix_window_ratio()
		var decrease := OS.get_window_size() - window_size
		OS.set_window_position(OS.get_window_position() - decrease / 2)

func get_real_mouse_position():
	return get_global_mouse_position() * (OS.get_window_size() / img_size)

func fix_window_ratio():
	var window_size = OS.get_window_size()
	var x = window_size.x
	var y = window_size.y
	if x != y:
		OS.set_window_size(Vector2(min(x, y), min(x, y)))
