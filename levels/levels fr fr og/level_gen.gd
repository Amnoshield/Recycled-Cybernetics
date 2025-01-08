extends Node2D

#globals
@export var plan:Array[Dictionary] = [{
	"type":"start room",
	"start":Vector2(0, 0),
	"end":Vector2(0,-1),
	"rect":Rect2(0,-1,1,2),
	"direction":"north"
}]

var rng = RandomNumberGenerator.new()


func _ready() -> void:
	call_deferred_thread_group("trigger_gen")


func line_gen(parent:Dictionary, length_range:Vector2, cont:Dictionary = {}):
	var lengths
	if cont:
		lengths = cont["lengths"]
	else:
		lengths = Array(range(length_range[0], length_range[1]+1))
		lengths.shuffle()

	var start = parent["end"]

	for length_idx in lengths.size():
		if cont and length_idx < cont["length_idx"]+1: continue
		
		var length = lengths[length_idx]
		var directions
		if cont:
			directions = cont["directions"]
		else:
			match parent["direction"]:
				"north", "south":
					directions = ["east", "west"]
				"east", "west":
					directions = ["north", "south"]
				_:
					directions = ["north", "south", "east", "west"]
					push_error("Direction not found: "+str(parent["direction"]))
			directions.shuffle()

		for direction_idx in directions.size():
			if cont and direction_idx < cont["direction_idx"]+1: continue
			
			var direction = directions[direction_idx]
			var end
			match direction:
				"north":
					end = Vector2(start[0], start[1]-length)
				"south":
					end = Vector2(start[0], start[1]+length)
				"east":
					end = Vector2(start[0]+length, start[1])
				"west":
					end = Vector2(start[0]-length, start[1])
				_:
					push_error("Idk what happened: "+str(direction))
			
			var line = {
				"type":"line",
				"start":start,
				"end":end,
				"direction":direction,
				"length":length,
				"parent":parent,
				"lengths":lengths,
				"length_idx":length_idx,
				"directions":directions,
				"direction_idx":direction_idx
			}
			if line["start"] != parent["end"]:
				push_error("HELLP")
			
			var reorded_line = reorder_shape(line.duplicate())
			line["rect"] = Rect2(reorded_line["start"], reorded_line["end"]-reorded_line["start"])

			if not detect_collisions(line, plan):
				return line
	return false


func room_gen(parent:Dictionary, size_rand:Vector2, cont:Dictionary = {}):
	var sizes_x
	var sizes_y
	if cont:
		sizes_x = cont["sizes_x"]
		sizes_y = cont["sizes_y"]
	else:
		sizes_x = Array(range(size_rand[0], size_rand[1]+1))
		sizes_x.shuffle()
		sizes_y = Array(range(size_rand[0], size_rand[1]+1))
		sizes_y.shuffle()

	for x_idx in sizes_x.size():
		if cont and x_idx < cont["x_idx"]+1: continue
		
		var x = sizes_x[x_idx]
		for y_idx in sizes_y.size():
			if cont and y_idx < cont["y_idx"]+1: continue
			
			var y = sizes_y[y_idx]
			var size = Vector2(x, y)
			var offset_xy
			if parent["direction"] in ["north", "south"]:
				offset_xy = x
			else:
				offset_xy = y

			var offsets
			if cont:
				offsets = cont["offsets"]
			else:
				offsets = Array(range(0, offset_xy+1))
				offsets.shuffle()

			for offset_idx in offsets:
				if cont and offset_idx < cont["offset_idx"]+1: continue
				
				var offset = offsets[offset_idx]
				var start
				if parent["direction"] in ["north", "south"]:
					start = Vector2(parent["start"][0]-offset, parent["start"][1])
				else:
					start = Vector2(parent["start"][0]-offset, parent["start"][1])
				var end = start+size
				
				var room = {
					"type":"room",
					"parent":parent,
					"start":start,
					"end":end,
					"sizes_x":sizes_x,
					"x_idx":x_idx,
					"sizes_y":sizes_y,
					"y_idx":y_idx,
					"offsets":offsets,
					"offset_idx":offset_idx,
					"direction":null
				}
				
				var reorded_room = reorder_shape(room.duplicate())
				room["rect"] = Rect2(reorded_room["start"], reorded_room["end"]-reorded_room["start"])
				
				if not detect_collisions(room, plan):
					return room
	return false


