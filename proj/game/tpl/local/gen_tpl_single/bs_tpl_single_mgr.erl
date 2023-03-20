%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(bs_tpl_single_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([init/0, loop_tick/0,persistent/0,terminate/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init()->
  tpl_single_proc_db:init(),
  SingleId = ?MODULE,
  tpl_single_pc_mgr:init(SingleId),
  tpl_single_pdb_mgr:init(SingleId),

  tpl_single_ticker_mgr:init(),
  role_ticker_mgr:add_loop(1,{5,fun tpl_single_pc_mgr:tick/0}),
  ?OK.

loop_tick()->
  ?LOG_INFO({"single gen running", tpl_single_pc_mgr:get_singleId()}),
  tpl_single_ticker_mgr:tick(),
  ?OK.

persistent()->
  tpl_single_proc_db:update_to_db(),
  ?OK.

terminate()->
  tpl_single_proc_db:update_to_db(),
  ?OK.

