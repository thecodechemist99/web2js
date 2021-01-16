var path = require('path');
var fs = require('fs');
var spawnSync = require('child_process').spawnSync;

const basePath = '/usr/share/texlive/texmf-dist/tex/generic/pgf/frontendlayer/tikz/libraries';

fs.mkdirSync('tikz_libs', { recursive: true });

function processDir(dir) {
	for (let file of fs.readdirSync(dir, { withFileTypes: true })) {
		if (file.isDirectory()) {
			processDir(path.resolve(basePath, file.name));
		} else if (file.name.match(/^tikzlibrary.*\.code\.tex$/)) {
			let tikzLibName = file.name.replace(/^tikzlibrary(.*)\.code\.tex$/, "$1");
			console.log(`Processing ${tikzLibName}`);
			let texFile = `tikz_libs/${tikzLibName}.tex`;
			if (!fs.existsSync(texFile)) {
				console.log(`Creating ${texFile}`);
				fs.writeFileSync(texFile,
					`%\\documentclass[margin=0pt]{standalone}
%\\usepackage{tikz}
\\usetikzlibrary{${tikzLibName}}
\\begin{document}
\\end{document}`
				);
			}
			console.log(`Running TeX on ${texFile}`);
			fs.writeFileSync(`tikz_libs/${tikzLibName}.output.log`,
				spawnSync('node', ['tex.js', texFile, "y"]).stdout.toString());
			console.log(`TeX output saved to tikz_libs/${tikzLibName}.output.log`);
		}
	}
}

processDir(basePath);
