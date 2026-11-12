---
title: "Packed arrays"
section_title: "Concepten"
section_url: /concepten/
---
# Packed arrays

In de bewegingscode gebruiken we `PackedStringArray`, `PackedVector3Array` en `PackedInt32Array`. Het basisidee is hetzelfde: een compacte reeks waarden van één bepaald type.

## Niet elk lijsttype is hetzelfde

Een gewone `Array` is flexibel en kan verschillende waarden bevatten. Een getypeerde `Array[Vector3]` beperkt welke elementen je erin stopt. Een `PackedVector3Array` is een daarvoor speciaal opgeslagen reeks vectoren. Packed arrays kunnen minder geheugen en overhead vragen voor veel gelijksoortige gegevens.

| GDScript | Inhoud | Voorbeeld |
| --- | --- | --- |
| `PackedStringArray` | Strings | Configuratiewaarschuwingen. |
| `PackedVector3Array` | 3D-vectoren | Vertexposities. |
| `PackedInt32Array` | 32-bit gehele getallen | Meshindices. |

Dat verschillende API's zo'n type verwachten is geen reden om elke eigen lijst meteen packed te maken. Kies een representatie die bij de gegevens en de aangeroepen methode past.

## Toevoegen of vooraf ruimte maken

Voor waarschuwingen is toevoegen overzichtelijk:

```gdscript
var warnings := PackedStringArray()
warnings.append("Voeg een XRCamera3D toe.")
```

```csharp
string[] warnings = { "Voeg een XRCamera3D toe." };
```

De C#-binding gebruikt voor dit packed type een gewone `string[]`. Voor vertices en indices gebruik je in de besproken mesh-API respectievelijk `Vector3[]` en `int[]`.

Ken je het eindformaat vooraf, dan kan je eerst `resize()` gebruiken en de bestaande plaatsen opvullen. Dat doet de ringgenerator met `2 * steps` vertices en `6 * steps` indices. Een element op index 5 schrijven vereist dat de array minstens 6 plaatsen heeft.

Die telling mag je niet verwarren met `Mesh.ARRAY_MAX`. De buitenste gewone array van een mesh bevat **kanalen** zoals vertexposities en indices. Binnen elk kanaal zit een eigen packed array met de werkelijke gegevens. Dat onderscheid staat uitgewerkt bij [procedurele meshes](procedurele-meshes.md).

Packed arrays zijn bovendien geen algemene garantie op onafhankelijke kopieën. Gebruik expliciete duplicatie wanneer je echt afzonderlijke data nodig hebt en controleer de API bij properties die een kopie teruggeven. Voor de cursus is het belangrijkste dat een passend arraytype en de correcte grootte vereist zijn.

Bron: Godot 4.5, [PackedStringArray](https://docs.godotengine.org/en/4.5/classes/class_packedstringarray.html), [PackedVector3Array](https://docs.godotengine.org/en/4.5/classes/class_packedvector3array.html) en [ArrayMesh](https://docs.godotengine.org/en/4.5/classes/class_arraymesh.html).
