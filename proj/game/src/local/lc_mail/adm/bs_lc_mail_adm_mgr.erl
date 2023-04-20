%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(bs_lc_mail_adm_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([init/0, loop_tick/0,persistent/0,terminate/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init()->
  lc_mail_adm_mgr:proc_init(),
  lc_mail_adm_ticker_mgr:init(),

  OneHour = 3600,
  lc_mail_adm_ticker_mgr:add_loop(1,{OneHour,fun lc_mail_adm_mgr:clean_expired/0}),
  %% 初始化worker 进程
  s2s_lc_mail_worker_mgr:init_gens(),
  ?OK.

loop_tick()->
  lc_mail_adm_ticker_mgr:tick(),
  ?OK.

persistent()->
  ?OK.

terminate()->
  s2s_lc_mail_worker_mgr:stop_all(),
  ?OK.

