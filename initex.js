var fs = require('fs');
var library = require('./library');

var binary = fs.readFileSync('tex.wasm');

var code = new WebAssembly.Module(binary);

var pages = 1000;
var memory = new WebAssembly.Memory({initial: pages, maximum: pages});
library.setMemory(memory.buffer);
library.setInput("\n*latex.ltx \\dump\n\n", function() {});

WebAssembly.instantiate(code, { library: library, env: { memory: memory } });

library.setMemory(memory.buffer);
library.setInput("\n&latex \\documentclass[margin=0pt]{standalone}\\def\\pgfsysdriver{pgfsys-ximera.def}\\usepackage{tikz}\n\n",
	function() {
		var buffer = new Uint8Array(memory.buffer);
		fs.writeFileSync('core.dump', buffer);

		// Save the files used to a json file.
		let filesystem = library.getUsedFiles();
		fs.writeFileSync('initex-filesystem.json', JSON.stringify(filesystem, null, '\t'));

		process.exit();
	});

WebAssembly.instantiate(code, { library: library, env: { memory: memory } });
