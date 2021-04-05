# AuD Zusammenfassung
## Was ist das?
Eine Zusammenfassung des Faches Algorithmen und Datenstrukturen (kurz: AuD), geschrieben in Latex.
Aktuell umfasst sie:
- Definitionen und Konzepte der Folien
- Pseudocode der Folien (und teils auch eigenen)
- Einige Beispiele

## Wie kompiliere ich sie?
Requirements:
- Latex-Installation (z.B. MikTex oder TexLive)
- Installation der [TU-Template](https://github.com/tudace/tuda_latex_templates) und der verwendeten Plugins

Zunächst muss natürlich die Ordnerstruktur heruntergeladen werden, z.b. mit `git clone`.  
Anschließend muss die Zusammenfassung mit dem `--shell-escape`-Flag kompilliert werden.  
  
Bei VS-Code mit LaTeX-Workshop kann dazu die `settings.json` angepasst werden, indem man Folgendes anhängt:
```json
"latex-workshop.latex.tools": [
        {
            "name": "latexmk",
            "command": "latexmk",
            "args": [
                "--shell-escape",
                "-synctex=1",
                "-interaction=nonstopmode",
                "-file-line-error",
                "-lualatex", // alternativ: "-pdf" o.ä.
                "-outdir=%OUTDIR%",
                "%DOC%"
            ]
        },
    ],
```
Dadurch kann die Zusammenfassung Reibungslos mit VS-Code kompillieren.

## Bekannte Fehler/Warnungen
- Um die Kapitel einzeln kompillieren zu können, ist es notwendig, die `tuda_summary.cls` in `$Texmfhome` o.ä. zu legen oder jeweils in die einzelnen Ordner zu kopieren
## Wie kann ich Helfen?
Wenn dir ein Fehler aufgefallen ist, du die Zusammenfassung erweitern willst oder einfach nur Anregungen hast kannst du entwerder einen PR oder Issue eröffnen oder mir auf Discord an `Rubosplay#0815` eine DM senden.

## Versionshistorie (Changelog)
- v2.0 (06.04.2021) Komplettüberholung
  - Neues Layout
  - Umstieg auf meine `TUDA-summary.cls` Vorlage
    - Dark Mode
    - Viele Stilistische Anpassungen
  - Gitignore angepasst
  - Weniger indents (war ja teilweise die Halbe Seite mit indents verschwendet)
  - Korrupte Bilder angepasst, lässt sich wieder mit LuaTeX kompillieren
## Danksagung
Vielen Dank an [J. Milkovits](https://github.com/j-milkovits) für die Bereitstellung des Quellcodes [seiner Zusammenfassung](https://github.com/j-milkovits/latex_university_documents/tree/master/aud-reference_sheet)  

Weitere Helfer (Namen oder Discord Tags):  
- Nhan Huynh (Nyanyan#5701) - Anregungen+Fehlersuche+Hilfe
- robflop#3939 Anregungen+Fehlersuche
- Khan#3224 Fehlersuche