@x l. 1367 - etex.ch
@d job_name_code=etex_convert_codes {command code for \.{\\jobname}}
@y
@d expanded_code = etex_convert_codes {command code for \.{\\expanded}}
@d job_name_code=expanded_code + 1 {command code for \.{\\jobname}}
@z
%---------------------------------------
@x l. 9238 - tex.web
primitive("jobname",convert,job_name_code);@/
@!@:job_name_}{\.{\\jobname} primitive@>
@y
@#
primitive("expanded",convert,expanded_code);@/
@!@:expanded_}{\.{\\expanded} primitive@>
@#
primitive("jobname",convert,job_name_code);@/
@!@:job_name_}{\.{\\jobname} primitive@>
@z
%---------------------------------------
@x l. 9248 - tex.web
  othercases print_esc("jobname")
@y
  expanded_code: print_esc("expanded");
  othercases print_esc("jobname")
@z
%---------------------------------------
@x l. 9273 - tex.web
job_name_code: if job_name=0 then open_log_file;
@y
expanded_code:
  begin
    save_scanner_status := scanner_status;
%    save_warning_index := warning_index;
    save_def_ref := def_ref;
    save_cur_string;
    scan_pdf_ext_toks;
%    warning_index := save_warning_index;
    scanner_status := save_scanner_status;
    ins_list(link(def_ref));
    free_avail(def_ref);
    def_ref := save_def_ref;
    restore_cur_string;
    return;
  end;
job_name_code: if job_name=0 then open_log_file;
@z
%---------------------------------------
@x l. 9255 - tex.web
@p procedure conv_toks;
var old_setting:0..max_selector; {holds |selector| setting}
@!c:number_code..job_name_code; {desired type of conversion}
@!save_scanner_status:small_number; {|scanner_status| upon entry}
@!b:pool_pointer; {base of temporary string}
begin c:=cur_chr; @<Scan the argument for command |c|@>;
old_setting:=selector; selector:=new_string; b:=pool_ptr;
@<Print the result of command |c|@>;
selector:=old_setting; link(garbage):=str_toks(b); ins_list(link(temp_head));
end;
@y
@p procedure conv_toks;
label exit;
var old_setting:0..max_selector; {holds |selector| setting}
p, q: pointer;
@!c:number_code..job_name_code; {desired type of conversion}
@!save_scanner_status:small_number; {|scanner_status| upon entry}
@!save_def_ref: pointer; {|def_ref| upon entry, important if inside `\.{\\message}'}
@!save_warning_index: pointer;
@!bool: boolean; {temp boolean}
@!i: integer; {first temp integer}
@!j: integer; {second temp integer}
@!b:pool_pointer; {base of temporary string}
@!s: str_number; {first temp string}
@!t: str_number; {second temp string}
@!u: str_number; {saved current string string}
begin
c:=cur_chr;
u:=0; { will become non-nil if a string is already being built}
@<Scan the argument for command |c|@>;
old_setting:=selector; selector:=new_string; b:=pool_ptr;
@<Print the result of command |c|@>;
selector:=old_setting; link(garbage):=str_toks(b); ins_list(link(temp_head));
exit:end;
@z
