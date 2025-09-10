@tool
extends XRToolsSceneBase

## Next level to load after the robots both finish
@export_file("*.tscn") var _next_level: String

## Number of robots that have reached the finish line
var finished_robots := 0

@onready var _finish_timer: Timer = $FinishTimer


## When a robot enter their exit
func robot_finished(body: Node3D) -> void:
	print(body.name + " finished!")
	finished_robots += 1
	
	if finished_robots >= 2:
		# If both robots have reached the finish line
		print("Woohoo!")
		_finish_timer.start()


## When a robot leaves their exit
func robot_unfinished(body: Node3D) -> void:
	print(body.name + " unfinished!")
	finished_robots -= 1


## When the next level should be loaded
func _on_finish_timer_timeout() -> void:
	if _next_level:
		# If the next level has been defined
		# Request loading the next level
		super.load_scene(_next_level)
	else:
		# If the next level has not been defined
		push_error("Error: the next level has not been defined!")
