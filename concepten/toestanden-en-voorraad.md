---
title: "Toestanden en voorraad"
section_title: "Concepten"
section_url: /concepten/
---
# Toestanden en voorraad

Voor **Godot 4.5 en XR Tools 4.5.1**. Dit begrip ondersteunt de [les objectmanipulatie](../objectmanipulatie/cursus.md).

Een voorraad zegt hoeveel items beschikbaar zijn. Een toestand zegt wat een onderdeel op dit moment kan doen. Die twee vallen niet samen. Een magazijn kan vol zijn terwijl de kamer leeg is. Omgekeerd kan de kamer geladen blijven nadat je het magazijn verwijdert.

## Drie expliciete toestanden

| Toestand vóór de actie | Actie | Gevolg |
| --- | --- | --- |
| Leeg | Trigger | Klik; geen projectiel. |
| Geladen | Trigger | Eén projectiel; toestand wordt huls. |
| Huls | Trigger | Klik; geen projectiel. |
| Willekeurig | Slede | Oude inhoud uitwerpen; één nieuwe patroon nemen als dat kan. |

De magazijnteller daalt tijdens het laden van de kamer. Hij daalt niet nog eens tijdens afvuren. Neem je twee keer af voor hetzelfde projectiel, dan meng je twee verantwoordelijkheden.

```gdscript
# De kamer vraagt een patroon; het magazijn bewaakt zijn eigen voorraad.
if magazine.take_round():
    state = State.LIVE
```

```csharp
if (magazine.TakeRound())
    State = ChamberState.Live;
```

De volledige klassen staan bij [de lescode](../objectmanipulatie/code/index.md). Gebruik een enum voor de kamer in plaats van drie losse booleans. Met drie booleans kan de kamer per ongeluk tegelijk leeg en geladen zijn. Een enum dwingt één van de afgesproken waarden af. De overgangslogica moet nog steeds bewaken welke acties geldig zijn.

## Eerst oude informatie bewaren

Wil je iets uitwerpen, bewaar dan de oude toestand vóór je die op leeg zet. Die oude toestand bepaalt of de visual een ongebruikte patroon of een huls moet voorstellen. Daarna kan je een nieuwe patroon laden. De volgorde is onderdeel van het model, geen detail van de animatie.

**Rekenproef:** start met drie patronen in het magazijn en een lege kamer. Bedien de slede, vuur af, druk nogmaals de trigger in en bedien opnieuw de slede. De magazijnvoorraad is achtereenvolgens 2, 2, 2 en 1; de kamer eindigt geladen.

Bronnen: [tutorial Part 4](https://www.youtube.com/watch?v=mSBFU-gq0MY), [GDScript-enums](https://docs.godotengine.org/en/4.5/tutorials/scripting/gdscript/gdscript_basics.html#enums).
