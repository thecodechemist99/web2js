'use strict';
var Binaryen = require('binaryen');
var Environment = require('./environment.js');
var Stack = require('./stack.js');
var Memory = require('./memory.js');

var pages = require('../commonMemory').pages;

module.exports = class Program {
  constructor(labels,consts,types,vars,pfs,compound, parent) {
    this.labels = labels;
    this.consts = consts;
    this.types = types;
    this.vars = vars;
    this.pfs = pfs;
    this.compound = compound;
    this.parent = parent;
    this.memory = undefined;
    this.stack = undefined;
    this.traces = [];
  }

  generate(environment) {
    environment = new Environment(environment);
    environment.program = this;
    
    var module = environment.module;

    this.memory = new Memory(module, pages);
    this.stack = new Stack(module, this.memory);
    
    this.consts.forEach( function(v) {
      environment.constants[v.name] = v.expression;
    });

    this.types.forEach( function(t) {
      environment.types[t.name] = t.expression;
    });

    for(var j in this.vars) {
      var v = this.vars[j];
      for (var i in v.names) {
        var name = v.names[i].name;
        var type = environment.resolveType( v.type );

        environment.variables[name] = this.memory.allocateVariable( name, type );
      }
    };
    
    this.pfs.forEach( function(v) {
      v.generate(environment);
    });

    module.addGlobal( "trampoline", Binaryen.i32, true, module.i32.const(-1) );
    
    var e = this.compound.generate(environment);
    
    var main = module.addFunction("main", [], Binaryen.none, [], e);

    module.addFunctionExport("main", "main");

    module.addFunctionImport( "start_unwind", "asyncify", "start_unwind",
                              Binaryen.createType([Binaryen.i32]), Binaryen.none );
    module.addFunctionImport( "stop_unwind", "asyncify", "stop_unwind",
                              Binaryen.createType([]), Binaryen.none );
    module.addFunctionImport( "start_rewind", "asyncify", "start_rewind",
                              Binaryen.createType([Binaryen.i32]), Binaryen.none );
    module.addFunctionImport( "stop_rewind", "asyncify", "stop_rewind",
                              Binaryen.createType([]), Binaryen.none );

    module.addFunctionImport( "printInteger", "library", "printInteger",
                              Binaryen.createType([Binaryen.i32,Binaryen.i32]), Binaryen.none );
    module.addFunctionImport( "printBoolean", "library", "printBoolean",
                              Binaryen.createType([Binaryen.i32,Binaryen.i32]), Binaryen.none );
    module.addFunctionImport( "printChar", "library", "printChar",
                              Binaryen.createType([Binaryen.i32,Binaryen.i32]), Binaryen.none );
    module.addFunctionImport( "printString", "library", "printString",
                              Binaryen.createType([Binaryen.i32,Binaryen.i32]), Binaryen.none );
    module.addFunctionImport( "printFloat", "library", "printFloat",
                              Binaryen.createType([Binaryen.i32,Binaryen.f32]), Binaryen.none );
    module.addFunctionImport( "printNewline", "library", "printNewline",
                              Binaryen.createType([Binaryen.i32]), Binaryen.none );

    module.addFunctionImport( "reset", "library", "reset",
                              Binaryen.createType([Binaryen.i32, Binaryen.i32]), Binaryen.i32 );

    module.addFunctionImport( "rewrite", "library", "rewrite",
                              Binaryen.createType([Binaryen.i32, Binaryen.i32]), Binaryen.i32 );

    module.addFunctionImport( "get", "library", "get",
                              Binaryen.createType([Binaryen.i32, Binaryen.i32, Binaryen.i32]), Binaryen.none );

    module.addFunctionImport( "put", "library", "put",
                              Binaryen.createType([Binaryen.i32, Binaryen.i32, Binaryen.i32]), Binaryen.none );

    
    module.addFunctionImport( "eof", "library", "eof",
                              Binaryen.createType([Binaryen.i32]), Binaryen.i32 );

    module.addFunctionImport( "eoln", "library", "eoln",
                              Binaryen.createType([Binaryen.i32]), Binaryen.i32 );

    module.addFunctionImport( "erstat", "library", "erstat",
                              Binaryen.createType([Binaryen.i32]), Binaryen.i32 );

    module.addFunctionImport( "close", "library", "close",
                              Binaryen.createType([Binaryen.i32]), Binaryen.none );

    module.addFunctionImport( "getCurrentMinutes", "library", "getCurrentMinutes",
                              Binaryen.createType([]), Binaryen.i32 );

    module.addFunctionImport( "getCurrentDay", "library", "getCurrentDay",
                              Binaryen.createType([]), Binaryen.i32 );

    module.addFunctionImport( "getCurrentMonth", "library", "getCurrentMonth",
                              Binaryen.createType([]), Binaryen.i32 );

    module.addFunctionImport( "getCurrentYear", "library", "getCurrentYear",
                              Binaryen.createType([]), Binaryen.i32 );

    module.addFunctionImport( "tex_final_end", "library", "tex_final_end",
                              Binaryen.createType([]), Binaryen.none );

    this.memory.setup();
    
    return module;
   }
};

