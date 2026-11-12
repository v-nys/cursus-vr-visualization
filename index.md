---
title: Inleiding
---
# VR ontwikkelen met Godot

In VR bestuur je niet alleen een personage met knoppen. Je kan ook echt rondkijken, een stap zetten of je hand naar een voorwerp uitsteken. Dat maakt interactie direct, maar vraagt ook dat je goed begrijpt hoe tracking, physics en rendering samenwerken.

Deze cursus bouwt dat begrip stap voor stap op. We vertrekken van een werkend Godot XR-project en onderzoeken hoe je beweging en interactie implementeert, hoe je zichtbaar maakt wat er gebeurt en hoe shaders het beeld aanpassen. De voorbeelden richten zich op **Godot 4.5**. Waar een uitbreidingsbibliotheek nodig is, vermeldt het hoofdstuk ook de gebruikte versie.

## De hoofdstukken

| Onderdeel | Wat leer je? |
| --- | --- |
| [2D-shaders](shaders/index.md) | Het verschil tussen vertex- en fragmentcode, met drie eenvoudige voorbeelden. |
| [Debugging](debugging/index.md) | De VR-speler van buitenaf volgen met een spectator view en een gestabiliseerde first-person preview. |
| [Beweging](beweging/index.md) | Fysieke en virtuele beweging combineren, botsingen controleren en comfortinstellingen begrijpen. |
| [Objectmanipulatie](objectmanipulatie/index.md) | Voorwerpen vastnemen, plaatsen en bedienen met Godot XR Tools. |
| [Concepten](concepten/README.md) | Achtergrond bij de wiskunde, physics, XR-invoer en rendering uit de lessen. |

Lees eerst het probleem en voorspel wat er zou moeten gebeuren. Schrijf daarna de code en test met een kleine scène. De conceptpagina's kan je raadplegen zodra een berekening of term nog niet duidelijk is. Voor het bewegingshoofdstuk is het nuttig eerst de spectator view uit de debuggingles klaar te zetten.

De gameplayvoorbeelden staan waar relevant in GDScript en C#. De shadercode blijft voor beide talen dezelfde. Voor C# heb je de .NET-uitgave van Godot nodig.

## AI-gebruik bij het schrijven

**Deze cursus is met generatieve AI opgesteld en uitgewerkt.** AI is gebruikt voor de tekststructuur, uitleg, codevoorbeelden, vertalingen tussen GDScript en C# en verduidelijkende diagrammen. De officiële Godot-documentatie, de documentatie van gebruikte uitbreidingen en de vermelde tutorialvideo's vormen de bronnen.

AI-gegenereerde uitleg en code kunnen fouten, onvolledigheden of verkeerde aannames bevatten. Bronverwijzingen en documentatiecontroles zijn geen garantie dat een voorbeeld in elk project werkt. De codevoorbeelden zijn tijdens het schrijven niet in Godot gecompileerd of met een headset uitgevoerd. Gebruik ze daarom als leermateriaal en controleer het gedrag zelf in de genoemde versies.

De hoofdstukken en conceptpagina’s verwijzen naar de gebruikte bronnen. Niet elke video is integraal bekeken; de uitwerking steunt ook op hoofdstukbeschrijvingen en bijbehorende broncode.

Het doel is dat je de werking zelf kan verklaren en onderzoeken. Neem code niet alleen over omdat ze overtuigend wordt uitgelegd: probeer de oefeningen uit, vergelijk met de bronnen en stel je verklaring bij wanneer het resultaat niet overeenkomt met je verwachting.
