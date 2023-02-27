%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(gs_stress_adm_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([init/0,stop/0,set_stress_cfg/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init()->
  stress_adm_sup:start_link(),
  ?OK.

set_stress_cfg({MaxCount,Tps,StartUserId})->
  priv_cast_fun({fun bs_stress_adm_mgr:set_stress_cfg/1,[{MaxCount,Tps,StartUserId}]}),
  ?OK.

stop()->
  stress_adm_gen:do_stop(),
  ?OK.

priv_call_fun({WorkFun,Param})->
  Result = stress_adm_gen:call_fun({WorkFun,Param}),
  Result.
priv_cast_fun({WorkFun,Param})->
  stress_adm_gen:cast_fun({WorkFun,Param}),
  ?OK.
