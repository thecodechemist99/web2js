@x
@p procedure fix_date_and_time;
begin sys_time:=12*60;
sys_day:=4; sys_month:=7; sys_year:=1776;  {self-evident truths}
@y
@p procedure fix_date_and_time;
begin sys_time:=currentminutes;
sys_day:=currentday; sys_month:=currentmonth; sys_year:=currentyear;
@z
