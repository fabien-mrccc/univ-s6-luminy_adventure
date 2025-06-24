## Spawns static cylindrical colliders for each instance in all MultiMeshInstance3D nodes
## that are direct children of this node. Attach this script to a parent node
## containing one or more MultiMeshInstance3D nodes.
extends Node3D

## Radius of the generated cylinder colliders.
@export var tree_radius: float = 1.0

## Height of the generated cylinder colliders.
@export var tree_height: float = 3.0

## Called when the node enters the scene tree.
## Iterates through all MultiMeshInstance3D children and spawns a StaticBody3D
## with a cylindrical CollisionShape3D for each instance in their MultiMesh.
func _ready():
	for child in get_children():
		if child is MultiMeshInstance3D:
			var mm = child.multimesh
			var count = mm.instance_count

			for i in range(count):
				var transform = mm.get_instance_transform(i)

				var body = StaticBody3D.new()
				body.transform = transform

				var shape = CollisionShape3D.new()
				var cylinder = CylinderShape3D.new()
				cylinder.radius = tree_radius
				cylinder.height = tree_height
				shape.shape = cylinder

				# Offset the collider so it sits correctly on the ground.
				var shape_transform = Transform3D.IDENTITY
				shape_transform.origin.y = tree_height / 2.0
				shape.transform = shape_transform

				body.add_child(shape)
				add_child(body)
