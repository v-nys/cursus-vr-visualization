---
title: "Instanties en levensduur"
section_title: "Concepten"
section_url: /concepten/
---
# Instanties en levensduur

Voor **Godot 4.5 en XR Tools 4.5.1**. Dit begrip ondersteunt de [les objectmanipulatie](../objectmanipulatie/cursus.md).

Een `PackedScene` is een herbruikbare beschrijving. `instantiate()` maakt er een nieuwe nodeboom van. Die instantie moet daarna nog aan de actieve SceneTree worden toegevoegd.

## Een projectiel hoort bij de wereld

Als je een projectiel kind maakt van het bewegende model, verandert zijn wereldpose mee wanneer de parent beweegt. Voor een vrij object voegen we de instantie daarom aan de wereldscène toe en stellen daarna de globale transform in.

```gdscript
var body := projectile_scene.instantiate() as RigidBody3D
get_tree().current_scene.add_child(body)
body.global_transform = muzzle.global_transform
body.linear_velocity = -muzzle.global_basis.z.normalized() * speed
```

```csharp
var body = ProjectileScene.Instantiate<RigidBody3D>();
GetTree().CurrentScene.AddChild(body);
body.GlobalTransform = Muzzle.GlobalTransform;
body.LinearVelocity = -Muzzle.GlobalBasis.Z.Normalized() * Speed;
```

Deze korte fragmenten veronderstellen een toegewezen scène met de juiste root. De [volledige kamercomponent](../objectmanipulatie/code/index.md) bevat aanvullende controles. `LinearVelocity` is een snelheid per seconde; physics verwerkt de tijdstap. Vermenigvuldig die instelling niet met `delta`.

Omdat `add_child` de node in de boom brengt, kan `_ready()` al lopen vóór de volgende regels de uiteindelijke pose instellen. Laat het projectiel daarom niet in `_ready()` een spoor of botsingsquery op zijn tijdelijke startpositie maken. Als zulke initialisatie nodig is, voeg dan een expliciete initialisatiestap toe nadat de pose gezet is.

## Ook verdwijnen hoort bij het ontwerp

```gdscript
func _ready() -> void:
    get_tree().create_timer(3.0).timeout.connect(queue_free)
```

```csharp
public override void _Ready()
{
    GetTree().CreateTimer(3.0).Timeout += QueueFree;
}
```

`queue_free()` plant verwijdering; je verwijdert geen node midden in een willekeurige callback. Een levensduur begrenst het aantal achterblijvende projectielen, ook als niets wordt geraakt. Na verwijdering kunnen bewaarde referenties ongeldig zijn. Controleer hun geldigheid voordat je ze later gebruikt.

Een startpunt buiten de afzender, geschikte lagen en eventueel continue botsingsdetectie zijn afzonderlijke voorwaarden. Een correcte levensduur voorkomt geen tunneling door een dunne muur.

Bronnen: [PackedScene](https://docs.godotengine.org/en/4.5/classes/class_packedscene.html), [Node](https://docs.godotengine.org/en/4.5/classes/class_node.html), [SceneTreeTimer](https://docs.godotengine.org/en/4.5/classes/class_scenetreetimer.html).
