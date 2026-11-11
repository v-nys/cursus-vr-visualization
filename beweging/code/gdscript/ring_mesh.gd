@tool
extends MeshInstance3D

func _ready() -> void:
    var steps := 32
    var vertices := PackedVector3Array()
    var indices := PackedInt32Array()
    vertices.resize(2 * steps)
    indices.resize(6 * steps)
    for i in range(steps):
        var angle := TAU * i / steps
        var direction := Vector3(cos(angle), sin(angle), 0.0)
        vertices[i] = direction
        vertices[i + steps] = direction * 2.0
        var next := (i + 1) % steps
        var offset := 6 * i
        indices[offset] = steps + i
        indices[offset + 1] = steps + next
        indices[offset + 2] = next
        indices[offset + 3] = steps + i
        indices[offset + 4] = next
        indices[offset + 5] = i
    var arrays := []
    arrays.resize(Mesh.ARRAY_MAX)
    arrays[Mesh.ARRAY_VERTEX] = vertices
    arrays[Mesh.ARRAY_INDEX] = indices
    var ring := ArrayMesh.new()
    ring.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
    mesh = ring
