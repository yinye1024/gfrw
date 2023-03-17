%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc

%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(bs_lc_offmsg_worker_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([init/1, loop_tick/0,persistent/0,terminate/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init({GenId})->
  lc_offmsg_plrudb_mgr:proc_init(GenId),

  lc_offmsg_worker_ticker_mgr:init(),
  lc_offmsg_worker_ticker_mgr:add_loop(1,{3600,fun lc_offmsg_plrudb_mgr:check_lru/0}),
  ?OK.

loop_tick()->
  lc_offmsg_worker_ticker_mgr:tick(),
  ?OK.

persistent()->
  lc_offmsg_plrudb_mgr:update_to_db(),
  ?OK.

terminate()->
  lc_offmsg_plrudb_mgr:update_to_db(),
  ?OK.

