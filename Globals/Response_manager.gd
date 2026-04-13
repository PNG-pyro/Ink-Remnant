extends Node

var visited_responses: Dictionary = {}

func mark_visited(id: String) -> void:
	visited_responses[id] = true

func is_visited(id: String) -> bool:
	return visited_responses.has(id)
