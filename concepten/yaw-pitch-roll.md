---
title: "Yaw, pitch en roll"
section_title: "Concepten"
section_url: /concepten/
---
# Yaw, pitch en roll

"Tilt negeren" is te vaag om rotatiecode te begrijpen. In de notities moeten we twee verschillende bewerkingen uit elkaar houden: het lichaam rechtop laten staan en een camerabeeld met een rechte horizon maken.

## Drie soorten draaien

Bij een gewone camera onderscheiden we:

| Naam | Wat doe je met je hoofd? | As bij een neutrale camera |
| --- | --- | --- |
| Yaw | Naar links of rechts kijken. | Y |
| Pitch | Omhoog of omlaag kijken. | X |
| Roll | Je oor naar je schouder kantelen. | Z |

Die namen beschrijven de beweging. Bij samengestelde rotaties draait een lokale as zelf mee. Eulerhoekvolgorde doet er dus toe; je kan niet elke rotatie betrouwbaar behandelen als drie onafhankelijke wereldhoekjes.

## Voor het lichaam: alleen yaw

Het virtuele lichaam moet niet vooroverkantelen wanneer je naar de grond kijkt. Haal de voorwaartse richting uit de camera en zet de Y-component op nul:

```gdscript
var forward := -camera.global_basis.z
forward.y = 0.0
if forward.length_squared() > 0.000001:
    var body_basis := Basis.looking_at(forward.normalized(), Vector3.UP)
```

```csharp
Vector3 forward = -Camera.GlobalBasis.Z;
forward.Y = 0;
if (forward.LengthSquared() > 0.000001f)
{
    Basis bodyBasis = Basis.LookingAt(forward.Normalized(), Vector3.Up);
}
```

Het afvlakken verwijdert de verticale kijkcomponent. `looking_at` met omhoog als referentie bouwt vervolgens een rechtopstaande basis. We kopiëren dus niet de pitch en roll van het hoofd naar het lichaam.

## Voor de spectatorcamera: pitch behouden

Een toeschouwer moet wel kunnen zien dat de speler naar de vloer kijkt. Daarom gebruikt de [gestabiliseerde camera](../debugging/cursus.md) de oorspronkelijke voorwaartse richting, zonder Y op nul te zetten. `looking_at` maakt bij die richting een nieuwe opwaartse oriëntatie. Daarmee verdwijnt vooral roll, terwijl pitch behouden blijft.

Dat verklaart ook waarom een commentaar "remove pitch" bij zo'n berekening misleidend kan zijn. Kijk naar de vectorbewerking, niet alleen naar de naam erboven.

Wanneer je bijna recht omhoog of omlaag kijkt, wordt de horizontale richting bijna nul. Alleen yaw afleiden wordt dan onbetrouwbaar. Een geldige keuze voor het lichaam is de vorige horizontale oriëntatie te bewaren.

**Probeer zelf:** kantel je hoofd zijwaarts, kijk omlaag en draai daarna alleen horizontaal. Welke van die drie bewegingen moet de lichaamscapsule volgen?

Verder: [looking_at](looking-at.md), [vectorprojecties](vectoren-en-projecties.md).

Bron: Godot 4.5, [Node3D](https://docs.godotengine.org/en/4.5/classes/class_node3d.html) en [Basis](https://docs.godotengine.org/en/4.5/classes/class_basis.html).
