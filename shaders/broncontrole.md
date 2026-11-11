---
title: "Broncontrole en verificatie"
section_title: "2D-shaders"
section_url: /shaders/
---
# Broncontrole en verificatie

Referentie: Godot **4.5**. Geraadpleegd op **11 november 2026**.

## Afbakening

De opdracht vraagt een inleiding met slechts enkele eenvoudige 2D-vertex- en fragmentvoorbeelden. De uitwerking bevat daarom drie zelfstandige shaders: een egale fragmentkleur, een texturekleurfilter met een uniform en een horizontale verbreding via vertexposities. Er is één optioneel uniformvoorbeeld in GDScript en C#. Het is geen volledige samenvatting van de veel uitgebreidere video.

## Gebruikte bronnen

De YouTube-pagina van [The ultimate introduction to shaders in Godot](https://www.youtube.com/watch?v=J9qx8MxuJYM), door Clear Code, is opgehaald. Titel, beschrijving en hoofdstukindeling zijn geraadpleegd voor de selectie van de basisonderwerpen. Er is geen volledig audiovisueel verslag of transcript gebruikt en de externe projectbestanden van de video zijn niet overgenomen. De kleine cursusvoorbeelden zijn zelfstandig uitgewerkt en gecontroleerd aan de officiële documentatie.

De volgende documentatie is gelezen vanuit de `4.5`-branch van `godotengine/godot-docs`:

- `tutorials/shaders/introduction_to_shaders.rst`;
- `tutorials/shaders/your_first_shader/your_first_2d_shader.rst`;
- `tutorials/shaders/shader_reference/canvas_item_shader.rst`;
- `tutorials/shaders/shader_reference/shading_language.rst`.

Tijdelijke onderzoekskopieën staan buiten versiebeheer. De oorspronkelijke videolink en de voornaamste documentatielinks staan in [links.md](links.md).

## Technische aandachtspunten

- Een fragment is uitgelegd als een kandidaat voor een pixelkleur; er is geen één-op-één-garantie tussen shaderaanroep en uiteindelijke schermpixel.
- De fragment-invoer `COLOR` bevat bij een Sprite2D de texturekleur al, inclusief de gebruikelijke vertex- en nodemodulatie. De kleurfilter vermenigvuldigt de texture dus niet nog eens in de shader.
- De egale kleur overschrijft ook de oorspronkelijke texture-alpha. De kleurfilter behoudt die alpha bij een filteralpha van 1.
- `VERTEX` bevat in deze canvas-itemshader lokale posities. De verbreding verandert de tekening, niet de node-transform of physicsvorm.
- De voorbeelden gebruiken `unshaded`, zodat verlichting geen bijkomend onderwerp vormt.
- Uniforms worden ingesteld op het ShaderMaterial. Het onderscheid tussen een gedeeld shaderbestand en een gedeeld materiaal is uitgelegd.
- De vertex- en fragmentcode blijft dezelfde in GDScript- en C#-projecten. Alleen het aansturen van een uniform heeft twee taalversies.

## Controles en grenzen

De twee documentatieafbeeldingen zijn visueel bekeken; hun aard en herkomst staan in [afbeeldingen/BRONNEN.md](afbeeldingen/BRONNEN.md). De lokale Markdown-verwijzingen, afbeeldingspaden, codefences en whitespace zijn gecontroleerd. De shaderbestanden zijn handmatig vergeleken met de codeblokken in de les en de GDScript- en C#-voorbeelden zijn naast elkaar nagekeken.

Godot 4 en de .NET-SDK zijn hier niet geïnstalleerd. De shaders zijn daarom **niet door Godot gecompileerd of gerenderd**, en de optionele scripts zijn niet in Godot uitgevoerd of in C# gecompileerd. De oefeningen in het hoofdstuk vormen de nog uit te voeren praktische controle.
