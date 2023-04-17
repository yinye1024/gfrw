%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(robot_gen_mgr).
-author("yinye").


-include_lib("yyutils/include/yyu_comm.hrl").
-define(ETS_CACHE_ID,?MODULE).

%% API functions defined
-export([ets_init/0,reg/2,un_reg/1,get_pid/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
ets_init()->
  case yyu_ets_cache_dao:is_inited(?ETS_CACHE_ID) of
    ?FALSE ->
      yyu_ets_cache_dao:init(?ETS_CACHE_ID),
      ?OK;
    ?TRUE->?OK
  end,
  ?OK.

reg(UserId,RoleGen)->
  yyu_ets_cache_dao:put_data(?ETS_CACHE_ID,UserId,RoleGen),
  ?OK.

un_reg(UserId)->
  yyu_ets_cache_dao:remove(?ETS_CACHE_ID,UserId),
  ?OK.

get_pid(UserId)->
  Pid = yyu_ets_cache_dao:get_data(?ETS_CACHE_ID,UserId),
  Pid.
