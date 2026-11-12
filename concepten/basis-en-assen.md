---
title: "Een basis: de assen van een node"
section_title: "Concepten"
section_url: /concepten/
---
# Een basis: de assen van een node

In de bewegingscode gebruiken we vaak `.basis.z`. Dat is geen apart opgeslagen kijkhoek. Het is één van de drie assen waarmee een node zijn eigen ruimte beschrijft.

## Drie kolommen met betekenis

Een `Basis` bevat de X-, Y- en Z-as. Je kan die zien als de drie kolommen van een 3 × 3-matrix. Elke kolom vertelt waar één lokale eenheidsas in de bovenliggende ruimte terechtkomt.

```text
basis × (x, y, z) = basis.x × x + basis.y × y + basis.z × z
```

Een basis bevat geen positie. Die staat in `Transform3D.origin`. Rotatie, schaal en eventueel scheefstand kunnen wel in de basis zitten. De lengte van een basisas is dus niet altijd 1.

Godot gebruikt voor een gewone 3D-camera deze afspraak:

| As | Betekenis bij een ongedraaide camera |
| --- | --- |
| +X | Rechts |
| +Y | Omhoog |
| -Z | Vooruit |
| +Z | Achteruit |

Daarom halen we de wereldkijkrichting op met een minteken:

```gdscript
var forward: Vector3 = -camera.global_basis.z
```

```csharp
Vector3 forward = -Camera.GlobalBasis.Z;
```

`basis` beschrijft de assen tegenover de parent, `global_basis` tegenover de wereld. Vergelijk dit met de twee stelsels in [lokale en globale ruimte](lokale-en-globale-ruimte.md).

## Alleen de oriëntatie veranderen

Pas je alleen de basis aan, dan blijft de positie gelijk. Vervang je de volledige transform, dan vervang je ook haar oorsprong. Een rotatie-transform met oorsprong nul op een lichaam toepassen als volledige nieuwe transform kan dat lichaam dus naar nul verplaatsen.

Een volledige transform *vermenigvuldigen* met een rotatie kan eveneens de positie rond een draaipunt laten bewegen. Dat is iets anders dan alleen een nieuwe oriëntatie toekennen. Zie [samenstelling](transforms-en-samenstelling.md) en [rotatie rond een draaipunt](radialen-en-snap-turning.md).

Voor onze VR-controller houden we de schaal op `(1, 1, 1)`. De assen staan dan loodrecht op elkaar en hebben lengte 1. Zo'n basis heet orthonormaal. Dat vereenvoudigt omrekeningen en rotatie-interpolatie. `orthonormalized()` herstelt die eigenschappen, maar verwijdert ook schaal; het is dus geen neutrale reparatie voor elke matrix.

## De getekende assen uit de video

De gekleurde assen zijn een visualisatiehulpmiddel, niet de basis zelf. De scène staat in de tutorial als [`objects/axis.tscn`](https://raw.githubusercontent.com/BastiaanOlij/godot4_tutorial/first_person_controller_part3/objects/axis.tscn). Je hoeft die scène niet te importeren om basisberekeningen te gebruiken. De [spectatoropstelling](../debugging/cursus.md) maakt zulke hulpmiddelen zichtbaar voor de ontwikkelaar.

Bron: Godot 4.5, [Basis](https://docs.godotengine.org/en/4.5/classes/class_basis.html) en [Matrices and transforms](https://docs.godotengine.org/en/4.5/tutorials/math/matrices_and_transforms.html).
