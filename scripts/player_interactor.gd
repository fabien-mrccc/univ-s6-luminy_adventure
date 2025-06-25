extends Interactor

## Exported reference to the player character controlling this interactor.
@export var player: CharacterBody3D

## Cache of the currently closest interactable object.
var cached_closest: Interactable

## Called when the node enters the scene tree.
func _ready() -> void:
	controller = player

## Called every physics frame to update interactable focus.
func _physics_process(_delta: float) -> void:
	var new_closest: Interactable = get_closest_interactable()

	if new_closest != cached_closest:
		if is_instance_valid(cached_closest):
			unfocus(cached_closest)
		if new_closest:
			focus(new_closest)

		cached_closest = new_closest

## Handles input events, particularly the "interact" action.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if is_instance_valid(cached_closest):
			interact(cached_closest)

## Called when an interactable area is exited.
func _on_area_exited(area: Interactable) -> void:
	if cached_closest == area:
		unfocus(area)
