---
title: "Begrippen bij VR in Godot"
section_title: "Concepten"
section_url: /concepten/
permalink: /concepten/
---
# Begrippen bij VR in Godot

Deze naslag vertrekt van de oorspronkelijke [bewegingssamenvatting](../beweging/notities.md). Ze werkt zowel de expliciete TODO's en vragen als de begrippen die nodig zijn om de code te begrijpen afzonderlijk uit. De bronnotities blijven behouden; de [bewegingsles](../beweging/cursus.md) toont hoe de begrippen samen een controller vormen.

Elke conceptpagina is gericht op **Godot 4.5**, met bronverwijzingen naar die documentatieversie. Codefragmenten illustreren één berekening of API-afspraak en vervangen geen volledige controller. Waar de hosttaal relevant is, staan GDScript en C# naast elkaar. Shadercode is voor beide talen dezelfde.

## Waar begin je?

Voor de wiskundige kern lees je eerst lokale en globale ruimte, daarna basis, transforms en inverses. Ga vervolgens naar de XR-tegenbeweging en kijkrichting. Voor de vignette zijn meshes, shaderfasen en projectie de voorbereiding. De tabellen hieronder laten je ook rechtstreeks vanuit een vraag naar de juiste pagina springen.

## Pagina's per concept

| Concept | Wat moet je na het lezen kunnen verklaren? |
| --- | --- |
| [Lokale en globale ruimte](lokale-en-globale-ruimte.md) | Waarom dezelfde hoofdpositie verschillende coördinaten heeft. |
| [Vectoren en projecties](vectoren-en-projecties.md) | Waarom `project()` niet automatisch naar lokale ruimte omzet. |
| [Basis en assen](basis-en-assen.md) | Wat `.basis.z` betekent en waarom camera-vooruit meestal -Z is. |
| [Transforms en samenstelling](transforms-en-samenstelling.md) | Wat een transform bevat en waarom de vermenigvuldigingsvolgorde telt. |
| [Inverse transformaties](inverse-transformaties.md) | Wanneer je een volledige inverse of alleen een inverse basis nodig hebt. |
| [XR-tracking en tegenbeweging](xr-tracking-en-tegenbeweging.md) | Waarom fysieke beweging een lokale origincorrectie vraagt. |
| [Yaw, pitch en roll](yaw-pitch-roll.md) | Het verschil tussen een rechtopstaand lichaam en een rechte camerahorizon. |
| [looking_at](looking-at.md) | Het verschil tussen een doelpunt, richting en de optie `use_model_front`. |
| [Beweging en physics](beweging-en-physics.md) | Wereldverplaatsing versus wereldsnelheid en de rol van `delta`. |
| [Scenelevenscyclus en tools](scenelevenscyclus-en-tools.md) | Wanneer nodes beschikbaar zijn en waarom setters en tools extra zorg vragen. |
| [Packed arrays](packed-arrays.md) | Wat `PackedStringArray` en de packed mesharrays voorstellen. |
| [Gedeelde resources en Local to Scene](resources-en-local-to-scene.md) | Waarom een gewijzigd materiaal of collider meerdere spelers kan beïnvloeden. |
| [OpenXR-actions](openxr-actions.md) | Acties, handpaden, bindings en hardwareprofielen uit elkaar houden. |
| [Interpolatie en delta](interpolatie-en-delta.md) | Het verschil tussen lerp, slerp en een tijdsafhankelijke smoothingfactor. |
| [Radialen en snap turning](radialen-en-snap-turning.md) | Hoeken, accumulatie en het juiste draaipunt combineren. |
| [Procedurele meshes](procedurele-meshes.md) | Vertices, indices, ringsegmenten en `ARRAY_MAX` uit elkaar houden. |
| [Shaderfasen, uniforms en varyings](shaderfasen-uniforms-varyings.md) | Welke waarden waar vandaan komen en hoe ze tussen fasen bewegen. |
| [Projectie en perspectiefdeling](projectie-en-perspectiefdeling.md) | Waarom clipposities W hebben en oogprojecties kunnen verschillen. |
| [Reverse Z](reverse-z.md) | Waarom de fullscreen-Z-waarde versiegevoelig is. |
| [Renderinstellingen en culling](renderinstellingen-en-culling.md) | Render modes, zichtselectie, depthtest en tekenvolgorde onderscheiden. |
| [Fade en vignette](fade-en-vignette.md) | Afstand normaliseren, alpha begrenzen en de factor `sqrt(2)` verklaren. |
| [Physicsqueries en RIDs](physicsqueries-en-rids.md) | Een hoofdpad testen zonder de fysieke camera te blokkeren. |
| [Hoogtekalibratie en sessies](hoogtekalibratie-en-sessies.md) | Waarom een zichtbare sessie nog geen geschikt kalibratiemoment is. |
| [Capsules en bukken](capsules-en-bukken.md) | Colliderhoogte, midden en hoofdhoogte consistent aanpassen. |
| [Vloerondersteuning en PID](vloerondersteuning-en-pid.md) | De ontbrekende trapaanpak en haar feedbacklus begrijpen. |

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

De overige pagina's behandelen de noodzakelijke achtergrond bij die vragen: lifecycle, exports, actions, interpolatie, snap turning en de overdracht van shadergegevens. De twee diagramvormen hebben verschillende taken: lokale SVG-bestanden tonen geometrie; Mermaid-diagrammen tonen relaties en uitvoervolgordes.

De technische controle en grenzen van de voorbeelden staan in [broncontrole.md](broncontrole.md). De zelfgemaakte SVG-diagrammen zijn beschreven in [diagrammen/README.md](diagrammen/README.md).

## Objectmanipulatie

De volgende acht pagina's vullen de oorspronkelijke 25 bewegingsconcepten aan. Ze horen bij [objectmanipulatie](../objectmanipulatie/cursus.md) en gebruiken XR Tools 4.5.1.

| Concept | Wat verklaart het? |
| --- | --- |
| [Vasthouden en physics](vasthouden-en-physics.md) | Wie de pose bestuurt tijdens grijpen, aansluiten en loslaten. |
| [Lagen, maskers en groepen](lagen-maskers-en-groepen.md) | Het verschil tussen fysische detectie en inhoudelijke filters. |
| [Grijppunten en uitlijning](grijppunten-en-uitlijning.md) | Hoe een lokale aansluiting de pose van het voorwerp bepaalt. |
| [Signalen en scriptcompositie](signalen-en-scriptcompositie.md) | Hoe C# en GDScript samenwerken zonder het addon-script te vervangen. |
| [Toestanden en voorraad](toestanden-en-voorraad.md) | Waarom magazijnteller en kamerstatus afzonderlijke gegevens zijn. |
| [Eén as, begrenzing en drempels](een-as-en-drempels.md) | Hoe je beweging begrenst en één gebeurtenis per bediening maakt. |
| [Instanties en levensduur](instanties-en-levensduur.md) | Waar een projectiel hoort en wanneer het weer verdwijnt. |
| [Animatiegebeurtenissen en spelgedrag](animatiegebeurtenissen.md) | Hoe presentatie en speltoestand op één moment samenwerken. |
