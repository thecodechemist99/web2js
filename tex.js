var fs = require('fs');
var library = require('./library');

var code = fs.readFileSync(`${__dirname}/tex.wasm`);

var pages = require('./commonMemory').pages;
var memory = new WebAssembly.Memory({initial: pages, maximum: pages});

var buffer = new Uint8Array(memory.buffer);
var f = fs.openSync(`${__dirname}/core.dump`, 'r');
if (fs.readSync(f, buffer, 0, pages * 65536) != pages * 65536)
	throw 'Could not load memory dump';

library.setMemory(memory.buffer);
library.setInput(` ${process.argv[2]} \n\\end\n`);

WebAssembly.instantiate(code, { library: library, env: { memory: memory } }).then(() => {
	console.log('');

	if (process.argv.length < 4) return;

	// Save the files used by this instance to a json file.
	let filesystem = library.getUsedFiles();

	// Don't save the input filename or any generated aux files.
	delete filesystem[process.argv[2]];
	for (const filename in filesystem) {
		if (/\.aux$/.test(filename)) delete filesystem[filename];
	}

	fs.writeFileSync(`${process.argv[2].replace(/\.tex$/, "")}.resolved.json`, JSON.stringify(filesystem, null, '\t' + "\n"));
	fs.writeFileSync(`${process.argv[2].replace(/\.tex$/, "")}.json`, JSON.stringify(Object.keys(filesystem), null, '\t') + "\n");
});
