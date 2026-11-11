---
title: "Een richting opbouwen met looking_at"
section_title: "Concepten"
section_url: /concepten/
---
# Een richting opbouwen met looking_at

De notitie `looking_at(forward, Vector3.UP, true)` roept drie vragen op: gaat het om een richting of een punt, welke as wijst vooruit en waarom wordt de oorsprong eerst nul gemaakt?

## Basis of volledige transform?

`Basis.looking_at(direction, up)` krijgt een **richting** vanuit nul. Ze geeft een nieuwe oriëntatie terug, zonder positie. Standaard wijst de negatieve Z-as in die richting.

`Transform3D.looking_at(target, up)` krijgt daarentegen een **doelpunt** in de ruimte waarin de transform staat. Haar eigen oorsprong is het vertrekpunt. De geretourneerde transform behoudt die oorsprong en krijgt een nieuwe oriëntatie. De methode retourneert een waarde; ze wijzigt niet stilzwijgend je bestaande variabele.

`Node3D.look_at(target, up)` past de node zelf aan en verwacht een doelpunt in wereldruimte. Deze drie varianten lijken op elkaar, maar hun invoer betekent niet hetzelfde.

## Waarom eerst origin nul zetten?

Stel dat een transform op `(5, 0, 0)` staat en je een richtingsvector `(0, 0, 1)` als target meegeeft. De volledige transform kijkt dan van `(5, 0, 0)` naar het punt `(0, 0, 1)`. De berekende richting is `(-5, 0, 1)`, niet `(0, 0, 1)`.

De video zet de oorsprong eerst op nul. Dan is het doelpunt numeriek gelijk aan de gewenste richting vanuit nul. Met de basisvariant vermijden we die omweg.

## Positieve of negatieve Z?

De parameter `use_model_front = true` laat de **positieve Z-as** naar het doel wijzen. Dat is nuttig voor modellen die met +Z als voorkant gemaakt zijn. Bij de gebruikelijke Godot-camera hoort -Z bij vooruit.

Deze twee afspraken kunnen dezelfde uiteindelijke oriëntatie beschrijven:

```gdscript
var a := Basis.looking_at(-camera.global_basis.z, Vector3.UP)
var b := Basis.looking_at(camera.global_basis.z, Vector3.UP, true)
```

```csharp
Basis a = Basis.LookingAt(-Camera.GlobalBasis.Z, Vector3.Up);
Basis b = Basis.LookingAt(Camera.GlobalBasis.Z, Vector3.Up, true);
```

Kies het teken en de parameter samen. Alleen `true` toevoegen zonder de richtingsafspraak na te kijken kan je oriëntatie omkeren.

Een nulrichting of een richting parallel aan `up` geeft onvoldoende informatie voor een stabiele basis. Controleer zulke gevallen. `up` is een referentierichting voor het opbouwen van een loodrecht assenstelsel, geen garantie dat elke lokale as exact met die vector samenvalt.

Wil je alleen het lichaam laten draaien, ken dan alleen de nieuwe basis toe. Een volledige nieuwe transform met oorsprong nul zou ook de positie vervangen.

Bron: Godot 4.5, [Basis.looking_at](https://docs.godotengine.org/en/4.5/classes/class_basis.html#class-basis-method-looking-at), [Transform3D.looking_at](https://docs.godotengine.org/en/4.5/classes/class_transform3d.html#class-transform3d-method-looking-at) en [Node3D.look_at](https://docs.godotengine.org/en/4.5/classes/class_node3d.html#class-node3d-method-look-at).