func detect_collisions(shape:Dictionary, other_shapes:Array[Dictionary]):
	var shape_rect:Rect2 = shape["rect"]
	for shape2 in other_shapes:
		if shape["parent"] == shape2: continue
		
		if shape_rect.intersects(shape2["rect"], true):
			return true
	return false


func reorder_shape(shape:Dictionary):
	if shape["start"].x > shape["end"].x:
		var temp =  shape["start"].x
		shape["start"].x = shape["end"].x
		shape["end"].x = temp
	
	if shape["start"].y > shape["end"].y:
		var temp =  shape["start"].y
		shape["start"].y = shape["end"].y
		shape["end"].y = temp

	shape["end"][0] += 1
	shape["end"][1] += 1

	return shape


func gen_main_hall(num_rooms=Vector2(2,4), room_size=Vector2(3,5), num_halls=Vector2(1,2), hall_length=Vector2(2,4)):
	var instructions = []
	for room in range(rng.randi_range(num_rooms[0], num_rooms[1])):
		for x in range(rng.randi_range(num_halls[0], num_halls[1])):
			instructions.append("hall")
		instructions.append("room")
	
	instructions.append("hall")
	instructions.append("exit")

	print(instructions)

	var tries = 0
	var total_shapes = len(instructions)
	var counter = 0
	while counter < total_shapes:
		for shape in plan:
			if shape["type"] == "line":
				if shape["start"] !=  shape["parent"]["end"]:
					print("cought you")
		
		var last_shape = plan[-1]
		if last_shape["type"] == "line" and plan[-2]["type"] == "line" and last_shape["start"] != plan[-2]["end"]:
			print("fuck")
		elif last_shape["type"] == "line":
			"idk man"
		
		if counter < len(plan)-1:
			tries += 1
		match instructions[counter]:
			"hall":
				var new_line
				if counter < len(plan)-1: new_line = line_gen(plan[-2], hall_length, plan.pop_back())
				else: new_line = line_gen(plan[-1], hall_length)
				
				if new_line:
					plan.append(new_line)
					counter += 1
				else:
					counter -= 1
			"room":
				#counter += 1
				#continue
				var new_room
				if counter < len(plan)-1: new_room = room_gen(plan[-2], room_size, plan.pop_back())
				else: new_room = room_gen(plan[-1], room_size)
				
				if new_room:
					plan.append(new_room)
					counter += 1
				else:
					counter -= 1
			"exit":
				#if (plan[-1]["type"] == "line" and plan[-1]["direction"] == "south"):
					#instructions.insert(instructions.size()-1, "hall")
					#total_shapes += 1
					#print("added hall to exit")
					#continue
				
				counter += 1
				continue
			_:
				push_error("this shouldn't be possible:", instructions[counter])
	
	print(instructions)
	print("Took " + str(tries) + " tries")


func trigger_gen():
	#var rect1 = Rect2(0, -1, 0, 2)
	#var rect2 = Rect2(0, -1, 1, 4)
	#print(rect1)
	#print(rect2)
	#print(rect1.intersects(rect2, true))

	gen_main_hall(Vector2(1,1), Vector2(3, 5), Vector2(4,6), Vector2(3,5))

	print("------------------")
	for object in plan:
		print(object["type"], " ", object["direction"], object["start"], object["end"], object["rect"])
		#if object["type"] == "line":
			#if object["start"] !=  object["parent"]["end"]:
				#print("cought you")
			#else:
				#print(object["start"], object["parent"]["end"])
	#print(plan[-1])
	print(len(plan))
	print("done")
