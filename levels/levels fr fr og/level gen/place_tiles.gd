extends TileMapLayer


func place_ground(plan:Array[Dictionary]):
	var rect:Rect2
	for object in plan:
		rect = object["rect"]
		var starting_point = rect.position
		var ending_point = rect.end
		
		for x in range(starting_point.x*2, ending_point.x*2):
			for y in range(starting_point.y*2, ending_point.y*2):
				set_cell(Vector2i(x, y), 2, Vector2i(0, 0))
