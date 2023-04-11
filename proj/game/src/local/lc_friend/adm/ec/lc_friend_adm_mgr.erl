%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_friend_adm_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([proc_init/0, check_and_clean_expired/0]).
-export([get_data/1, update_if_in_cache/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
proc_init()->
  lc_friend_ets_time_cache_dao:proc_init(),
  ?OK.

check_and_clean_expired()->
  lc_friend_ets_time_cache_dao:check_and_clean_expired(),
  ?OK.

get_data(RoleId)->
  Data =
  case lc_friend_ets_time_cache_dao:get_data(RoleId) of
    ?NOT_SET ->
      case lc_friend_pdb_dao:get_data(RoleId) of
        ?NOT_SET ->
          ?NOT_SET;
        FriendPdbPojo ->
          lc_friend_ets_time_cache_dao:put_data(FriendPdbPojo),
          FriendPdbPojo
      end;
    DataTmp ->
      DataTmp
  end,
  Data.


update_if_in_cache(FriendPdbPojo)->
  RoleId = lc_friend_pdb_pojo:get_id(FriendPdbPojo),
  case lc_friend_ets_time_cache_dao:get_data(RoleId) of
    ?NOT_SET ->?OK;
    _DataTmp ->
      lc_friend_ets_time_cache_dao:put_data(FriendPdbPojo),
      ?OK
  end,
  ?OK.

