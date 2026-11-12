---
title: "Inverse transformaties"
section_title: "Concepten"
section_url: /concepten/
---
# Inverse transformaties

Een inverse maakt een omzetting ongedaan. Als een transform een lokaal punt naar de wereld brengt, brengt haar inverse het wereldpunt terug naar die lokale ruimte.

## De oorsprong ook ongedaan maken

Voor een punt geldt:

```text
wereldpunt = B × lokaal_punt + oorsprong
lokaal_punt = inverse(B) × (wereldpunt - oorsprong)
```

We trekken dus eerst de verplaatsing af en draaien of schalen daarna terug. Alleen de inverse basis gebruiken op een wereldpunt is niet genoeg: je vergeet dan de oorsprong.

```gdscript
var local_point := global_transform.affine_inverse() * world_point
var local_movement := global_basis.inverse() * world_movement
```

```csharp
Vector3 localPoint = GlobalTransform.AffineInverse() * worldPoint;
Vector3 localMovement = GlobalBasis.Inverse() * worldMovement;
```

`to_local(world_point)` is meestal duidelijker voor de eerste regel. De tweede regel is juist voor een verplaatsing, omdat die geen oorsprong heeft.

## Welke inverse?

| Methode | Wat maakt ze ongedaan? | Voorwaarde |
| --- | --- | --- |
| `Basis.inverse()` | De lineaire omzetting van de basis. | De basis moet inverteerbaar zijn. |
| `Transform3D.inverse()` | Basis en oorsprong. | De basis moet orthonormaal zijn. |
| `Transform3D.affine_inverse()` | Basis en oorsprong, ook met schaal of scheefstand. | De basis moet inverteerbaar zijn. |

Een schaal van nul drukt een richting helemaal plat. De oorspronkelijke waarde is daarna niet meer terug te halen: er bestaat geen bruikbare inverse. Voor de XR-opstelling vermijden we sowieso schaal op de rig.

## De tegenbeweging van de origin

Stel dat het lichaam door fysieke beweging werkelijk `world_movement` is opgeschoven. De origin moet dat in de tegenovergestelde richting compenseren. Je kan op twee consistente manieren werken:

```gdscript
# Wereldvector bij een wereldpositie:
origin.global_position -= world_movement

# Of: eerst omzetten naar de ruimte van de parent van origin, het lichaam:
origin.position -= global_basis.inverse() * world_movement
```

```csharp
Origin.GlobalPosition -= worldMovement;
// Alternatief in een script op het lichaam:
Origin.Position -= GlobalBasis.Inverse() * worldMovement;
```

Gebruik één alternatief. Beide regels uitvoeren zou de beweging tweemaal compenseren. Een wereldvector rechtstreeks van `origin.position` aftrekken is niet hetzelfde als de eerste regel: `position` staat in parentruimte.

Bij rotaties hangt de juiste plaats van een inverse ook van de vermenigvuldigingsvolgorde af. Omdat `(A × B)⁻¹ = B⁻¹ × A⁻¹`, draai je bij het omkeren van een keten ook de volgorde om. De volledige wereldtransform van de origin bewaren en daarna terugzetten is vaak leesbaarder dan die keten met de hand uit te schrijven. Zie [XR-tegenbeweging](xr-tracking-en-tegenbeweging.md).

Bron: Godot 4.5, [Transform3D](https://docs.godotengine.org/en/4.5/classes/class_transform3d.html) en [Basis](https://docs.godotengine.org/en/4.5/classes/class_basis.html).
