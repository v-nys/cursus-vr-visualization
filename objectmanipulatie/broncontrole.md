---
title: "Broncontrole objectmanipulatie"
section_title: "Objectmanipulatie"
section_url: /objectmanipulatie/
---
# Broncontrole objectmanipulatie

Controle uitgevoerd op **11 november 2026**, voor **Godot 4.5 en Godot XR Tools 4.5.1**. Dit is de versieafspraak van de cursus, geen claim dat dit de nieuwste release is.

## Video's en bronproject

De vier [video's van Bastiaan Olij](links.md) zijn geïdentificeerd via de videometadata, beschrijvingen en hoofdstuklijsten. De video's zijn niet integraal afgespeeld en er is geen volledig transcript gebruikt. De tijdsaanduidingen verwijzen naar de gepubliceerde hoofdstukken. De uitleg steunt daarnaast op de daadwerkelijk gelezen broncode van het [oorspronkelijke tutorialproject](https://github.com/BastiaanOlij/godot-xr-tools-tutorial/tree/master): `project.godot`, de hoofdscène en `objects/part4/Gun.gd`, `Magazine.gd`, `Bullet.gd`, `Casing.gd` en de relevante scèneverbindingen.

Dat project gebruikt Godot 3 (`Spatial`, `ARVRCamera`, oude exportsyntax en `instance()`). De les maakt een expliciete omzetting naar Godot 4 en gebruikt eigen primitieve lesobjecten. Modellen, geluiden en de volledige animatiereeks uit het tutorialproject zijn niet overgenomen. Het toestandsmodel volgt het principe uit Part 4; de voorbeeldcode vereenvoudigt effecten en afhandeling bewust.

## Officiële bronnen

De documentatiepagina's zijn gelezen via hun Markdownbron op de officiële `docs`-branch:

- [Installatie](https://godotvr.github.io/godot-xr-tools/docs/installation/) en [setup](https://godotvr.github.io/godot-xr-tools/docs/setup/).
- [Pickup](https://godotvr.github.io/godot-xr-tools/docs/pickup/), [pickable](https://godotvr.github.io/godot-xr-tools/docs/pickable/), [grab points](https://godotvr.github.io/godot-xr-tools/docs/grab_point/) en [snapzones](https://godotvr.github.io/godot-xr-tools/docs/snap_zone/).
- [Physicslagen](https://godotvr.github.io/godot-xr-tools/docs/physics_layers/).

Waar documentatietekst ouder is of niet precies bij de gekozen release past, is de [broncode van tag 4.5.1](https://github.com/GodotVR/godot-xr-tools/tree/4.5.1) gebruikt: `function_pickup.gd`, `pickable.gd`, `snap_zone.gd`, de grijppuntscripts, beide highlightscripts en bijbehorende scènes. Ook `plugin.cfg`, de compatibiliteitstabel en de licentie zijn gecontroleerd. XR Tools 4.5.x vereist Godot 4.4 of nieuwer. De ontwikkelbranch meldde een andere versie en is niet de API-basis van deze les.

Officiële Godot 4.5-bronnen: [RigidBody3D](https://docs.godotengine.org/en/4.5/classes/class_rigidbody3d.html), [Area3D](https://docs.godotengine.org/en/4.5/classes/class_area3d.html), [Node3D](https://docs.godotengine.org/en/4.5/classes/class_node3d.html), [PackedScene](https://docs.godotengine.org/en/4.5/classes/class_packedscene.html) en [cross-language scripting](https://docs.godotengine.org/en/4.5/tutorials/scripting/cross_language_scripting.html). De onderliggende officiële XML-/RST-bronnen zijn geraadpleegd voor physics, transforms, instantiëren en de C#/GDScript-grens. Aanvullende links staan op de conceptpagina's.

## Belangrijke controles en keuzes

- `grip` is in de huidige pickupbron een analoge as; `trigger_click` de standaard actieknop. Bestaande action maps moeten die acties daadwerkelijk binden.
- `action_pressed(pickable)` heeft één argument. Snapzone `has_picked_up(what)` heeft één argument; `has_dropped` geen.
- Zowel de rootactie als de controllergerichte grijppuntactie kan worden aangeroepen. Dubbele spelhandlers zijn vermeden.
- Picked-up laag 17 en snapzonemasker 3 + 17 passen bij de bibliotheek. Filters op groepen vervangen geen physicsdetectie.
- C# behoudt het GDScript-addon op de root en gebruikt compositie, `Connect`, `Call` en `Get`. Er wordt geen fictieve C#-basisklasse geïntroduceerd.
- Grijppunten zijn directe kinderen; de les onderscheidt hand- en snapaansluiting.
- De kamer, magazijnvoorraad en eenmalige slededrempel zijn afzonderlijke verantwoordelijkheden.
- De projectielrichting is expliciet -Z; de slede gebruikt lokale +Z. Dit verschilt van de modelassen van het oude tutorialproject.
- Twee eigen SVG's ondersteunen de nieuwe concepten; screenshots zijn met bron en licentie lokaal opgenomen.

De sitebuild en interne verwijzingen worden apart gecontroleerd. De voorbeelden zijn **niet gecompileerd, niet in Godot uitgevoerd en niet met XR-hardware getest**. De testtabel in de les is een uit te voeren studentenchecklist, geen verslag van geslaagde hardwaretests. De code vormt geen compleet importeerbaar Godot-project.

## Uitgevoerde bestands- en sitecontroles

De volledige Jekyll-site is lokaal gebouwd met zowel leeg `baseurl` als `/cursus-vr-visualization`: **60 HTML-pagina's, 1.039 lokale verwijzingen, geen ontbrekende doelen of ankers**. De controle verifieert ook dat uitgesloten werkbestanden buiten de site blijven. De vier PNG-bestanden hebben geldige PNG-headers; de zeven concept-SVG's zijn als XML gecontroleerd op titel en beschrijving. Markdown-codeblokken zijn gesloten. De JavaScriptbron doorstaat `node --check`.

De Mermaid-module kon vanuit deze omgeving niet van jsDelivr worden opgehaald (HTTP 403). Mermaid-rendering en browserweergave zijn daarom niet gecontroleerd. De site biedt diagrambroncode als terugval; de twee nieuwe SVG-schema's staan lokaal. De GitHub Actions-workflow is voorbereid, maar niet op GitHub uitgevoerd; er is niets gepubliceerd.
