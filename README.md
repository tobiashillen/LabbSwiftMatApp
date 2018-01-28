# Livsmedelsapp (Swift)
av Tobias Hillén

<b>Övergripande beskrivning</b><br>
En app för personer som tränar, följer någon diet eller bara är allmänt intresserade av vilka näringsämnnen som finns i olika livsmedel.
Appen låter användaren söka efter matvaror genom matapi.se (baserat på livsmedelverkets databas) och sedan se information om dem, så som t.ex. energivärde eller fetthalt.<br>


<b>Milstolpe 1 (19 feb)</b><br>

<b>G</b><br>
Ni har byggt upp en grundstomme för appen och dess vyer i Storyboard:et.<br>
Gränssnittet använder Autolayout och anpassar sig för olika iPhone-skärmar (behöver ej anpassas för iPad eller landskapsläge).<br>
En tabellvy ska kunna presentera resultatet av användarens sökning efter livsmedel (behöver ej fungera ännu, använd temp-data för att visualisera hur det kommer att se ut).<br>

<b>VG</b><br>
Tabellvyn använder en egenkonstruerad tabell-cell som kan visa namn OCH energivärde.<br>


<b>Milstolpe 2 (26 feb)</b><br>

<b>G</b><br>
Sökfunktion där användaren kan skriva in namnet på ett livsmedel och få upp träffarna i en tabellvy.<br>
Appen ska kommunicera med webb-API:t och hämta datan om varje livsmedel därifrån.<br>
Om man vill veta mer om ett livsmedel ska man kunna trycka på det i listan och få upp en detaljvy som visar minst tre näringsvärden.<br>

<b>VG</b><br>
Appen tillåter att livsmedel sparas som "favorit" vilket består även när appen startats om.<br>
Användaren ska kunna fota och spara en egen bild för varje livsmedel.<br>


<b>Slutinlämning (5 mars 23:55)</b><br>

<b>G</b><br>
När användaren går in på ett specifikt livsmedel ska det utöver sina näringsvärden också presentera ett nyttighetsvärde som ni räknat ut, detta nyttighetsvärde ska vara baserat på näringsvärdena (men behöver inte vara realistiskt).<br>
Appen använder både UIAnimation och UIDynamics på valfritt vis.<br>
Ikon och startskärm.<br>

<b>VG</b><br>
Det går att jämföra två matvarors näringsvärden mot varandra, resultat presenteras med hjälp av ett diagram.<br>
