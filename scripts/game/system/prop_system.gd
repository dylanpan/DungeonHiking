class_name Prop_System
extends I_System

var list := []

func init():
	list = []

func destroy():
	list.clear()

func update(delta):
	list = []
