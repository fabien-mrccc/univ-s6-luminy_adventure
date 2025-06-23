extends Interactor

## Exported reference to the player character controlling this interactor.
@export var player: CharacterBody3D

## Cache of the currently closest interactable object.
var cached_closest: Interactable

## Called when the node enters the scene tree.
func _ready() -> void:
	# Assign the player as the controller for this interactor.
	controller = player

## Called every physics frame to update interactable focus.
func _physics_process(_delta: float) -> void:
	# Find the closest interactable object.
	var new_closest: Interactable = get_closest_interactable()

	# If the closest interactable has changed...
	if new_closest != cached_closest:
		# Unfocus the previous interactable if valid.
		if is_instance_valid(cached_closest):
			unfocus(cached_closest)
		# Focus the new interactable if it exists.
		if new_closest:
			focus(new_closest)

		# Update the cached closest interactable.
		cached_closest = new_closest

## Handles input events, particularly the "interact" action.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		# If there is a valid closest interactable, interact with it.
		if is_instance_valid(cached_closest):
			interact(cached_closest)

## Called when an interactable area is exited.
func _on_area_exited(area: Interactable) -> void:
	# If the exited area was the cached closest, unfocus it.
	if cached_closest == area:
		unfocus(area)
