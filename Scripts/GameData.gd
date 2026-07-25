extends Node

var player_image: Image
var original_image: Image
var accuracy_score: float = 0.0
var paintings_queue: Array = []
var accuracy_history: Array[float] = []
var total_paintings: int = 0

func add_score(score: float) -> void:
	accuracy_history.append(score)

func get_average_accuracy() -> float:
	if accuracy_history.size() == 0:
		return 0.0
	var total = 0.0
	for score in accuracy_history:
		total += score
	return total / accuracy_history.size()

func reset_run() -> void:
	accuracy_history.clear()
	paintings_queue.clear()

func is_run_complete() -> bool:
	return accuracy_history.size() >= total_paintings

func setup_paintings_queue(paintings: Array) -> void:
	if paintings_queue.size() == 0:
		paintings_queue = paintings.duplicate()
		paintings_queue.shuffle()

func pop_next_painting() -> String:
	if paintings_queue.is_empty():
		return ""
	return paintings_queue.pop_back()
