# web2js

This is a Pascal compiler that targets WebAssembly, designed
specifically to compile TeX.

## Getting started

The following assumes you have TeX running on your machine (e.g., that
`tangle` is available).

Download a clean copy of the TeX WEB source.
```
wget http://ctan.math.washington.edu/tex-archive/systems/knuth/dist/tex/tex.web
```
Download the e-TeX change file.
```
wget -O etex.ch 'https://tug.org/svn/texlive/trunk/Build/source/texk/web2c/etexdir/etex.ch?revision=32727&view=co'
```
Tie the TeX WEB source and e-TeX change file.
```
tie -m etex.web tex.web etex.ch
```
Produce the Pascal source by tangling.
```
tangle -underline etex.web etex.sys
```
You will now have the Pascal source `etex.p` along with `etex.pool` which contains the strings.

Compile the `etex.p` sources to get the the WebAssembly binary `out.wasm`
```
npm install
npm run-script build
node compile.js etex.p
```

Download the file pgflibraryarrows.meta.code.tex and save it as tikzlibraryarrows.meta.code.tex.
```
wget -O tikzlibraryarrows.meta.code.tex https://raw.githubusercontent.com/pgf-tikz/pgf/master/tex/generic/pgf/libraries/pgflibraryarrows.meta.code.tex
```
Copy pgfsys-ximera.def from the jhoobergs dvi2html fork.
```
wget https://raw.githubusercontent.com/jhoobergs/dvi2html/master/pgfsys-ximera.def
```

Produce the memory dump corresponding to the WebAssembly binary.
```
node initex.js
```

Remove `\\def\\pgfsysdriver{pgfsys-ximera.def}` and re-run `node initex.js` and compile `sample.tex` by running
```
node tex.js
```
This outputs sample.dvi.  Convert to pdf to view using dvipdf (or dvips and ps2pdf).

Alternately change
```
library.setInput("\n&latex \\documentclass[margin=0pt]{standalone}\\def\\pgfsysdriver{pgfsys-ximera.def}\\usepackage{tikz}\\usetikzlibrary{arrows.meta,calc}\n\n",
```
to
```
library.setInput("\n&latex\n\n",
```
This generates a general latex compiler.  To use it uncomment the first three lines of sample.tex, and run `node tex.js`.  The files needed to compile must be available and locatable by kpsewhich.
