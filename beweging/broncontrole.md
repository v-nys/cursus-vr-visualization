---
title: "Broncontrole en verificatie"
section_title: "Beweging"
section_url: /beweging/
---
# Broncontrole en verificatie

Referentie: Godot **4.5**. Geraadpleegd op **11 november 2026**.

## Gebruikte bronnen

- De oorspronkelijke `links.md` en `samenvatting.md` zijn behouden.
- De YouTube-pagina's van de drie video's zijn opgehaald. Titels, beschrijvingen en hoofdstuktijdstippen zijn gecontroleerd. De videobeschrijvingen verwijzen naar de overeenkomstige tutorialbranches.
- De video-inhoud is uitgewerkt op basis van de aangeleverde notities, de hoofdstukbeschrijvingen en de bijbehorende GDScript-broncode. Er is geen volledig audiovisueel verslag of transcript gebruikt.
- Van het tutorialproject zijn de fysieke controller uit deel 1 en 2 en de scène, lichaamscontroller, fysieke controller, bewegingsfuncties, effecten en shaders uit deel 3 geraadpleegd via `raw.githubusercontent.com`. De projectconfiguratie van deel 3 vermeldt Godot 4.4.
- De officiële documentatie is gelezen vanuit de `4.5`-branch van `godotengine/godot-docs`. De links in het hoofdstuk wijzen naar dezelfde documentatieversie. De tijdelijke onderzoekskopieën staan buiten de repository.

## Aanvullingen en correcties op de notities

| Onderwerp | Bevinding / verwerking |
| --- | --- |
| Transform en basis | Positie, rotatie/schaal, lokale ruimte, wereldruimte en de volgorde van vermenigvuldigen uitgelegd. |
| Tegenbeweging origin | Zowel lokale inverse-basisomrekening als rechtstreekse wereldcorrectie toegelicht. De volledige voorbeelden bewaren de wereldtransform bij fysieke beweging. |
| `move_and_collide` | Werkt met een wereldverplaatsing; `velocity` en `move_and_slide` werken met een wereldsnelheid. |
| Horizontale rotatie | Pitch en roll blijven buiten het lichaam; bijna verticale kijkrichting wordt afgevangen. |
| Simple Controller | Geen algemene vervanging voor thumbsticks; beperkingen benoemd. |
| Snelheid projecteren | Resultaten van vectorprojecties blijven wereldvectoren. |
| Interpolatie | Exponentiële factor gebruikt in plaats van een mogelijk te grote lineaire factor. |
| Reverse Z | Godot 4.3+ vereist aangepaste clip-Z; voorbeelden richten zich op 4.5. |
| `ARRAY_MAX` | Grootte van de tabel met vertexkanalen, niet het aantal vertices. |
| `sqrt(2)` | Geometrische betekenis en beperking bij oogprojectie verklaard. |
| Hoofd door muur | Sweep-query aangevuld met overlapcontrole; extra collider lost de trackingvraag niet zelfstandig op. |
| Sessiesignalen | Zichtbaarheid en focus zijn geen garantie dat de speler klaarstaat; expliciete bevestiging aanbevolen. |
| Kalibratie | Geldige trackerpose vereist; geen voortdurend compenseren van bukken. |
| Trappen | Ontbrekend deel aangevuld: bovenlichaamscapsule, raycast en PID, bevestigd door hoofdstukken en broncode van deel 3. |
| PID | Tekenconventie, integraalbegrenzing, eerste afgeleide en tickafhankelijkheid expliciet gemaakt. |

## Screenshots

Vier echte editorscreenshots uit de officiële documentatie zijn lokaal opgenomen en visueel bekeken. De action-mapafbeeldingen in die documentatie tonen deels een oudere editorinterface; actienamen en bindings moeten voor het cursusvoorbeeld worden aangepast. Het zijn geen screenshots van een zelf uitgevoerd cursusproject. Zie [afbeeldingen/BRONNEN.md](afbeeldingen/BRONNEN.md) voor de herkomst en licentie per bestand.

## Code en controles

De twee `VRPlayer`-scripts zijn alternatieve implementaties voor dezelfde scèneopbouw. Ze centraliseren de physicsvolgorde, in plaats van de afzonderlijke `_physics_process`-functies uit de video's te combineren. De ringgeneratoren en shaders worden apart gekoppeld zoals beschreven in de cursustekst.

Uitgevoerde controles:

- lokale Markdown-verwijzingen en afbeeldingspaden gecontroleerd op bestaande bestanden;
- codeblokken gecontroleerd op gesloten fences;
- screenshots visueel gecontroleerd;
- gebruikte physics-, tracking- en shader-API's vergeleken met de Godot 4.5-documentatie;
- GDScript en C# handmatig naast elkaar nagekeken op overeenkomstige uitvoervolgorde en berekeningen;
- nieuwe tekstbestanden gecontroleerd op whitespacefouten.

Godot 4 en de .NET-SDK zijn niet geïnstalleerd in deze werkomgeving. De scripts zijn daarom **niet door Godot geparseerd, in C# gecompileerd of met een headset uitgevoerd**. De praktijktests aan het einde van het hoofdstuk moeten nog op een XR-opstelling gebeuren. Vooral comfort, stereoscopische weergave, collision-instellingen en PID-afstelling zijn afhankelijk van het concrete project en de hardware.
