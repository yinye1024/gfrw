%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(bs_gtpl_multi_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([init/1, loop_tick/0,persistent/0,terminate/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init({MultiId, _MultiInitArgs})->
  gtpl_multi_pc_mgr:init(MultiId),
  gtpl_multi_pdb_mgr:init(MultiId),

  gtpl_multi_ticker_mgr:init(),
  role_ticker_mgr:add_loop(1,{5,fun gtpl_multi_pc_mgr:tick/0}),
  ?OK.

loop_tick()->
  ?LOG_INFO({"multi gen running", gtpl_multi_pc_mgr:get_multiId()}),
  gtpl_multi_ticker_mgr:tick(),
  ?OK.

persistent()->
  gtpl_multi_pdb_mgr:update_to_db(),
  ?OK.

terminate()->
  gtpl_multi_pdb_mgr:update_to_db(),
  ?OK.

