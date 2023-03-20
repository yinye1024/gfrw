%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_tpl_mgr).
-author("yinye").
-behavior(role_mgr_behaviour).

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([get_mod/0]).

-export([role_init/1,data_load/1,after_data_load/1,loop_5_seconds/2,clean_midnight/2,clean_week/2,on_login/1]).
-export([get_all_tpl_info/0,get_tpl_info/1]).
-export([do_s2s/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
get_mod()->?MODULE.

%% 角色创建，或者角色进程初始化的时候执行
role_init(_RoleId)->
  ?OK.
%% 角色进程初始化的时候执行
data_load(_RoleId)->
  role_tpl_pc_mgr:proc_init(),
  role_tpl_pdb_mgr:proc_init(),
  ?OK.
%% 角色进程初始化，data_load 后执行
after_data_load(_RoleId)->
  ?OK.
%% 大约每隔5秒执行一次，具体执行情况要看是否有消息堆积
loop_5_seconds(_RoleId,_NowTime)->
  priv_tick(),
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

priv_tick()->
  TplItemList = role_tpl_pdb_mgr:get_all_tplList(),
  priv_tick_tpl(TplItemList),
  ?OK.
priv_tick_tpl([TplItem|Less])->
  priv_tick_tpl(Less);
priv_tick_tpl([])->
  ?OK.

get_all_tpl_info()->
  TplItemList = role_tpl_pdb_mgr:get_all_tplList(),
  tpl_s2c_handler:send_all_tpl_info(TplItemList),
  ?OK.

get_tpl_info(TplId)->
  TplItem = role_tpl_pdb_mgr:get_tpl_item(TplId),
  tpl_s2c_handler:send_all_tpl_info([TplItem]),
  ?OK.

do_s2s({_Params})->
  ?OK.
