---
title: "Broncontrole en verificatie"
section_title: "Concepten"
section_url: /concepten/
---
# Broncontrole en verificatie

Referentie: Godot **4.5**. Geraadpleegd op **11 november 2026**.

## Vertrekpunt en dekking

De oorspronkelijke [samenvatting](../beweging/notities.md) is opnieuw volledig gelezen. De selectie omvat zowel expliciete TODO's, vraagtekens en vermoedens als begrippen die een goed begrip van de getoonde berekeningen vereisen. De oorspronkelijke notities zijn niet aangepast.

De 25 conceptpagina's zijn bereikbaar via [README.md](README.md). De tabel onderaan dit interne verslag koppelt de oorspronkelijke vragen aan de betreffende pagina's. Een concept hoeft niet voor elk genoemd API-symbool een nieuwe pagina te krijgen: bijvoorbeeld shaders delen één uitleg over uniforms en varyings, en de meshpagina behandelt vertices, indices en kanaalarrays samen.

Het ontbrekende trapgedeelte is beschreven op basis van de eerder geraadpleegde broncode van videodeel 3. De PID-regelaar is daarbij expliciet een tutorialaanpak, geen ingebouwde Godot-functie. De assenscène is opnieuw rechtstreeks opgehaald via de bronlink.

## Documentatiecontrole

De tijdelijke documentatiekopieën staan buiten versiebeheer. Voor deze pagina's zijn de volgende officiële bronnen uit de `4.5`-branch gelezen, of opnieuw gebruikt uit de voorafgaande cursusuitwerking:

| Onderwerp | Documentatie |
| --- | --- |
| Vectoren, projectie en transformaties | Vector math, Matrices and transforms, Interpolation, Vector3, Basis, Transform3D, Node3D. |
| Nodelevenscyclus, tools en exports | Node, Running code in the editor, GDScript exports, C# global classes. |
| Arrays, meshes en resources | PackedStringArray, Using the ArrayMesh, ArrayMesh, Mesh, Resource, Material. |
| Physics en vormen | CharacterBody3D, PhysicsBody3D, PhysicsDirectSpaceState3D, PhysicsShapeQueryParameters3D, RID, CapsuleShape3D, RayCast3D. |
| XR-invoer en tracking | XR action map, Room scale in XR, XRController3D, OpenXRInterface, XRPose. |
| Shader- en beeldruimte | Shading language, Spatial shaders, Advanced post-processing, XR full screen effects, GeometryInstance3D. |

Elke conceptpagina bevat de bijbehorende directe documentatielinks.

## Belangrijke verduidelijkingen

- Een punt en een verplaatsingsvector vragen niet dezelfde omzetting. Ook projectie op een wereldas maakt een vector niet lokaal.
- De origin houdt bij fysieke tegenbeweging haar wereldtransform, terwijl haar lokale transform verandert.
- `Basis.looking_at`, `Transform3D.looking_at` en `Node3D.look_at` verwachten niet allemaal dezelfde soort invoer. Het effect van `use_model_front` is expliciet gemaakt.
- `Transform3D.inverse` veronderstelt een orthonormale basis; bij algemene inverteerbare schaal is `affine_inverse` de passende transformvariant.
- Roll verwijderen met behoud van de kijkrichting is iets anders dan alleen yaw behouden voor het lichaam.
- Physicsbeweging, physicsqueries en hoofdtracking zijn onderscheiden. Een extra collider is geen automatische blokkering van de runtimepose.
- Reverse Z, de NDC-conventie van de renderer, depthtest en renderprioriteit zijn afzonderlijke begrippen.
- Een shader kan vertices visueel verplaatsen zonder de CPU-bounding box of collider automatisch aan te passen.
- Materiaalresources en shapes kunnen gedeeld zijn. Local to Scene is geen retroactieve scheiding van reeds gebruikte instanties.
- Een gesignaleerde zichtbare XR-sessie is geen bewijs dat de gebruiker in de gewenste houding klaarstaat voor kalibratie.

## Diagrammen en controles

Er zijn **vijf zelfgemaakte SVG-diagrammen** voor geometrie en **zestien Mermaid-diagrammen** voor relaties en uitvoervolgordes. De SVG's hebben elk een titel en beschrijving; hun herkomst staat in [diagrammen/README.md](diagrammen/README.md). Het zijn geen screenshots van een uitgevoerd project.

Uitgevoerde controles:

- lokale bestandsverwijzingen en verwijzingen naar de diagrammen;
- gesloten Markdown-codeblokken en whitespace;
- aanwezigheid van alle 25 conceptpagina's in het overzicht;
- XML-structuur, titels en beschrijvingen van de SVG-bestanden;
- rekenvoorbeelden voor de gedraaide parentruimte, de 3-4-5-vector, de origincompensatie, `sqrt(2)` en de meshgroottes;
- handmatige vergelijking van API-uitleg met de genoemde documentatie.

