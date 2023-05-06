%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_res_life_cycle_mgr).
-author("yinye").
-behavior(role_mgr_behaviour).

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([get_mod/0]).

-export([role_init/1,data_load/1,after_data_load/1,loop_5_seconds/2,clean_midnight/2,clean_week/2,on_login/1,on_terminate/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
get_mod()->?MODULE.

%% 角色创建，或者角色进程初始化的时候执行
role_init(_RoleId)->
  ?OK.
%% 角色进程初始化的时候执行
data_load(_RoleId)->
  role_res_mgr:proc_init(),
  ?OK.
%% 角色进程初始化，data_load 后执行
after_data_load(_RoleId)->
  ?OK.
%% 大约每隔5秒执行一次，具体执行情况要看是否有消息堆积
loop_5_seconds(_RoleId,_NowTime)->
  ?OK.
%% 跨天执行,一般是一些清理业务
clean_midnight(_RoleId,_LastCleanTime)->
  ?OK.
%% 跨周执行,一般是一些清理业务
clean_week(_RoleId,_LastCleanTime)->
  ?OK.
%% 玩家登陆的时候执行
on_login(_RoleId)->
  ?OK.
%% 玩家进程关闭的时候，持久化之前执行
on_terminate(_RoleId)->
  ?OK.

