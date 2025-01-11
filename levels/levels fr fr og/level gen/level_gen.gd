extends Node2D

#globals
@export var player:PackedScene
@export var plan:Array[Dictionary] = [{
	"type":"start room",
	"start":Vector2(0, 0),
	"end":Vector2(0,-2),
	"rect":Rect2(0,-2,1,3),
	"direction":"north"
}]

var rng = RandomNumberGenerator.new()


func _ready() -> void:
	call_deferred_thread_group("trigger_gen")


func line_gen(parent:Dictionary, length_range:Vector2, cont:Dictionary = {}):
	var lengths
	if cont:
		lengths = cont["lengths"]
		parent = cont["parent"]
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
					directions = [parent["next_direction"]]
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
		parent = cont["parent"]
		sizes_x = cont["sizes_x"]
		sizes_y = cont["sizes_y"]
	else:
		sizes_x = Array(range(size_rand[0], size_rand[1]+1))
		if parent["direction"] == "west":
			sizes_x = sizes_x.map(func(element): return -element)
		
		sizes_y = Array(range(size_rand[0], size_rand[1]+1))
		if parent["direction"] == "north":
			sizes_y = sizes_y.map(func(element): return -element)
		
		sizes_x.shuffle()
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
					start = Vector2(parent["end"][0]-offset, parent["end"][1])
				else:
					start = Vector2(parent["end"][0], parent["end"][1]-offset)
					
				var end = start+size
				
				var exit_sides:Array
				if cont:
					exit_sides = cont["exit_sides"]
				else:
					match parent["direction"]:
						"north":
							exit_sides = ["north", "east", "west"]
						"south":
							exit_sides = ["south", "east", "west"]
						"east":
							exit_sides = ["north", "south", "east"]
						"west":
							exit_sides = ["north", "south", "west"]
					exit_sides.shuffle()
				
				for side_idx in exit_sides.size():
					if cont and side_idx < cont["side_idx"]+1: continue
					
					var side = exit_sides[side_idx]
					var continue_sides = true
					var exit_offsets:Array
					match side:
						"north", "south":
							exit_offsets = range(0, size.x+1)
						"east", "west":
							exit_offsets = range(0, size.y+1)
					exit_offsets.shuffle()
					
					for exit_offset_idx in exit_offsets.size():
						if cont and exit_offset_idx < cont["exit_offset_idx"]+1: continue
						
						var exit_offset = exit_offsets[exit_offset_idx]
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
							"exit_sides":exit_sides,
							"side_idx": side_idx,
							"exit_offsets":exit_offsets,
							"exit_offset_idx":exit_offset_idx,
							"direction":null,
							"next_direction":side
						}
						
						var reorded_room = reorder_shape(room.duplicate())
						room["rect"] = Rect2(reorded_room["start"], reorded_room["end"]-reorded_room["start"])
						
						match side:
							"north", "south":
								room["end"] += Vector2(-exit_offset, 0)
							"east", "west":
								room["end"] += Vector2(0, -exit_offset)
						
						if detect_collisions(room, plan):
							#Leave the side loop becuase it doesn't effect collitions.
							#It only effects the connection to the next hall
							continue_sides = false
							break
						else:
							return room
					
					if not continue_sides:
						#Leave the side loop becuase it doesn't effect collitions.
						#It only effects the connection to the next hall
						break
	return false


func exit_gen(parent:Dictionary):
	var exit = {
		"type":"exit",
		"parent":parent,
		"start":parent["end"],
		"end":parent["end"]-Vector2(0, 2),
		"direction":null
	}
	var reordered_exit = reorder_shape(exit.duplicate())
	exit["rect"] = Rect2(reordered_exit["start"], reordered_exit["end"]-reordered_exit["start"])
	
	if not detect_collisions(exit, plan):
		return exit
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
		if tries > 100:
			push_error("couldn't gen main hall")
			print("couldn't gen main hall")
			break
		
		if counter < len(plan)-1:
			print(instructions[counter+1] + " gen faild. current instuctions: ", instructions[counter], " ", counter, instructions)
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
					if counter < 4:
						for object in plan:
							print(object["type"], " ", object["direction"], object["start"], object["end"], object["rect"])
						"pause here"
					
					counter -= 1
			"room":
				#counter += 1
				#continue
				var new_room
				if counter < len(plan)-1:
					new_room = room_gen(plan[-2], room_size, plan.pop_back())
				else:
					new_room = room_gen(plan[-1], room_size)
				
				if new_room:
					plan.append(new_room)
					counter += 1
				else:
					counter -= 1
			"exit":
				if (plan[-1]["type"] == "line" and plan[-1]["direction"] == "south" and plan[-2]["type"] != "room"):
					instructions.insert(instructions.size()-1, "hall")
					total_shapes += 1
					print("added hall to exit")
					continue
				
				var new_exit = exit_gen(plan[-1])
				if new_exit:
					plan.append(new_exit)
					counter += 1
				else:
					counter -= 1
			_:
				push_error("this shouldn't be possible:", instructions[counter])
	
	print(instructions)
	print("Took " + str(tries) + " tries")


func trigger_gen():
	var starting_time = Time.get_ticks_usec()
	gen_main_hall(Vector2(1,2), Vector2(2, 3), Vector2(2,3), Vector2(4,5))

	print("------------------")
	for object in plan:
		if object["type"] == "room":
			print(object["type"], " ", object["direction"], object["start"], object["end"], object["rect"], object["offsets"][object["offset_idx"]], " ", object["offsets"])
		else:
			print(object["type"], " ", object["direction"], object["start"], object["end"], object["rect"])
	print(len(plan))
	$TileMapLayer.place_ground(plan)
	print("done in ", Time.get_ticks_usec()-starting_time, " microseconds")
	call_deferred("summon_player")


func summon_player():
	add_child(player.instantiate())
