using Godot;

// Optioneel bij voorbeeld 2. Koppel aan dezelfde Sprite2D als het shadermateriaal.
public partial class KleurfilterInstellen : Sprite2D
{
    public override void _Ready()
    {
        if (Material is ShaderMaterial shaderMaterial)
            shaderMaterial.SetShaderParameter("tint", new Color(1.0f, 0.7f, 0.7f, 1.0f));
    }
}
