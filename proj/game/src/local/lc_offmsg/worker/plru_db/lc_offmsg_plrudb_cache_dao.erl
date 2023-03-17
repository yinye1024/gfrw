%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_offmsg_plrudb_cache_dao).
-author("yinye").
-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([proc_init/0]).
-export([get_lru_data/1,put_lru_data/1, check_and_remove_expired/0]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
proc_init()->
  yyu_proc_lru_cache_dao:proc_init(?MODULE,3600),
  ?OK.

get_lru_data(RoleId)->
  Data = yyu_proc_lru_cache_dao:get_lru_data(?MODULE,RoleId),
  Data.

put_lru_data(OffmsgPojo)->
  RoleId = lc_offmsg_pojo:get_id(OffmsgPojo),
  yyu_proc_lru_cache_dao:put_lru_data(?MODULE,RoleId,OffmsgPojo),
  ?OK.

check_and_remove_expired()->
  ExpiredDataMap = yyu_proc_lru_cache_dao:check_and_remove_expired(?MODULE),
  ExpiredDataMap.

