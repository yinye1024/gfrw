%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(s2s_lc_friend_worker_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-define(MaxGenCount,1). %% 最大进程数，按最大进程数取模分配给对应的进程

%% API functions defined
-export([ets_init/0,start_sup_link/0,gen_init/0, stop_all/0]).
-export([add_blackId/2,rm_blackId/2]).
-export([add_friendId/2,rm_friendId/2]).
-export([get_all_apply/2,add_apply/2,rm_apply_byIndex/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
ets_init()->
  gs_lc_friend_worker_mgr:ets_init(),
  ?OK.
start_sup_link()->
  gs_lc_friend_worker_mgr:start_sup_link(),
  ?OK.

gen_init()->
  priv_gen_init(0).
priv_gen_init(GenId) when GenId < ?MaxGenCount->
  new_child(GenId),
  priv_gen_init(GenId+1);
priv_gen_init(_GenId)->
  ?OK.


new_child(GenId)when is_integer(GenId)->
  Pid = gs_lc_friend_worker_mgr:new_child({GenId}),
  Pid.

stop_all()->
  priv_stop_all(0).
priv_stop_all(GenId)when GenId < ?MaxGenCount->
  priv_stop(GenId),
  priv_stop_all(GenId+1);
priv_stop_all(GenId)->
  ?OK.

priv_stop(GenId) when is_integer(GenId)->
  gs_lc_friend_worker_mgr:stop(GenId),
  ?OK.

add_blackId(RoleId,BlackRoleId)->
  GenId = RoleId rem ?MaxGenCount,
  priv_cast_fun(GenId,{fun lc_friend_plrudb_mgr:add_blackId/1,[{RoleId,BlackRoleId}]}),
  ?OK.
rm_blackId(RoleId,BlackRoleId)->
  GenId = RoleId rem ?MaxGenCount,
  priv_cast_fun(GenId,{fun lc_friend_plrudb_mgr:rm_blackId/1,[{RoleId,BlackRoleId}]}),
  ?OK.


add_friendId(RoleId, FriendRoleId)->
  GenId = RoleId rem ?MaxGenCount,
  priv_cast_fun(GenId,{fun lc_friend_plrudb_mgr:add_friendId/1,[{RoleId, FriendRoleId}]}),
  ?OK.
rm_friendId(RoleId,FriendRoleId)->
  GenId = RoleId rem ?MaxGenCount,
  priv_cast_fun(GenId,{fun lc_friend_plrudb_mgr:rm_friendId/1,[{RoleId,FriendRoleId}]}),
  ?OK.

get_all_apply(RoleId,LocalCbPojo)->
  GenId = RoleId rem ?MaxGenCount,
  priv_cast_fun(GenId,{fun lc_friend_plrudb_mgr:get_all_apply/1,[{RoleId,LocalCbPojo}]}),
  ?OK.

add_apply(RoleId, ApplyItem)->
  GenId = RoleId rem ?MaxGenCount,
  priv_cast_fun(GenId,{fun lc_friend_plrudb_mgr:add_apply/1,[{RoleId, ApplyItem}]}),
  ?OK.
rm_apply_byIndex(RoleId,Index)->
  GenId = RoleId rem ?MaxGenCount,
  priv_cast_fun(GenId,{fun lc_friend_plrudb_mgr:rm_apply_byIndex/1,[{RoleId,Index}]}),
  ?OK.


%%priv_call_fun(GenId,{WorkFun, ParamList}) when is_list(ParamList)->
%%  Result = gs_lc_friend_worker_mgr:call_fun(GenId,{WorkFun, ParamList}),
%%  Result.
priv_cast_fun(GenId,{WorkFun, ParamList}) when is_list(ParamList)->
  gs_lc_friend_worker_mgr:cast_fun(GenId,{WorkFun, ParamList}),
  ?OK.
