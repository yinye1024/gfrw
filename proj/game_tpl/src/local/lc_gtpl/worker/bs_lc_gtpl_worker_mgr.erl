%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc

%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(bs_lc_gtpl_worker_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([init/1, loop_tick/0,persistent/0,terminate/0]).
-export([new_gtpl/1, update_gtpl/1, set_online/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init({GenId})->
  lc_gtpl_plrudb_mgr:proc_init(GenId),

  lc_gtpl_worker_ticker_mgr:init(),
  lc_gtpl_worker_ticker_mgr:add_loop(1,{3600,fun lc_gtpl_plrudb_mgr:check_lru/0}),
  ?OK.

loop_tick()->
  lc_gtpl_worker_ticker_mgr:tick(),
  ?OK.

persistent()->
  lc_gtpl_plrudb_mgr:update_to_db(),
  ?OK.

terminate()->
  lc_gtpl_plrudb_mgr:update_to_db(),
  ?OK.

new_gtpl({GlbTplPojo})->
  lc_gtpl_plrudb_mgr:new_gtpl(GlbTplPojo),
  ?OK.
update_gtpl({GlbTplPojo})->
  lc_gtpl_plrudb_mgr:update_gtpl(GlbTplPojo),
  ?OK.
set_online({TplId,IsOnline})->
  lc_gtpl_plrudb_mgr:set_online(TplId,IsOnline),
  ?OK.
