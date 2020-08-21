# AuD Zusammenfassung
## Was ist das?
Eine Zusammenfassung des Faches Algorithmen und Datenstrukturen (kurz: AuD), geschrieben in Latex.
Aktuell umfasst sie:
- Definitionen und Konzepte der Folien
- Pseudocode der Folien
- Teilweise Beispiele

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
                "-pdf",
                "-outdir=%OUTDIR%",
                "%DOC%"
            ]
        },
        {
            "name": "pdflatex",
            "command": "pdflatex",
            "args": [
                "--shell-escape",
                "-synctex=1",
                "-interaction=nonstopmode",
                "-file-line-error",
                "%DOC%"
            ]
        },
        {
            "name": "bibtex",
            "command": "bibtex",
            "args": [
                "%DOCFILE%"
            ]
        }
    ],
```
Dadurch kann die Zusammenfassung Reibungslos mit VS-Code kompillieren.
## Wie kann ich Helfen?
Wenn dir ein Fehler aufgefallen ist, du die Zusammenfassung erweitern willst oder einfach nur Anregungen hast kannst du entwerder einen Pull-Request starten oder mir auf Discord an `Rubosplay#0815` eine DM senden.

## Danksagung
Vielen Dank an [J. Milkovits](https://github.com/j-milkovits) für die Bereitstellung des Quellcodes [seiner Zusammenfassung](https://github.com/j-milkovits/latex_university_documents/tree/master/aud-reference_sheet)