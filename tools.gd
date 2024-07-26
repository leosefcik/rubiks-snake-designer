class_name Tools
extends Node


static func damp(smoothing, delta):
	return 1 - exp(-smoothing * delta)
