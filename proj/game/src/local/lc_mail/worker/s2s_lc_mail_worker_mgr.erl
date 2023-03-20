%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(s2s_lc_mail_worker_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-define(MaxGenCount,10). %% 最大进程数，按最大进程数取模分配给对应的进程

%% API functions defined
-export([ets_init/0,start_sup_link/0,gen_init/0, stop_all/0]).
-export([add_mail/2,remove_by_index/2]).
-export([get_all_mail/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
ets_init()->
  gs_lc_mail_worker_mgr:ets_init(),
  ?OK.
start_sup_link()->
  gs_lc_mail_worker_mgr:start_sup_link(),
  ?OK.

gen_init()->
  priv_gen_init(0).
priv_gen_init(GenId) when GenId < ?MaxGenCount->
  priv_new_child(GenId),
  priv_gen_init(GenId+1);
priv_gen_init(_GenId)->
  ?OK.
priv_new_child(GenId)when is_integer(GenId)->
  Pid = gs_lc_mail_worker_mgr:new_child({GenId}),
  Pid.

stop_all()->
  priv_stop_all(0).
priv_stop_all(GenId)when GenId < ?MaxGenCount->
  priv_stop(GenId),
  priv_stop_all(GenId+1);
priv_stop_all(GenId)->
  ?OK.

priv_stop(GenId) when is_integer(GenId)->
  gs_lc_mail_worker_mgr:stop(GenId),
  ?OK.

add_mail(RoleId,Mail)->
  priv_cast_fun(RoleId,{fun lc_mail_plrudb_mgr:add_mail/1,[{RoleId,Mail}]}),
  ?OK.
remove_by_index(RoleId,MailIndex)->
  priv_cast_fun(RoleId,{fun lc_mail_plrudb_mgr:remove_by_index/1,[{RoleId,MailIndex}]}),
  ?OK.

get_all_mail(RoleId,LocalCbPojo)->
  priv_cast_fun(RoleId,{fun lc_mail_plrudb_mgr:get_all_mail/1,[{RoleId,LocalCbPojo}]}),
  ?OK.

%%priv_call_fun(GenId,{WorkFun, ParamList}) when is_list(ParamList)->
%%  Result = gs_lc_mail_worker_mgr:call_fun(GenId,{WorkFun, ParamList}),
%%  Result.
priv_cast_fun(RoleId,{WorkFun, ParamList}) when is_list(ParamList)->
  GenId = RoleId rem ?MaxGenCount,
  gs_lc_mail_worker_mgr:cast_fun(GenId,{WorkFun, ParamList}),
  ?OK.
