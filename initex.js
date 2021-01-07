var fs = require('fs');
var library = require('./library');

var binary = fs.readFileSync('tex.wasm');

var code = new WebAssembly.Module(binary);

var pages = require('./commonMemory').pages;
var memory = new WebAssembly.Memory({initial: pages, maximum: pages});
library.setMemory(memory.buffer);
library.setInput("\n*latex.ltx \\dump\n\n", function() {});

var wasm = new WebAssembly.Instance(code, { library: library, env: { memory: memory } });

library.setMemory(memory.buffer);
library.setInput(`\n&latex \\documentclass[margin=0pt]{standalone}\\def\\pgfsysdriver{pgfsys-ximera.def}
\\usepackage[svgnames]{xcolor}\\usepackage{tikz}\n\n`,
	function() {
		var buffer = new Uint8Array(memory.buffer);
		fs.writeFileSync('core.dump', buffer);

		// Save the files used to a json file.
		let filesystem = library.getUsedFiles();
		fs.writeFileSync('initex-files.json', JSON.stringify(filesystem, null, '\t'));

		process.exit();
	});

wasm = new WebAssembly.Instance(code, { library: library, env: { memory: memory } });
