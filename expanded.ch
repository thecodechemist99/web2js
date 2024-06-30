@x
@ The primitives \.{\\number}, \.{\\romannumeral}, \.{\\string}, \.{\\meaning},
\.{\\fontname}, and \.{\\jobname} are defined as follows.

@d number_code=0 {command code for \.{\\number}}
@d roman_numeral_code=1 {command code for \.{\\romannumeral}}
@d string_code=2 {command code for \.{\\string}}
@d meaning_code=3 {command code for \.{\\meaning}}
@d font_name_code=4 {command code for \.{\\fontname}}
@d job_name_code=5 {command code for \.{\\jobname}}

@<Put each...@>=
primitive("number",convert,number_code);@/
@!@:number_}{\.{\\number} primitive@>
primitive("romannumeral",convert,roman_numeral_code);@/
@!@:roman_numeral_}{\.{\\romannumeral} primitive@>
primitive("string",convert,string_code);@/
@!@:string_}{\.{\\string} primitive@>
primitive("meaning",convert,meaning_code);@/
@!@:meaning_}{\.{\\meaning} primitive@>
primitive("fontname",convert,font_name_code);@/
@!@:font_name_}{\.{\\fontname} primitive@>
primitive("jobname",convert,job_name_code);@/
@!@:job_name_}{\.{\\jobname} primitive@>

@ @<Cases of |print_cmd_chr|...@>=
convert: case chr_code of
  number_code: print_esc("number");
  roman_numeral_code: print_esc("romannumeral");
  string_code: print_esc("string");
  meaning_code: print_esc("meaning");
  font_name_code: print_esc("fontname");
  othercases print_esc("jobname")
  endcases;
@y
@ The primitives \.{\\number}, \.{\\romannumeral}, \.{\\string}, \.{\\meaning},
\.{\\fontname}, and \.{\\jobname} are defined as follows.

\eTeX\ adds \.{\\eTeXrevision} such that |job_name_code| remains last.

@d number_code=0 {command code for \.{\\number}}
@d roman_numeral_code=1 {command code for \.{\\romannumeral}}
@d string_code=2 {command code for \.{\\string}}
@d meaning_code=3 {command code for \.{\\meaning}}
@d font_name_code=4 {command code for \.{\\fontname}}
@d etex_convert_base=5 {base for \eTeX's command codes}
@d eTeX_revision_code=etex_convert_base {command code for \.{\\eTeXrevision}}
@d etex_convert_codes=etex_convert_base+1 {end of \eTeX's command codes}
@d expanded_code = etex_convert_codes {command code for \.{\\expanded}}
@d job_name_code=expanded_code + 1 {command code for \.{\\jobname}}

@<Put each...@>=
primitive("number",convert,number_code);@/
@!@:number_}{\.{\\number} primitive@>
primitive("romannumeral",convert,roman_numeral_code);@/
@!@:roman_numeral_}{\.{\\romannumeral} primitive@>
primitive("string",convert,string_code);@/
@!@:string_}{\.{\\string} primitive@>
primitive("meaning",convert,meaning_code);@/
@!@:meaning_}{\.{\\meaning} primitive@>
primitive("fontname",convert,font_name_code);@/
@!@:font_name_}{\.{\\fontname} primitive@>
@#
primitive("expanded",convert,expanded_code);@/
@!@:expanded_}{\.{\\expanded} primitive@>
@#
primitive("jobname",convert,job_name_code);@/
@!@:job_name_}{\.{\\jobname} primitive@>

@ @<Cases of |print_cmd_chr|...@>=
convert: case chr_code of
  number_code: print_esc("number");
  roman_numeral_code: print_esc("romannumeral");
  string_code: print_esc("string");
  meaning_code: print_esc("meaning");
  font_name_code: print_esc("fontname");
  eTeX_revision_code: print_esc("eTeXrevision");
  expanded_code: print_esc("expanded");
  othercases print_esc("jobname")
  endcases;
@z
%---------------------------------------
@x
@ @<Scan the argument for command |c|@>=
case c of
number_code,roman_numeral_code: scan_int;
string_code, meaning_code: begin save_scanner_status:=scanner_status;
  scanner_status:=normal; get_token; scanner_status:=save_scanner_status;
  end;
font_name_code: scan_font_ident;
job_name_code: if job_name=0 then open_log_file;
end {there are no other cases}

@ @<Print the result of command |c|@>=
case c of
number_code: print_int(cur_val);
roman_numeral_code: print_roman_int(cur_val);
string_code:if cur_cs<>0 then sprint_cs(cur_cs)
  else print_char(cur_chr);
meaning_code: print_meaning;
font_name_code: begin print(font_name[cur_val]);
  if font_size[cur_val]<>font_dsize[cur_val] then
    begin print(" at "); print_scaled(font_size[cur_val]);
    print("pt");
    end;
  end;
job_name_code: print(job_name);
end {there are no other cases}
@y
@ @<Scan the argument for command |c|@>=
case c of
number_code,roman_numeral_code: scan_int;
string_code, meaning_code: begin save_scanner_status:=scanner_status;
  scanner_status:=normal; get_token; scanner_status:=save_scanner_status;
  end;
font_name_code: scan_font_ident;
eTeX_revision_code: do_nothing;
expanded_code:
  begin
    save_scanner_status := scanner_status;
    save_warning_index := warning_index;
    save_def_ref := def_ref;
    save_cur_string;
    scan_pdf_ext_toks;
    warning_index := save_warning_index;
    scanner_status := save_scanner_status;
    ins_list(link(def_ref));
    free_avail(def_ref);
    def_ref := save_def_ref;
    restore_cur_string;
    return;
  end;
job_name_code: if job_name=0 then open_log_file;
end;
end {there are no other cases}

@ @<Print the result of command |c|@>=
case c of
number_code: print_int(cur_val);
roman_numeral_code: print_roman_int(cur_val);
string_code:if cur_cs<>0 then sprint_cs(cur_cs)
  else print_char(cur_chr);
meaning_code: print_meaning;
font_name_code: begin print(font_name[cur_val]);
  if font_size[cur_val]<>font_dsize[cur_val] then
    begin print(" at "); print_scaled(font_size[cur_val]);
    print("pt");
    end;
  end;
eTeX_revision_code: print(eTeX_revision);
job_name_code: print(job_name);
end {there are no other cases}
@z
%---------------------------------------
@x

@y

@z