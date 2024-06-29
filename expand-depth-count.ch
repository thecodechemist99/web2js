@x
begin l:=cur_val_level; a:=arith_error; b:=false; p:=null;
incr(expand_depth_count);
if expand_depth_count>=expand_depth then overflow("expansion depth",expand_depth);
@<Scan and evaluate an expression |e| of type |l|@>;
decr(expand_depth_count);
@y
begin l:=cur_val_level; a:=arith_error; b:=false; p:=null;
@<Scan and evaluate an expression |e| of type |l|@>;
@z