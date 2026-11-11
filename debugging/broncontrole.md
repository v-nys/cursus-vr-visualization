---
title: "Broncontrole en verificatie"
section_title: "Debugging"
section_url: /debugging/
---
# Broncontrole en verificatie

Referentie: Godot **4.5**. Geraadpleegd op **11 november 2026**.

## Afbakening en bronnen

De enige aangeleverde bron is de video [Godot XR Spectator View](https://www.youtube.com/watch?v=VvTLP3neEbg). Er was geen samenvatting. Het hoofdstuk behandelt daarom de spectatoropstelling uit deze video, met gerichte toepassingen voor debugging; het is geen algemene cursus over alle Godot-debuggertools.

De YouTube-pagina is opgehaald en de titel, beschrijving, hoofdstukken en broncodeverwijzing zijn nagegaan. De inhoud is uitgewerkt op basis van die hoofdstukken en de bijbehorende broncode. Er is geen volledig audiovisueel verslag of transcript gebruikt.

Uit de branch `spectator_view` van `BastiaanOlij/godot4_tutorial` zijn geraadpleegd:

- `project.godot` en `main.tscn`;
- `main.gd`;
- `spectator/spectator_view.tscn` en `spectator/spectator_view.gd`;
- `spectator/third_person_camera_3d.gd`;
- `spectator/stabilized_camera_3d.gd`;
- `objects/hmd.tscn` en `effects/fade.tscn`;
- de MIT-licentie van het project.

Deze bestanden zijn via `raw.githubusercontent.com` gelezen. De projectconfiguratie vermeldt Godot 4.4. De API-controle gebeurde met de officiële documentatie uit de `4.5`-branch van `godotengine/godot-docs`. Tijdelijke onderzoekskopieën staan buiten versiebeheer.

## Koppeling tussen video en cursus

| Videohoofdstuk | Verwerking |
| --- | --- |
| 0:53 — overzicht | Drie beelden van dezelfde simulatie; onderscheid tussen headset en spectator. |
| 1:45 — projectinstellingen | Desktop-hoofdscène, mobile-override en het bereik van die featuretag. |
| 2:34 — Main inpakken | Eén instantie van Main onder de HMD-subviewport; `get_viewport()` behouden in de XR-opstartcode. |
| 3:50 — spectatornodes | Scèneboom, gedeelde World3D en cameratoewijzing per viewport. |
| 4:15 — buitencamera | Vast standpunt met een bijgewerkte kijkrichting. |
| 5:00 — renderlagen | Wereld, HMD, spectator en firstperson; onderscheid met physicslagen. |
| 6:10 — cameramodel | Headsetmodel, zichtbare capsule, shadow-only mesh en comforteffecten. |
| 7:10 — buitencameracode | GDScript-voorbeeld en C#-vertaling. |
| 7:50 — firstperson-inzet | Frame, container, viewportgrootte, actieve camera en update mode. |
| 9:00 — stabilisatie | Lokale hoofdpose, rechte horizon, interpolatie en omzetting naar wereldruimte. |
| 10:40 — FOV-slider | Slider koppelen aan de gewone insetcamera. |
| 11:45 — demonstratie | Omgezet naar concrete praktijktests voor de cursist. |

## Bewuste aanpassingen

- De commentaar "Remove pitch" in het originele stabilisatiescript beschrijft de berekening niet correct: de kijkrichting blijft behouden en vooral roll wordt verwijderd. Dat onderscheid is expliciet uitgelegd.
- De smoothing gebruikt een exponentiële interpolatiefactor in plaats van `delta / smooth_delay`, om overshoot bij grote frametijden te vermijden.
- De cameracode controleert ongeldige referenties en onbruikbare kijkrichtingen. Nabij verticale hoofdoriëntaties gebruikt de insetcamera een orthonormale gemeten basis.
- `reset_smoothing` / `ResetSmoothing` is beschikbaar om de filtergeschiedenis te resetten.
- Een setupscript maakt de gedeelde wereld en de eerste vier renderlagen expliciet. De videomasks laten ook ongebruikte hogere lagen toe; de cursusmasks beperken zich tot de vier beschreven lagen.
- De scripts gebruiken geëxporteerde referenties in plaats van lange vaste nodepaden. Signalen worden in code gekoppeld; de C#-versie koppelt de slider ook los bij het verlaten van de scèneboom.
- Praktische foutdiagnose en oefeningen zijn didactische aanvullingen. Ze zijn geen woordelijke transcriptie van de video.

## Screenshots en controles

Drie echte editorscreenshots uit de officiële documentatie zijn lokaal opgenomen en visueel nagekeken. Ze illustreren viewportstructuren en zijn geen beelden van een hier uitgevoerd XR-project. Herkomst en CC BY 3.0-licentie staan in [afbeeldingen/BRONNEN.md](afbeeldingen/BRONNEN.md).

De lokale Markdown-links, afbeeldingspaden, codefences en whitespace zijn gecontroleerd. De GDScript- en C#-versies zijn handmatig naast elkaar nagekeken op overeenkomstige werking. Gebruikte viewport-, camera-, transform- en slider-API's zijn vergeleken met de Godot 4.5-documentatie.

Godot 4 en de .NET-SDK zijn hier niet geïnstalleerd. De scripts zijn dus **niet door Godot geparseerd, in C# gecompileerd of met een headset uitgevoerd**. De praktijktests in het hoofdstuk blijven nodig, met bijzondere aandacht voor de gedeelde wereld, headsetoutput, renderlagen, cameravolgorde en renderbelasting.
