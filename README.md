# VR in Godot

Nederlandstalig cursusmateriaal voor Godot 4.5. De [startpagina](index.md) bevat de inleiding, hoofdstukverwijzingen en toelichting bij het AI-gebruik.

## Structuur

De inhoud blijft in de bestaande hoofdstukmappen. `cursus.md` bevat telkens de les; afbeeldingen, code en broncontrole staan ernaast. De concepten zijn bereikbaar via `concepten/README.md`. Jekyll bouwt de Markdownpagina's om naar HTML; de plugin `jekyll-relative-links` zet onderlinge Markdownlinks om naar de gepubliceerde pagina's.

De originele bewegingsnotities blijven in `beweging/samenvatting.md`. Ze worden via `beweging/notities.md` als brontekst weergegeven, omdat de oorspronkelijke afbeeldingslinks naar een persoonlijke notitieomgeving verwijzen.

## Publiceren op GitHub Pages

1. Plaats de repository op GitHub.
2. Kies bij **Settings → Pages → Build and deployment → Source** voor **GitHub Actions**.
3. Push de wijzigingen naar `main`, of start de workflow **Publiceer cursus op GitHub Pages** handmatig.

De workflow bouwt met de officiële GitHub Pages-Jekyll-omgeving en controleert eerst de interne verwijzingen. Pull requests worden alleen gebouwd en gecontroleerd. De workflow neemt het domein en projectpad over van GitHub Pages; een repositorynaam hoeft niet in de teksten te worden ingevuld.

Er is vanuit deze werkomgeving nog niets op GitHub gepubliceerd.

## Lokaal bekijken

Gebruik Ruby en Jekyll met de plugin `jekyll-relative-links`. De site gebruikt alleen functionaliteit die ook door GitHub Pages wordt ondersteund. Bijvoorbeeld:

```sh
gem install jekyll -v '~> 3.10'
gem install jekyll-relative-links -v '~> 0.7'
gem install webrick
jekyll serve --host 0.0.0.0 --baseurl ''
```

Open daarna poort 4000 in je browser. In een sandbox moet die poort eventueel eerst naar de host worden gepubliceerd.

Een build onder een repositorypad controleren kan met:

```sh
jekyll build --baseurl /cursus-vr-visualization
python3 scripts/check_site.py _site --baseurl /cursus-vr-visualization
```

Mermaid-diagrammen worden in de browser weergegeven met een vastgezette versie van Mermaid via jsDelivr. Als die externe dienst geblokkeerd is, blijft de diagramcode als tekst beschikbaar. De SVG-diagrammen en alle cursusafbeeldingen staan lokaal.

Alleen de cursus en de benodigde sitebestanden worden gepubliceerd. Werkomgevingsconfiguratie, agentinstructies, het voorbeeldmateriaal en `cursuskit/` zijn uitgesloten via `_config.yml`.

## Lokale verificatie

Op 11 november 2026 is de site met Jekyll 4.4.1 gebouwd, zowel zonder projectpad als onder `/cursus-vr-visualization`. De controle vond in beide builds 60 HTML-pagina's en 1.039 lokale verwijzingen, zonder problemen. De officiële GitHub Actions-build is nog niet uitgevoerd. Browserweergave, Mermaid-rendering en Godot-code zijn hier niet uitgevoerd; de hoofdstukken vermelden hun verdere verificatiegrenzen.
