## Spawns static cylindrical colliders based on instances in a MultiMesh.
extends Node3D

## Path to the MultiMeshInstance3D containing tree instances.
@export_node_path("MultiMeshInstance3D")
var tree_multimesh_path: NodePath

## Radius of the cylinder colliders.
@export var tree_radius: float = 2

## Height of the cylinder colliders.
@export var tree_height: float = 3.0

## Called when the node enters the scene tree.
## Instantiates StaticBody3D nodes with cylinder-shaped CollisionShape3D
## for each instance in the MultiMesh, up to the specified limit if necessary.
func _ready():
	var tree_mmi = get_node(tree_multimesh_path)
	var mm = tree_mmi.multimesh
	var count = mm.instance_count

	for i in count:
		var transform = mm.get_instance_transform(i)

		var body = StaticBody3D.new()
		body.transform = transform

		var shape = CollisionShape3D.new()
		var cylinder = CylinderShape3D.new()
		cylinder.radius = tree_radius
		cylinder.height = tree_height
		shape.shape = cylinder

		var shape_transform = Transform3D.IDENTITY
		shape_transform.origin.y = tree_height / 2.0
		shape.transform = shape_transform

		body.add_child(shape)
		add_child(body)