Godot 4 en de .NET-SDK zijn hier niet geïnstalleerd. De illustratieve codefragmenten zijn daarom niet gecompileerd of in een XR-project uitgevoerd. De Mermaid-diagrammen zijn niet met een Mermaid-renderer gecontroleerd en de SVG's zijn niet in een browser gerenderd; de diagramcontrole bestond uit de bronstructuur en geometrische plaatsing. De tekst legt de relevante relaties ook zonder renderondersteuning uit.

## Aanvulling objectmanipulatie

Acht extra conceptpagina's ondersteunen [objectmanipulatie](../objectmanipulatie/cursus.md), naast de oorspronkelijke 25 bewegingsconcepten. Ze richten zich op Godot 4.5 met XR Tools 4.5.1. De [broncontrole van dat hoofdstuk](../objectmanipulatie/broncontrole.md) beschrijft de geraadpleegde versiebronnen. De aanvulling bevat twee eigen SVG's en drie Mermaid-diagrammen. De code is niet gecompileerd of met XR-hardware getest.

## De open vragen uit de oorspronkelijke notities

| Plaats in de notities | Vraag of twijfel | Uitleg |
| --- | --- | --- |
| Video 1 — setup | Vanwaar komt de assenscène? | [Basis en assen](basis-en-assen.md), met verwijzing naar `objects/axis.tscn`. |
| Video 1 — fysieke beweging | Wat is `PackedStringArray`? | [Packed arrays](packed-arrays.md). |
| Video 1 — fysieke beweging | Wat is een transform, wat is global en waarom vermenigvuldigen? | [Lokale/globale ruimte](lokale-en-globale-ruimte.md) en [transforms](transforms-en-samenstelling.md). |
| Video 1 — fysieke beweging | Maak tekeningen van de omrekening. | [Ruimtediagram](diagrammen/lokale-ruimte.svg), [transformketen](transforms-en-samenstelling.md) en [tegenbeweging](xr-tracking-en-tegenbeweging.md). |
| Video 1 — fysieke beweging | Werkt `move_and_collide` in wereldruimte? | [Beweging en physics](beweging-en-physics.md). |
| Video 1 — fysieke beweging | Waarom `global_basis.inverse()`? Mag het rechtstreeks globaal? | [Inverse transformaties](inverse-transformaties.md). |
| Video 1 — rotatie | Wat is de Z-as van een basis? | [Basis en assen](basis-en-assen.md). |
| Video 1 — rotatie | Wat betekent tilt; wat verdwijnt als Y nul wordt? | [Yaw, pitch en roll](yaw-pitch-roll.md) en [projecties](vectoren-en-projecties.md). |
| Video 1 — rotatie | Waarom oorsprong nul en `looking_at(..., true)`? | [looking_at](looking-at.md). |
| Video 1 — rotatie | Waarom alleen de basis aanpassen? | [Basis en assen](basis-en-assen.md) en [looking_at](looking-at.md). |
| Video 1 — fade | Wat doet W = 1? | [Projectie en perspectiefdeling](projectie-en-perspectiefdeling.md). |
| Video 1 — fade | Wat betekenen de render modes? | [Renderinstellingen en culling](renderinstellingen-en-culling.md). |
| Video 1 en 2 — effecten | Wat doet Local to Scene? | [Gedeelde resources](resources-en-local-to-scene.md). |
| Video 2 — lopen | Staat de geprojecteerde snelheid lokaal of globaal? | [Vectoren en projecties](vectoren-en-projecties.md). |
| Video 2 — ringmesh | Waarom de buitenste array tot `ARRAY_MAX` vergroten? | [Procedurele meshes](procedurele-meshes.md). |
| Video 2 — vignette | Hoe werken projectie en perspectiefdeling voor twee ogen? | [Projectie en perspectiefdeling](projectie-en-perspectiefdeling.md). |
| Video 2 — vignette | Wat is reverse Z? | [Reverse Z](reverse-z.md). |
| Video 2 — vignette | Waarom `unshaded`, depthtest uit en culling uit? | [Renderinstellingen en culling](renderinstellingen-en-culling.md). |
| Video 2 — vignette | Waarom radius maal `sqrt(2)`? | [Fade en vignette](fade-en-vignette.md), met geometrisch diagram. |
| Video 2 — muren | Volstaat een extra hoofd-collision shape? | [Physicsqueries en RIDs](physicsqueries-en-rids.md). |
| Video 2 — muren | Wat is een shapequery en wat is een RID? | [Physicsqueries en RIDs](physicsqueries-en-rids.md). |
| Video 3 — kalibratie | Wanneer bestaat een bruikbare XR-pose? | [Hoogtekalibratie en sessies](hoogtekalibratie-en-sessies.md). |
| Video 3 — bukken | Welke hoofdhoogte of radius gebruiken we? | [Capsules en bukken](capsules-en-bukken.md). |
| Video 3 — trappen | Het hele laatste stuk ontbreekt nog. | [Vloerondersteuning en PID](vloerondersteuning-en-pid.md). |
