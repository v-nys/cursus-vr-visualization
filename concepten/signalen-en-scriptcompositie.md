---
title: "Signalen en scriptcompositie"
section_title: "Concepten"
section_url: /concepten/
---
# Signalen en scriptcompositie

Voor **Godot 4.5 en XR Tools 4.5.1**. Dit begrip ondersteunt de [les objectmanipulatie](../objectmanipulatie/cursus.md).

De pickable-root draagt al een GDScript uit XR Tools. Als je dat script vervangt door eigen gedrag, verwijder je mogelijk precies de functionaliteit waarmee het voorwerp grijpbaar werd. Compositie vermijdt dat probleem: de root doet het grijpen, een kindnode doet het specifieke spelgedrag.

## Een signaal als afspraak

`action_pressed(pickable)` meldt een actie en levert het voorwerp mee. `has_picked_up(what)` op een snapzone levert het opgenomen voorwerp. `has_dropped` op die zone levert **geen** argument. De handler moet bij die signatuur passen. Het `dropped(pickable)`-signaal op het pickable zelf heeft wel een argument.

```gdscript
# Script op een kindnode van de pickable.
func _ready() -> void:
    var item := get_parent() as XRToolsPickable
    item.action_pressed.connect(_on_action)

func _on_action(_item: Node3D) -> void:
    print("Bedienen")
```

```csharp
// Methoden binnen een partial class die Node uitbreidt.
public override void _Ready()
{
    GetParent().Connect("action_pressed", Callable.From<Node3D>(OnAction));
}

private void OnAction(Node3D item) => GD.Print("Bedienen");
```

## Over de taalgrens

Een GDScriptklasse wordt niet vanzelf een C#-type. C# kan de node als `Node3D` of `Node` bewaren en via de Godot-objectinterface samenwerken:

```csharp
bool held = item.Call("is_picked_up").AsBool();
var occupant = zone.Get("picked_up_object").AsGodotObject() as Node;
```

De strings verwijzen naar de exacte addon-namen. Gebruik hier dus niet automatisch `IsPickedUp` of `PickedUpObject`. Gewone ingebouwde Godot-C#-API's gebruiken wel hun C#-namen, zoals `GlobalPosition`.

In 4.5.1 kan een triggeractie zowel de rootactie als een actie op het actieve grijppunt bereiken. Laat een enkele spelhandeling maar via één van die routes uitvoeren. Compositie beschermt niet tegen dubbel aangesloten signalen.

**Denkvraag:** waarom compileert `class Lamp : XRToolsPickable` niet als een gewone C#-overerving van deze addon, terwijl een child `Lamp : Node` wel kan samenwerken met de root?

Bronnen: [cross-language scripting](https://docs.godotengine.org/en/4.5/tutorials/scripting/cross_language_scripting.html), [signalen in C#](https://docs.godotengine.org/en/4.5/tutorials/scripting/c_sharp/c_sharp_signals.html), [pickablebroncode 4.5.1](https://github.com/GodotVR/godot-xr-tools/blob/4.5.1/addons/godot-xr-tools/objects/pickable.gd).
