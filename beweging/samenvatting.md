# video 1

## inleiding (0:00)
Startpunt is:
![3d67d73d80bb7fbf9abf932a726745ed.png](:/b0d035d8245542d6acfd152157b6b108)

Goed idee a priori [samenvatting spectator view](:/084207c0f3b24bcb87984493f07223e5) toe te passen.

Merk op: XR system trackt controller en camera. Deze kunnen **niet** aangestuurd worden door de programmeur.
Origin rondbewegen verplaatst ook de speler, want origin is het referentiepunt: hoofd en handen worden gepositioneerd in game via offset ten opzichte van origin.

De origin is **niet** "waar de speler staat", want we kunnen rondwandelen.

Conclusie:

- fysieke beweging mag origin niet verplaatsen (or roteren)
- controllerbeweging moet origin net wel verplaatsen (of roteren)

## setup CharacterBody3D (1:57)
- World is voorgesteld als subscene van main (om clutter te vermijden): ![01fce91edea202bf3c61ac0d40121472.png](:/b39937c116ba45e78a96aaef6f6ae02c)
- start eigenlijk met een klassieke CharacterBody3D controller: voeg een CharacterBody3D toe (met een CollisionShape3D, normaal een capsule), waarbij bodem van de collision shape de grond raakt en ongeveer even hoog komt als de fysieke lengte van het hoofdpersonage (al zullen we later aanpassen aan de hoogte). Kunnen een transparante MeshInstance toevoegen om de capsule zichtbaar te maken.
- indien beschikbaar: voeg een axis subscene toe voor visualisatie (**TODO: achterhaal van waar deze scene komt, neem eventueel over uit broncode Bastiaan**)
- reparent de XROrigin3D op de CharacterBody3D: ![40c2e020afdc1725bfddf5cc501d8003.png](:/9bb94442160e4cb1bdfcec9e07f846e3)
  - dit zorgt dus dat klassieke input de origin mee verplaatst
  - fysieke beweging zal vereisen dat we de CharacterBody gelijk proberen te houden met het hoofd van de speler, maar dat zou de XROrigin3D dus ook verplaatsen. Oplossing: via script de verplaatsing van de XROrigin3D ongedaan maken. Zie verder.

## fysieke beweging (3:25)
- script op CharacterBody zal controller movement regelen
- script op XROrigin3D zal de fysieke beweging regelen
  - we geven het een class name en maken het `@tool`
    - reden hiervoor: tool scripts kunnen `_get_configuration_warnings` implementeren en dus aangeven wanneer bepaalde zaken nog niet / niet juist ingesteld zijn
	- we doen dit door een `PackedStringArray` (**TODO: zoek type uit**) te maken en hier per warning een element aan toe te voegen
	- specifiek: als er geen parent is, of als de parent niet van het type CharacterBody3D is
  - dan voegen we movement code toe aan `_physics_process`
    - proberen de parent te achterhalen en exiten als dat niet lukt (al zou dat enkel mogen zijn als we at runtime gereparent hebben of als we warning genegeerd hebben)
	- we vragen de XRCamera3D node op (die een kind is van de XROrigin3D)
	  - kunnen dit ook toevoegen aan onze configuration warnings (en dit gebeurt ook in de video)
**TODO: maak tekeningen!**
- we passen onze physics_process functie aan zodat ze niet loopt in de editor (if Engine.is_editor_hint (in filmpje doet hij dit pas achteraf))
  - nu moeten we de transform (**todo:definitie**) van de camera achterhalen in de local space van onze characterbody (dit is die van onze origin * die van de camera)
  - de nieuwe gewenste positie is onze camerapositie, herleid naar de grond ("gewenst", want het is niet gezegd dat de speler op die positie kan staan; er kunnen obstakels in de weg staan)
  - dan plaatsen we deze nieuwe gewenste positie in world space door de new position te vermenigvuldigen met de global transform (**todo**) van onze CharacterBody3D
  - dan doen we een move_and_collide van ons CharacterBody: de bewegingsvector is het verschil tussen de nieuwe gewenste positie en de oorspronkelijke positie (todo: move_and_collide werkt altijd met world space, correct?)
  - dan checken we de daadwerkelijke verplaatsing (die kan kleiner zijn indien er een botsing is opgetreden) (in world space)
  - we moeten die verplaatsing terug omzetten naar de local space van ons characterbody en dan toepassen op de origin (todo: ik had deze stap rechtstreeks in global space gedaan?) (todo: hij doet dit met global_basis.inverse(), zoek uit!)
 
