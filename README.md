# Kita-Beitragsrechner

Webanwendung zur Berechnung der Kita-Kosten für Familien im **Rheinisch-Bergischen Kreis** (Burscheid, Kürten, Odenthal). Sie berechnet Elternbeiträge nach der Beitragsstaffelung ab 01.08.2026 und rechnet Zusatzkosten der Kita mit ein. Mehrere Kitas lassen sich vergleichen.

> **Hinweis:** Unverbindliche Berechnung. Verbindlich ist allein der Beitragsbescheid des Kreisjugendamts. Für andere Jugendamtsbezirke sind die Regeln und Tabellen nicht gültig.

## Funktionen

- Beliebig viele Kinder mit mehreren Betreuungsphasen (z. B. Tagespflege, danach Kita)
- Elternbeitrag nach Einkommen, Alter (unter/ab 3 Jahren) und Wochenstunden (15 bis 55)
- Einkommen als Auswahl der Beitragsstufen (bis 35.000 € bis über 120.000 €)
- Geschwisterregel: Beitrag geteilt durch die Zahl der betreuten Kinder, inklusive OGS-Kindern
- Beitragsfreiheit der letzten zwei Kita-Jahre vor der Einschulung (§ 50 KiBiz NRW)
- Freibetrag ab dem 3. Kind und abweichendes Einkommen je Kalenderjahr
- **Kita-Profile und Vergleich:** Mittagessen und Frühstück (pro Monat), Träger- und Mitgliedsbeitrag, Arbeitsstunden, Einmalkosten und Sonstiges je Kita, mit Vergleichstabelle und Diagrammen
- Ausgabe: Kosten pro Kind, pro Jahr und pro Monat, Gesamtkosten, Diagramme, Monatstabelle
- Export als JSON, PDF-Kurzbericht und PDF-Langbericht (A4), Import von JSON, CSV der Monatstabelle
- Dateinamen mit Datum, z. B. `2026-11-16_Langbericht`, `2026-11-16_Kurzbericht`, `2026-11-16_Kita-Daten.json`
- Hell, Dunkel oder System, Eingabevalidierung, Fortschrittsanzeige, Hilfetexte und Kurzanleitung

## Nutzung

Die App ist rein statisch (HTML und JavaScript, kein Backend, keine Cookies, kein Tracking). Alle Eingaben bleiben im Browser. Gespeichert wird nur die Darstellungswahl (Hell/Dunkel/System).

Monate gibst du als `MM/JJJJ` ein (z. B. `08/2027`). Chrome und Edge bieten eine Monatsauswahl, im Firefox tippst du den Wert ein.

**Lokal:** `index.html` im Browser öffnen.

**Docker:**

```bash
docker compose up -d --build
# danach http://localhost:8080
```

**GitHub Pages:** Repository veröffentlichen, unter *Settings → Pages* den Branch `main` und den Ordner `/ (root)` wählen.

## Rechenregeln und Quellen

| Thema | Grundlage |
|---|---|
| Elternbeiträge | [Elternbeitragssatzung](https://www.rbk-direkt.de/download/1296/elternbeitragssatzung) des Rheinisch-Bergischen Kreises |
| Beitragstabelle | [Staffelung ab 01.08.2026](https://www.rbk-direkt.de/download/5581/elternbeitragsstaffelung-ab-01082026) |
| Beitragsfreiheit | § 50 KiBiz NRW, siehe [Familienportal NRW](https://www.familienportal.nrw/de/1-bis-3-jahre/finanzielles-formales/kosten-fuer-kindertagesbetreuung) |

Annahmen der Berechnung:

- Stundenzuordnung der Tabellenspalten: 15 Std. = 75 %, 25 = 85 %, 35 = 100 %, 45 = 130 %, 55 = 150 %. Die Spalten „75 %" bis „150 %" werden aus der Spalte „100 %" berechnet und auf 0,1 € gerundet.
- Der Beitrag sinkt zum 1. des Geburtstagsmonats auf die Stufe „ab 3 Jahren".
- Einschulung: Kinder, die bis zum 30.09. sechs Jahre alt werden. Die Betreuung endet ohne Angabe am 31.07. des Einschulungsjahres.
- Beitragsfreie Kinder zählen bei der Geschwisterteilung mit (Auskunft des Jugendamts).
- Der Elternbeitrag ist für alle Kitas gleich, im Vergleich gehen alle Kinder in dieselbe Kita.
- Monate vor 08/2026 werden mit der Tabelle ab 08/2026 gerechnet, die App warnt dann.

## Beitragstabelle aktualisieren

Oben im Skript in `index.html` steht das Objekt `TAB`. Eine neue Tabelle wird als weiteres Objekt mit dem Gültig-ab-Monat (`ab: 'JJJJ-MM'`) und den Werten der Spalte „100 %" für „ab 3 Jahren" (`a3`) und „unter 3 Jahren" (`u3`) ergänzt. Die App wählt je Monat automatisch die passende Tabelle.

## Technik und CSS

- **Bootstrap 5.3.3** liefert das gesamte Layout und Styling über Klassen (CSS und JavaScript-Bundle, lokal in `vendor/`).
- **Material Design Icons** liefern die Icons (CSS und Schriftdateien, lokal in `vendor/`).
- **Chart.js 4.4.7** zeichnet die Diagramme.
- **Eigenes CSS** gibt es nur für den Druck der PDF-Berichte: ein `<style>`-Block mit rund zehn Regeln in `index.html` (A4, Seitenränder, Seitenumbrüche, Druckfarben, volle Seitenbreite, Skalierung der Diagramme). Dazu kommen zwei Inline-Höhenangaben für das Diagramm und die scrollbare Monatstabelle sowie die Breite des Fortschrittsbalkens, die per JavaScript gesetzt wird.
- Die PDF-Berichte entstehen über den Druckdialog des Browsers („Als PDF speichern").

## Projektstruktur

```
index.html          Anwendung (HTML und JavaScript, wenige Zeilen Druck-CSS)
vendor/             Bootstrap, Material Design Icons, Chart.js (lokal eingebunden)
Dockerfile          nginx-Image zum Ausliefern
docker-compose.yml  Start auf Port 8080
LICENSE             MIT-Lizenz
THIRD-PARTY-NOTICES.txt  Lizenztexte der eingebundenen Bibliotheken
```

## Drittanbieter

| Bibliothek | Lizenz |
|---|---|
| [Bootstrap](https://getbootstrap.com) 5.3.3 | MIT |
| [Chart.js](https://www.chartjs.org) 4.4.7 | MIT |
| [Material Design Icons](https://pictogrammers.com/library/mdi/) 7.4.47 | Pictogrammers Free License (Icons und Schrift: Apache 2.0) |

Die vollständigen Lizenztexte stehen in [THIRD-PARTY-NOTICES.txt](THIRD-PARTY-NOTICES.txt). Die Beitragswerte stammen aus öffentlichen Veröffentlichungen des Kreises und fallen nicht unter die Lizenz dieses Projekts.

## Lizenz

[MIT](LICENSE). Du darfst den Code frei nutzen, ändern und weitergeben. Der Urheberhinweis und der Lizenztext müssen in allen Kopien erhalten bleiben (Namensnennung).

## Haftungsausschluss

Das Projekt ist keine amtliche Auskunft und keine Rechtsberatung. Eine Haftung für die Richtigkeit der Ergebnisse ist ausgeschlossen. Prüfe wichtige Werte anhand der verlinkten Quellen und frage bei Zweifeln beim Kreisjugendamt nach.
