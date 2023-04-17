%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_friend_ets_time_cache_dao).
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

get_data(FriendId)->
  Data =
  case yyu_ets_time_cache_dao:get_data(?MODULE,FriendId) of
    ?NOT_SET ->?NOT_SET;
    {ExpiredTime, DataTmp}->
      DataTmp_1 =
        case ExpiredTime < yyu_time:now_seconds()of
          ?TRUE ->
            ?NOT_SET;
          ?FALSE ->DataTmp
        end,
      DataTmp_1
  end,
  Data.

put_data(GlbFriend)->
  FriendId = lc_friend_pdb_pojo:get_id(GlbFriend),
  CachedTimeInSecond = 3600,
  yyu_ets_time_cache_dao:put_data(?MODULE,FriendId, GlbFriend,CachedTimeInSecond),
  ?OK.

remove(FriendId)->
  yyu_ets_time_cache_dao:remove(?MODULE,FriendId),
  ?OK.

check_and_clean_expired()->
  yyu_ets_time_cache_dao:check_and_clean_expired(?MODULE),
  ?OK.