## rotatie matchen (5:50)
  - characterbody beweegt nu mee en origin blijft staan, maar ronddraaien draait de characterbody niet
  - reminder: fysiek ronddraaien zou impact moeten hebben op personage maar niet op origin; controller based movement zou beide moeten doen
  - we gebruiken hier ook de camera transform van eerder (in local space character body), maar negeren positie "and tilt"
    - in andere video bedoelt hij hier blijkbaar "roll" mee, belangrijkste is in elk geval yaw
- dan bepalen we onze forward vector via de Z van de basis (**todo**) van onze transform
  - we negeren de Y-component (todo: effect?)
  - we negeren ook de origin ervan (todo: effect?)
  - we bekomen de uiteindelijke rotatietransformatie door looking_at te doen (todo: `looking_at(forward, Vector3.UP, true)`)
  - deze rotatie passen we toe op de basis van de characterbody (todo: check effect wanneer we dit niet beperken tot basis)
  - we passen de inverse transformatie toe op de origin

## obstakel toevoegen (7:05)
  - zet een obstakel
  - merk probleem op: characterbody zal botsen tegen obstakel, maar fysiek kunnen we er doorheen wandelen
  - oplossing: "fade to black" logica
    - zullen de locatie van het CharacterBody vergelijken met die van onze XRCamera3D -> als deze te ver uiteen lopen, moet het scherm donker worden
- de afstand in kwestie: verschil tussen onze globale positie en de nieuwe positie van ons CharacterBody3D
- we voegen twee export variables toe: `max_distance` om aan te geven vanaf wanneer we fade beginnen toepassen (hij zet dit standaard op 20cm), `fade_distance` geeft aan hoe veel verder we dan moeten gaan om 100% zwart te zien
- dan berekenen we de sterkte van onze fade als waarde tussen 0 en 1 (via clamp)
- we stellen de fade zelf voor als Node3D die kind is van de XRCamera3D node en we slaan op als aparte scene
  - script hierop bevat export variable voor de sterkte van de fade (die we hierboven berekend hebben maar moeten instellen op de scene)
  - we voegen (als kind) een plane mesh toe van 2mx2m, en we willen "face Z" als zetting ipv de default
  - we maken een nieuw shader material
    - start met nieuwe vertex shader die de componenten Z en W op 1 zet (**todo: effect W?**) om een full screen rectangle te krijgen
	- stel render_mode in op depth_test_disabled, skip_vertex_transform, unshaded, culling_disabled (**todo: wata doen al deze zaken?**)
	 - voeg een uniform toe om de alpha in te stellen
	 - gebruik fragment shader om zwart te maken indien fade maximaal is
	 - stel render priority in op hoge waarde, zodat dit material pas als laatste wordt gerenderd
	 - voeg setter toe aan de exported fade variable om update_fade op te roepen wanneer de waarde wijzigt
	  - update_fade verbergt de mesh indien de waarde 0 is en toont hem met juiste alphawaarde indien de waarde groter is dan 0
	  - mak er een tool script van, zodat het zichtbaar is in de editor
	  - geef een class name: dit staat toe in de XROrigin3D een export variable te maken waarmee het fade effect gekoppeld kan worden
- maak het shadermaterial "local to scene".

# video 2

## Inleiding (00:31)
Bedoeling is controller input,... te verkrijgen via het OpenXR action map system. Dit is niet exact hetzelfde als gewone controllers. 

## Action map (1:07)
Bastiaan toont de acties die nodig zijn voor het project in kwestie, dus de rest mogen weg:
![09b47c007c294c3103aa1f7ee6b8c5f2.png](:/ffb8ce0802f540598509d9c112635959)

