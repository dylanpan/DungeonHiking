extends Node

var _world: World

func _ready():
	_world = World.new()
	_world.initSystem()

func _exit_tree():
	_world.destroySystem()

func _process(delta):
	_world.updateSystem(delta)
