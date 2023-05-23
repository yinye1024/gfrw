%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_monitor_top_cfg_helper).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([is_gen_can_be_killed/1,get_log_file_path/0,get_log_file_expired_days/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================

%% 列表内的 sup的子进程，可以被killed
is_gen_can_be_killed(GenSupMod)->
  CanKilledSupList = [role_online_sup:get_mod()],
  yyu_list:contains(GenSupMod,CanKilledSupList).

%% 日志文件相对路径
get_log_file_path()->
  Dir = priv_make_or_get_dir(),
  FilePathFormat = Dir ++ "/mnitor_~p_~2.10.0B_~2.10.0B.log",
  {{Year,Month,Day},{_,_,_}} = yyu_calendar:local_time(),
  io_lib:format(FilePathFormat,[Year,Month,Day]).

priv_make_or_get_dir()->
  {?OK,Path} = file:get_cwd(),
  Dir = Path ++ "/log/monitor",
  case file:list_dir(Dir) of
    {error,enoent}->
      file:make_dir(Dir);
    {?OK,_}->?OK
  end,
  Dir.

get_log_file_expired_days()->
  14.