De acties zijn een contract tussen de game en OpenXR over welke inputs en formaten we nodig hebben.

Andere tabs gaan over specifieke controllers. De "simple controller" moet **altijd** geconfigureerd worden zodat er altijd een fallback is. De touch controller is die van Quest headsets. Het advies is enkel profielen te ondersteunen waarvoor je de hardware hebt. Als je de hardware niet hebt, zou je de runtime van de andere hardware (bijvoorbeeld Index controller) een ondersteund controllertype moeten laten nabootsen. Maar dat is redelijk onvoorspelbaar (want veel runtimes mappen dan op het "simple controller" type en niet op pakweg "Touch controller"), dus het is best te configureren en testen op alle hardware waarop je software "ondersteund" is.

Bindings worden ingeladen @ startup, dus er is geen ingebouwde remapping. Wat in principe wel kan is de inputs mappen op XR acties en dan de XR acties mappen op in game acties. Bastiaan is hier niet zo'n fan van: aangezien de speler zijn/haar eigen handen gebruikt, zouden controls natuurlijk genoeg gemaakt moeten kunnen worden dat remapping niet zinvol is.

## Implementatie movement logic (4:19-ish)
We voegen een script toe aan de CharacterBody3D. Hier staat al wat "klassieke" controllerlogica in (met pijltjes en zwaartekracht). Deze logica **mag** blijven staan als het de bedoeling is klassieke movement en XR input te combineren, maar als klassieke input niet nodig is, mag het meeste gewoon weg.

- voeg een export variable toe waarmee de XR controller voor beweging gekoppeld kan worden
- controleer, na opvragen van gewone input, of er een XR controller is
- zo ja: gebruik get_vector2("movement") om de waarde van de movement action te verkrijgen en flip de Y-waarde
- link de export variable
- **idee opdracht: werk een UI uit voor VR settings en laat spelers die ook implementeren**
- beweging met touch controller zou nu moeten werken
- bedoeling verder is dit niet rechtstreeks in script op CharacterBody te doen, maar via koppeling van controller
- verwijder alle logica van beweging behalve zwaartekracht en de call van move_and_slide
- maak een (folder voor) een script direct_movement_function.gd
  - maak dit extends Node3D en geef class name DirectMovementFunction
- dit script zal gekoppeld worden (door een Node3D met het script te parenten) aan de controller in kwestie
  - voorzie een veld voor de controller en voor de CharacterBody3D die bestuurd zal worden
  - voorzie een _enter_tree die deze onderdelen zal vinden en instellen (zodat dit blijft werken als we de hiërarchie aanpassen)
    - loop gewoon recursief door ancestors (zijn van type `Node`) tot we een node van het juiste type vinden voor beide
- export een max_speed property Vector2 om die instelbaar te maken (Vector2 om aparte voorwaartse en zijwaartse snelheid te voorzien)
- bewegingscode komt in physics process en moet alleen lopen als parent en characterbody er zijn
  - haal de input op ("movement" actie)
  - breek de snelheid op in elke richting (volgens het lokaal assenstelsen van de characterbody, niet globaal, via `project`)
  - bereken de gewenste voorwaartse en zijwaartse snelheid
  - sommeer de (waar nodig gelerpte) snelheden om de nieuwe totale snelheid te verkrijgen (in het lokale assenstelsel?)
  - voeg een export variable toe voor de sterkte van de lerp en vermenigvuldig die met delta om de grootte van een aanpassing te krijgen

## Draaien (10:25+)
Vergelijkbaar, maar class name is TurnFunction
enter_tree is zelfde
export variable voor turn speed in °/s (hint "radians_as_degrees" is niet voor menselijke user, maar voor Godot: zegt dat user kan ingeven in ° maar dat achter de schermen conversie gebeurt)
haal in physics_process de (x van) de input op
bereken een nieuwe basis voor de characterbody (we halen de basis uit de transform, dus is in local space van de character body, terwijl beweging werkte op basis van snelheid en dus in world space)
gebruik de functie `rotated`
voeg toe als child node van de andere controller
werkt, maar kan leiden tot misselijkheid
hierna volgen twee aanpassingen: aangeraden wordt de gebruiker de keuze te geven over welke van deze aanpassingen, if any, gedaan wordt

