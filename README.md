## Voorstel App 3 - FootyScores

Schermontwerpen: https://drive.google.com/file/d/0B1P9A65saikIWnhCc1FQZXdZZnc/view?usp=sharing

Voor deze applicatie is hierbij het volgende voorstel;
Er wordt een App worden ontwikkeld waarmee live, geplande en gespeeld voetbalwedstrijden getoond worden, in de vorm van scores.

**MUST:**

De volgende functionaliteiten worden onderdeel van de applicatie:
- Het betreft een side-menu applicatie
- Wedstrijd data wordt opgehaald uit een API, en in de applicatie in de vorm van een Service gebruikt
- De applicatie toont:
    - wedstrijden van vandaag (ongeacht al gespeeld of nog niet)
    - wedstrijd uitslagen tot 3 dagen terug
    - wedstrijd programma tot 3 dagen vooruit
    - geabboneerde wedstrijden (onderdeel van **should**)
  
  
**SHOULD:**  

- Een gebruiker kan per, nog niet gespeelde wedstrijd, aangeven om te abbonneren op een wedstrijd
    - Hierbij wordt er gebruik gemaakt van applicatie storage om de geabboneerde matches in op te slaan
- Zodra geabbonneerd op een match, push notificatie versturen op device bij: Doelpunt, rode kaart, penalty toegekent, penalty gemist, aftrap, rust, aftrap 2e helft, einde match.


**COULD:**

- Bij een match, kan je een foto maken die dan wordt gedeeld bij de match. Andere mensen met de app zouden die foto dan kunnen zien. We gaan de daadwerkelijkeservice, die ervoor zorgt dat de foto bij andere app gebruikers zichtbaar is niet implementeren, maar het opslaan van de foto bij een match wel. Dus andere mensen zullen die afbeelding nooit zien, maar puur het gebruik van de camera is wel leuk hier. Het idee hierachter is dat mensen over de hele wereld, die aanwezig zijn bij die match in het stadion, sfeerimpressies kunnen delen.

- Ook willen we experimenteren met het gebruik van een Map locatie zoals in App 2. Echter willen we hierbij op een Map de huidige locatie weergeven, met daarbij markers met dicht bijzijnde wedstrijden. Bijv. FC Utrecht is 67km hiervan vandaan, en speelt morgen.
