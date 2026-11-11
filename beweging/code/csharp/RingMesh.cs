using Godot;

[Tool]
public partial class RingMesh : MeshInstance3D
{
    public override void _Ready()
    {
        const int steps = 32;
        var vertices = new Vector3[2 * steps];
        var indices = new int[6 * steps];
        for (int i = 0; i < steps; i++)
        {
            float angle = Mathf.Tau * i / steps;
            var direction = new Vector3(Mathf.Cos(angle), Mathf.Sin(angle), 0);
            vertices[i] = direction;
            vertices[i + steps] = direction * 2.0f;
            int next = (i + 1) % steps;
            int offset = 6 * i;
            indices[offset] = steps + i;
            indices[offset + 1] = steps + next;
            indices[offset + 2] = next;
            indices[offset + 3] = steps + i;
            indices[offset + 4] = next;
            indices[offset + 5] = i;
        }
        var arrays = new Godot.Collections.Array();
        arrays.Resize((int)Godot.Mesh.ArrayType.Max);
        arrays[(int)Godot.Mesh.ArrayType.Vertex] = vertices;
        arrays[(int)Godot.Mesh.ArrayType.Index] = indices;
        var ring = new ArrayMesh();
        ring.AddSurfaceFromArrays(Godot.Mesh.PrimitiveType.Triangles, arrays);
        Mesh = ring;
    }
}
