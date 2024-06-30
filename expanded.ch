@x
@d job_name_code=etex_convert_codes {command code for \.{\\jobname}}
@y
@d expanded_code = etex_convert_codes {command code for \.{\\expanded}}
@d job_name_code=expanded_code + 1 {command code for \.{\\jobname}}
@z
%---------------------------------------
@x
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
@x
  othercases print_esc("jobname")
@y
  expanded_code: print_esc("expanded");
  othercases print_esc("jobname")
@z
%---------------------------------------
@x
job_name_code: if job_name=0 then open_log_file;
@y
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
@z