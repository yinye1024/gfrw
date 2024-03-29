%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(bs_lc_offmsg_adm_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([init/0, loop_tick/0,persistent/0,terminate/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init()->
  lc_offmsg_adm_ticker_mgr:init(),

  %% 初始化worker 进程
  s2s_lc_offmsg_worker_mgr:gen_init(),
  ?OK.

loop_tick()->
  lc_offmsg_adm_ticker_mgr:tick(),
  ?OK.

persistent()->
  ?OK.

terminate()->
  s2s_lc_offmsg_worker_mgr:stop_all(),
  ?OK.

