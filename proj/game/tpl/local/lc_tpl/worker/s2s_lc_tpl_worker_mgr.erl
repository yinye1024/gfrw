%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(s2s_lc_tpl_worker_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-define(MaxGenCount,10). %% 最大进程数，按最大进程数取模分配给对应的进程

%% API functions defined
-export([ets_init/0,start_sup_link/0,gen_init/0, stop_all/0]).
-export([new_tpl/1, update_tpl/1,set_online/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
ets_init()->
  gs_lc_tpl_worker_mgr:ets_init(),
  ?OK.
start_sup_link()->
  gs_lc_tpl_worker_mgr:start_sup_link(),
  ?OK.

gen_init()->
  priv_gen_init(0).
priv_gen_init(GenId) when GenId < ?MaxGenCount->
  new_child(GenId),
  priv_gen_init(GenId+1);
priv_gen_init(_GenId)->
  ?OK.


new_child(GenId)when is_integer(GenId)->
  Pid = gs_lc_tpl_worker_mgr:new_child({GenId}),
  Pid.

stop_all()->
  priv_stop_all(0).
priv_stop_all(GenId)when GenId < ?MaxGenCount->
  priv_stop(GenId),
  priv_stop_all(GenId+1);
priv_stop_all(GenId)->
  ?OK.

priv_stop(GenId) when is_integer(GenId)->
  gs_lc_tpl_worker_mgr:stop(GenId),
  ?OK.

new_tpl(GlbTplPojo)->
  TplId = lc_tpl_pdb_pojo:get_id(GlbTplPojo),
  GenId = TplId rem ?MaxGenCount,
  priv_cast_fun(GenId,{fun bs_lc_tpl_worker_mgr:new_tpl/1,[{GlbTplPojo}]}),
  ?OK.
update_tpl(GlbTplPojo)->
  TplId = lc_tpl_pdb_pojo:get_id(GlbTplPojo),
  GenId = TplId rem ?MaxGenCount,
  priv_cast_fun(GenId,{fun bs_lc_tpl_worker_mgr:update_tpl/1,[{GlbTplPojo}]}),
  ?OK.
set_online(TplId,IsOnline)->
  GenId = TplId rem ?MaxGenCount,
  priv_cast_fun(GenId,{fun bs_lc_tpl_worker_mgr:set_online/1,[{TplId,IsOnline}]}),
  ?OK.

priv_call_fun(GenId,{WorkFun, ParamList}) when is_list(ParamList)->
  Result = gs_lc_tpl_worker_mgr:call_fun(GenId,{WorkFun, ParamList}),
  Result.
priv_cast_fun(GenId,{WorkFun, ParamList}) when is_list(ParamList)->
  gs_lc_tpl_worker_mgr:cast_fun(GenId,{WorkFun, ParamList}),
  ?OK.
