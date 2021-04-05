# Will Put The Fixed PDF-Files in a seperate folder
mkdir -p fixed
for f in *.pdf; do
  gs -o "fixed/$f" -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress "$f"
done
