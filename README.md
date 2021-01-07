# web2js

This is a Pascal compiler that targets WebAssembly, designed specifically to compile TeX.

## Getting started

The following assumes you have TeX running on your machine (e.g., that `tangle` is available),
and that you have the neccessary tex files installed on your system.

A quick path to generate the tex.wasm and core.dump files is
```
npm install
npm run build
npm run generate-wasm
```
You may want to run (assumes wasm-opt is on your path)
```
wasm-opt -O tex.wasm -o out.wasm
mv out.wasm tex.wasm
```
Then run
```
npm run initex
```

More details on this process are below.

Install node modules.
```
npm install
```

Generate the Pascal parser.
```
npm run build
```

The contents of the `texk` and `etexdir` subdirectories were simply copied from tug.org via
```
mkdir texk
rsync -a --delete --exclude=.svn tug.org::tldevsrc/Build/source/texk/web2c/tex.web texk
rsync -a --delete --exclude=.svn tug.org::tldevsrc/Build/source/texk/web2c/etexdir .
```

Tie the TeX WEB source and e-TeX change file.
```
tie -m etex.web texk/tex.web etexdir/etex.ch date.ch
```
Produce the Pascal source by tangling.
```
tangle -underline etex.web etex.sys
```
You will now have the Pascal source `etex.p` along with `etex.pool` which contains the strings.

Compile the `etex.p` sources to get the the WebAssembly binary `tex.wasm`
```
node compile.js etex.p
```

The above three commands can all be run with
```
npm run generate-wasm
```

You may want to optimize the wasm binary by running
```
wasm-opt -O tex.wasm -o out.wasm
mv out.wasm tex.wasm
```
This assumes that wasm-opt is in your path.

Produce the memory dump corresponding to the WebAssembly binary.
```
node initex.js
```
or
```
npm run initex
```

To test the assembly and core dump run
```
node tex.js sample.tex
```

If you remove `\\def\\pgfsysdriver{pgfsys-ximera.def}`, re-run `node initex.js`, compile `sample.tex` by running
```
node tex.js sample.tex
```
This outputs sample.dvi.  Convert to pdf to view using dvipdf (or dvips and ps2pdf).

Alternately change
```
library.setInput("\n&latex \\documentclass...}\n\n",
```
in initex.js to
```
library.setInput("\n&latex\n\n",
```
to generate a general latex compiler.  To use it uncomment the first three lines of sample.tex, and run
```
node tex.js sample.tex
```