## Snap turning (13:00+)
voorzie een variable voor de grootte van de increment in °
voorzie een variable voor de geaccumuleerde rotatie (zodat er pas effectief iets gebeurt wanneer we die som bereiken)
reset naar 0 elke keer de geaccumuleerde
test: fysieke rotatie is smooth, maar controller input werkt in increments

## Vignette mesh (14:50)
Voeg nieuwe node3D Vignette toe aan camera (vergelijkbaar met Fade). Save als scene. Voeg een MeshInstance3D toe, maar koppel geen echte mesh. Dit zal in code gebeuren.

Voorzie functie _update_mesh() (aangeroepen @ ready)
Definieer een PackedVector3Array voor de vertices
Definieer een PackedInt32Array voor de indices
Voorzie een variabele "steps" voor het aantal segmenten
Resize de arrays zodat ze het gewenste formaat hebben
Bereken de vertices op afstanden 1 en 2 van het middelpunt in code door te loopen over de steps
Bereken twee triangles van telkens 3 vertices per segment

Maak nieuwe ArrayMesh en een nieuwe Array. Resize de Array tot ArrayMesh.ARRAY_MAX (**todo: why?**) en vul de vertices en indices in, roep dan `add_surface_from_arrays`.

Zet om naar tool script. Openen scene zou een cirkel met opening in het midden moeten tonen.

Weergave:

## Vignette shader (17:30)
Voeg nieuw shader material toe aan de mesh en koppel er een shader (spatial) aan.
Voorzie een uniform om de straal van de binnenste cirkel te kunnen vastleggen. (kan met : hint_range(0.0, 2.0))
Voorzie ook een "varying" genaamd "dist" om data te kunnen doorgeven van de vertex naar fragment shader.

Begin in de vertex shader door de afstand van de xy van de vector te checken (< 1.5 of >= 1.5).
Pas nu de afstand en vertex aan aan de radius.
Merk op: stereoscopic rendering betekent dat dit eigenlijk "twee keer" moet gebeuren (zie tekening Remarkable).
Gebruik projectiematrix om de xy van een punt in de verte te berekenen: er is een "parallelle" lijn van ons oog naar dat punt.
Verplaats dan de vertex met die xy en pas perspectiefdeling toe.

Stel dan nieuwe waarde vertex in.
TODO: achterhaal hoe het zit met "reverse Z".
Stel ook cull_disabled in, want anders zou het ding niet verschijnen.
Stel ook unshaded en depth_test_disabled in (TODO: ?).
Voeg een uniform toe voor de kleur (vec4) en ken in de fragment shader toe via albedo.
Voeg ook een fade waarde toe en pas de alpha aan in functie hiervan, zodat de cirkel donkerder is naar de schermranden toe.
Zorg ook voor hoge render priority en maak het materiaal local to scene.

## Vignette properties (20:30).
Voeg een export variable toe voor de radius, met setterfunctie. Zorg dat die het vignette updatet **als we in de boom zitten**.
Zorg in de _update_radiusfunctie dat het shadermaterial wordt opgevraagd en stel dan de radius in: radius * sqrt(2), zodat input 1 betekent dat het vignette net buiten scherm valt (TODO: verklaar!). Maak instance ook enkel zichtbaar als radius < 1.

Voorzie ook setter voor de fade en voorzie ook een update_fade.

Beide aspecten zouden zichtbaar moeten zijn in editor.
Geef ook een class name aan het vignette script, koppel aan rotatiecode (via export variable) en stel de radius dan in in functie van de controller input.

Verplaats desnoods een beetje vooruit zodat geen frustum culling optreedt.

## Door muren wandelen (22:55)
Probleem: hoofd kan voorbij lichaam verplaatsen (waardoor we o.a. over een tafel kunnen buigen), maar dat betekent ook dat we hoofd door muur kunnen duwen (omdat er geen collision logic op zit).

