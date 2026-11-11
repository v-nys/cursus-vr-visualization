# Cursus VR in Godot

- Stel een Nederlandstalige cursus op over VR in Godot.
- Gebruik `voorbeeldmateriaal/` als referentie voor de schrijfstijl. Schrijf toegankelijk en didactisch, spreek studenten rechtstreeks aan en bouw uitleg stapsgewijs op. Leg eerst het probleem en het idee uit en bespreek daarna de code. Voorzie concrete voorbeelden en momenten om zelf uit te proberen.
- Gebruik de aangeleverde video's, links en notities als bronnen. Controleer technische uitleg en API's aan de hand van de officiële Godot-documentatie. Vermeld de gebruikte Godot-versie en relevante bronverwijzingen.
- Werk puntsgewijze notities uit tot samenhangende cursustekst. Onderzoek open vragen en ontbrekende onderdelen; presenteer onbevestigde aannames niet als feiten.
- Voorzie relevante screenshots met uitleg en codevoorbeelden in zowel GDScript als C#. Geef aan waar scripts en nodes thuishoren en hoe voorbeelden samenhangen.
- Bewaar oorspronkelijke bronnotities en links. Gebruik relatieve verwijzingen naar lokale afbeeldingen en codebestanden.
- Voor het hoofdstuk beweging staan de videolinks in `beweging/links.md` en de gedeeltelijke notities in `beweging/samenvatting.md`.
- Voor het hoofdstuk debugging staat de videobron in `debugging/links.md`. De uitwerking in `debugging/cursus.md` behandelt een spectator view voor het onderzoeken van VR-gedrag; er waren geen voorafgaande bronnotities.
- Het hoofdstuk in `shaders/` is een beperkte inleiding tot eenvoudige 2D-vertex- en fragmentshaders. Gebruik slechts enkele voorbeelden; de officiële documentatie en de videobron in `shaders/links.md` vormen de basis.
- Werk onduidelijke of fundamentele begrippen uit de bewegingsnotities per concept uit in `concepten/`. Houd `concepten/README.md` bij als overzicht en koppel de oorspronkelijke vragen aan de conceptpagina's. Gebruik diagrammen waar die de uitleg verduidelijken.
- Een eventuele lokale kopie van de Godot-documentatie blijft buiten versiebeheer.

- Het hoofdstuk `objectmanipulatie/` gebruikt Bastiaan Olij's Godot XR Tools Parts 1–4. Werk de Godot 3-videoaanpak bij naar Godot 4.5 met XR Tools 4.5.1. Controleer addon-API's tegen die tag en houd nieuwe concepten in `concepten/` bij. Behoud het addon-script op pickable-roots; gebruik voor eigen C#-gedrag compositie via kindnodes.
- Publiceerbare inhoud volgt de Jekyll/GitHub Pages-structuur: frontmatter, gedeelde layout en relatieve links. Behoud hoofdstukmappen. De startpagina bevat een eerlijke AI-disclaimer en verificatiebeperkingen. Controleer builds met leeg baseurl en een repositorypad.
- Houd `cursuskit/`, werkomgevingsconfiguratie, agentinstructies en oorspronkelijk voorbeeldmateriaal buiten de gebouwde site. Publiceer niet zonder opdracht. Beschrijf screenshots met hun echte herkomst en presenteer schema's niet als uitgevoerde projectbeelden.
