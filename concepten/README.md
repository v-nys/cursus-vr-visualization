---
title: "Begrippen bij VR in Godot"
section_title: "Concepten"
section_url: /concepten/
permalink: /concepten/
---
# Begrippen bij VR in Godot

Deze naslag legt de begrippen uit die je nodig hebt om de VR-code te begrijpen. De [bewegingsles](../beweging/cursus.md) toont hoe je deze begrippen combineert in een controller.

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
| [Vloerondersteuning en PID](vloerondersteuning-en-pid.md) | Vloerondersteuning bij trappen en de bijbehorende feedbacklus begrijpen. |

De lokale SVG-diagrammen tonen geometrie; de Mermaid-diagrammen tonen relaties en uitvoervolgordes. De herkomst van de zelfgemaakte SVG-diagrammen staat in [diagrammen/README.md](diagrammen/README.md).

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