**M.O.: Bastiaan lost dit op in code, maar volgens mij kan het eenvoudig met een gewone extra collision shape voor het hoofd.**

maak een exportvariabele voor de grootte van het hoofd van de speler (radius)
maak er ook eentje voor de hoogte van (het centrum van) ons hoofd
we kunnen de physics engine bevragen via een PhysicsShapeQuery (?), dus voorzie een variabele van type PhysicsShapeQueryParameters3D om die te cachen.
In ready checken we eerst zelfde stuff als anders.
Dan maken we een nieuw Physics...3D object.
We geven het hetzelfde collision mask als ons character body (kan in code).
We excluden het characterbody zelf (via `shape_query.exclude = [ character_body.get_rid()`]) (TODO: wat is rid?)
Dan maken we een SphereShape3D variabele, met dezelfde radius als ons hoofd en we kennen deze toe aan het `.shape` onderdeel van de ShapeQuery.

Code om te achterhalen of volledige fade to black nodig is:
![f2a6a735c7bca729700cded72c85b0d1.png](:/4e3fc2c925f44ac2aac928e65730a134)

En dan daarna stellen we fade dus in indien er botsing is.

# video 3

## Inleiding (00:00)
Probleem is dat personage heel klein lijkt als we neerzitten. Doelstelling: lengte calibreren.

## Toelichting werking (00:35+)
We moeten origin omhoog duwen, zodat speler zo groot wordt als gewenst. We kunnen head height uit eerder script gebruiken.

Voorzie een export boolean auto_calibrate_height om aan te geven of we dit willen doen en een (interne) variabele die bijhoudt of calibratie al eens gebeurd is. Indien de auto aan staat, roepen we de calibratiefunctie op @ ready.

De functie calibrate_height zelf:

![7a875e3c8a309b9900585b460ef13d1f.png](:/1912ba329fd0432799db562e8051a04b)

Kan zijn dat we moeten wachten tot XR-stuff beschikbaar is, dus voorzie (onder de code die shape_query maakt) een variabele xr_interface: OpenXRInterface (die de OpenXR interface vraagt aan de XRServer). Indien beschikbaar kunnen we connecteren met session_visible signal. Dit wordt verzonden als de applicatie klaar is voor gebruik en wanneer de applicatie focus verliest.

In geval van autocalibratie die nog niet heeft plaatsgevonden, kunnen we dat in signal handler doen.

## The problem (3:33-ish)
Kan zijn dat calibratie al heeft plaatsgevonden voor user echt klaar was. Zal speler uiteindelijk groter/kleiner maken in game. Moet dus calibratie op juiste tijdstip laten lopen. Eén typische oplossing: laat speler eerst verschijnen in omgeving die onafhankelijk is van hoogte van de speler, bv. soort startscherm waar user nog moet bevestigen. Dat wordt hier niet gedaan, maar er wordt een systeem voorzien om te herkalibreren @ "recenter". Connecteer gewoon (via zelfde weg als eerder met communicatie met XRServer) met _on_pose_recenter, die eigenlijk gewoon de herkalibratiefunctie oproept (indien auto als optie aan staat).

## Adjusting the collision shape (5:25-ish)
Kan zijn dat speler zich effectief wil bukken. Doe dit via script op de CharacterBody3D. Voorzie export variable om te linken met de camera die hoogte aangeeft (i.e. HMD). 

Pas process aan:

We moeten de camera transform in local space hebben en we zeggen dat de hoogte van de speler een klein beetje hoger is dan dat (eigenlijk zouden we radius hoofd moeten kunnen gebruiken?). 

Hernoem collision shape naar BodyCollisionShape.

Plaats de collision shape op hoogte van de speler.
Voorzie ook een onready var voor de vorm van de collision shape (CapsuleShape3D) voor easy access.

Geef in de functie de capsule dezelfde hoogte als de speler.

Bukken zou collision shape moeten doen krimpen.

## Fixing our staircase issue (7:23+)
Nog niet overgenomen. Agent moet dit zelf aanvullen.
