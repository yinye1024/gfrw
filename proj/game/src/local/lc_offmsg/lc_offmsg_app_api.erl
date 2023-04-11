%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%%    设计要点
%%%    1 lc只管接收离线消息，和通知玩家进程。玩家进程自己读取数据，处理并记录已处理的信息index.
%%%    2 lc 根据index清理旧的数据
%%%    3 worker 进程内用Lrudb对该worker进程管理的用户数据进行更新管理和持久化管理，避免进程内的数据堆积。
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_offmsg_app_api).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([ets_init/0, start_svr/0, stop_svr/0]).
-export([get_data/2]).
-export([add_msg/2,remove_by_index/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
%%
ets_init()->
  s2s_lc_offmsg_worker_mgr:ets_init(),
  ?OK.

start_svr()->
  s2s_lc_offmsg_worker_mgr:start_sup_link(),
  s2s_lc_offmsg_adm_mgr:start_sup_link(),
  ?OK.

stop_svr()->
  gs_lc_offmsg_adm_mgr:stop(),
  ?OK.

get_data(RoleId,LocalCbPojo)->
  s2s_lc_offmsg_worker_mgr:get_all_msg(RoleId,LocalCbPojo),
  ?OK.

add_msg(RoleId,Msg)->
  s2s_lc_offmsg_worker_mgr:add_msg(RoleId,Msg),
  ?OK.
remove_by_index(RoleId,MsgIndex)->
  s2s_lc_offmsg_worker_mgr:remove_by_index(RoleId,MsgIndex),
  ?OK.
