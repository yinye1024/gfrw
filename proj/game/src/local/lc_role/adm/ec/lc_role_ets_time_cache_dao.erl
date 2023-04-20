%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_role_ets_time_cache_dao).
-author("yinye").
-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([ets_init/0,is_inited/0]).
-export([get_data/1,put_data/1,remove/1]).
-export([check_and_clean_expired/0]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
%% 一般使用这个就可以了，单进程写，多进程读，针对写少读多的情况。
ets_init() ->
  yyu_ets_time_cache_dao:init(?MODULE),
  ?OK.

is_inited()->
  yyu_ets_time_cache_dao:is_inited(?MODULE).

get_data(RoleId)->
  Data =
  case yyu_ets_time_cache_dao:get_data(?MODULE,RoleId) of
    ?NOT_SET ->?NOT_SET;
    {_ExpiredTime, DataTmp}->
      DataTmp
  end,
  Data.

put_data(LcRole)->
  RoleId = lc_role_pdb_pojo:get_id(LcRole),
  CachedTimeInSecond = 3600,
  yyu_ets_time_cache_dao:put_data(?MODULE,RoleId, LcRole,CachedTimeInSecond),
  ?OK.

remove(RoleId)->
  yyu_ets_time_cache_dao:remove(?MODULE,RoleId),
  ?OK.

check_and_clean_expired()->
  yyu_ets_time_cache_dao:check_and_clean_expired(?MODULE),
  ?OK.





