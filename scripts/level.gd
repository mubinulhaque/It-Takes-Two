@tool
extends XRToolsSceneBase

## Number of robots that have reached the finish line
var finished_robots := 0


func robot_finished(body: Node3D) -> void:
	print(body.name + " finished!")
	finished_robots += 1
	
	if finished_robots >= 2:
		# If both robots have reached the finish line
		print("Woohoo!")


func robot_unfinished(body: Node3D) -> void:
	print(body.name + " unfinished!")
	finished_robots -= 1
