## Represents an interactor — usually the player — capable of interacting with nearby interactable objects.
extends Area3D

## Allows this script to be used as a named class in the editor.
class_name Interactor

## Reference to the controller (typically the player character).
var controller: Node3D

## Triggers interaction with a valid interactable object.
## @param interactable: Interactable - The object to interact with.
func interact(interactable: Interactable) -> void:
	if is_instance_valid(interactable):
		# Emits the 'interacted' signal from the interactable, passing this interactor as the caller.
		interactable.interacted.emit(self)

## Notifies an interactable that it's being focused (e.g., player is looking at it).
## @param interactable: Interactable - The object to highlight as focused.
func focus(interactable: Interactable) -> void:
	interactable.focused.emit(self)

## Notifies an interactable that it is no longer being focused.
## @param interactable: Interactable - The object to remove focus from.
func unfocus(interactable: Interactable) -> void:
	interactable.unfocused.emit(self)

## Returns the closest interactable object among all overlapping areas.
## @return Interactable - The nearest interactable, or null if none are found.
func get_closest_interactable() -> Interactable:
	var list: Array[Area3D] = get_overlapping_areas()
	var distance: float
	var closest_distance: float = INF
	var closest: Interactable = null

	for interactable in list:
		distance = interactable.global_position.distance_to(global_position)

		# Update the closest interactable if it's nearer than the current one.
		if distance < closest_distance:
			closest = interactable as Interactable
			closest_distance = distance

	return closest
