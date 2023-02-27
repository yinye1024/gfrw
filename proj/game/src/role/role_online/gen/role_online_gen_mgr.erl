%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_online_gen_mgr).
-author("yinye").


-include_lib("yyutils/include/yyu_comm.hrl").
-define(ETS_CACHE_ID,?MODULE).

%% API functions defined
-export([init/0,reg/2,un_reg/1,get_pid/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init()->
  case yyu_ets_cache_dao:is_inited(?ETS_CACHE_ID) of
    ?FALSE ->
      yyu_ets_cache_dao:init(?ETS_CACHE_ID),
      ?OK;
    ?TRUE->?OK
  end,
  ?OK.

reg(RoleId,RoleGen)->
  yyu_ets_cache_dao:put_data(?ETS_CACHE_ID,RoleId,RoleGen),
  ?OK.

un_reg(RoleId)->
  yyu_ets_cache_dao:remove(?ETS_CACHE_ID,RoleId),
  ?OK.

get_pid(RoleId)->
  Pid = yyu_ets_cache_dao:get_data(?ETS_CACHE_ID,RoleId),
  Pid.
