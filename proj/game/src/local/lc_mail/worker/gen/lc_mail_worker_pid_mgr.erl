%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_mail_worker_pid_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-define(Ets_TName,?MODULE).

%% API functions defined
-export([ets_init/0,reg/2,unReg/1,get_pid/1]).


%% ===================================================================================
%% API functions implements
%% ===================================================================================
ets_init()->
  yyu_ets_cache_dao:init(?Ets_TName),
  ?OK.

reg(GenId,Pid)->
  yyu_ets_cache_dao:put_data(?Ets_TName,GenId,Pid),
  ?OK.

unReg(GenId)->
  yyu_ets_cache_dao:remove(?Ets_TName,GenId),
  ?OK.

get_pid(GenId)->
  Pid = yyu_ets_cache_dao:get_data(?Ets_TName,GenId),
  Pid.
