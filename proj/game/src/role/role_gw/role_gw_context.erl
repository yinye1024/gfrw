%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_gw_context).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([new/0]).
-export([on_active/2,on_new_role/2,on_reconnect/2,on_login/2,on_time_out/2]).
-export([get_ctype/1,get_roleId/1,get_userId/1,get_svrId/1]).
-export([is_reach_time_out_max/1]).
-export([]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new()->
  #{
    userId=>?NOT_SET,
    ticket=>?NOT_SET,

    svrId =>?NOT_SET,
    roleId=>?NOT_SET,
    userId =>?NOT_SET,
    time_out_count=>0,
    last_time_out=>?NOT_SET
  }.

get_roleId(ItemMap)->
  yyu_map:get_value(roleId, ItemMap).
get_ctype(ItemMap) ->
  yyu_map:get_value(ctype, ItemMap).
get_userId(ItemMap) ->
  yyu_map:get_value(userId, ItemMap).
get_svrId(ItemMap) ->
  yyu_map:get_value(svrId, ItemMap).

on_active({UserId,Ticket},ItemMap)->
  ItemMap#{
    userId=>UserId,
    ticket=>Ticket
  }.
on_new_role({NewRoleId},ItemMap)->
  ItemMap#{
    roleId=>NewRoleId
  }.
on_reconnect({SvrId,RoleId},ItemMap)->
  ItemMap#{
    svrId =>SvrId,
    roleId=>RoleId
  }.

on_login({Platform,MachineInfo,SvrId,UserId,UserName,RoleId},ItemMap)->
  ItemMap#{
    svrId =>SvrId,
    roleId=>RoleId
  }.

is_reach_time_out_max(ItemMap)->
  MaxCount = 5,
  priv_get_time_out_count(ItemMap) > MaxCount.

on_time_out(NowTimeSecond,ItemMap)->
  LastTimeOut = priv_get_last_time_out(ItemMap),
  ResetTime = 60*5,
  ItemMap_1 =
  case LastTimeOut =/= ?NOT_SET andalso NowTimeSecond - LastTimeOut > ResetTime  of
    ?TRUE ->ItemMap#{
              time_out_count=>0,
              last_time_out=>?NOT_SET
            };
    ?FALSE ->
      ItemMapTmp_1 = priv_incr_time_out_count(ItemMap),
      ItemMapTmp_1#{last_time_out=>NowTimeSecond}
  end,
  ItemMap_1.


priv_incr_time_out_count(ItemMap) ->
  Cur = priv_get_time_out_count(ItemMap),
  priv_set_time_out_count(Cur+1, ItemMap).
priv_get_time_out_count(ItemMap) ->
  yyu_map:get_value(time_out_count, ItemMap).
priv_set_time_out_count(Value, ItemMap) ->
  yyu_map:put_value(time_out_count, Value, ItemMap).
priv_get_last_time_out(ItemMap) ->
  yyu_map:get_value(last_time_out, ItemMap).




