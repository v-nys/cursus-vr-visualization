using Godot;

public partial class Magazine : Node
{
    [Export(PropertyHint.Range, "0,30,1")] public int Rounds { get; set; } = 3;

    public bool TakeRound()
    {
        if (Rounds <= 0) return false;
        Rounds--;
        return true;
    }
}
