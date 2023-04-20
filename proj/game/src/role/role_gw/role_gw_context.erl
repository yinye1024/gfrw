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
    time_out_count=>0,
    last_time_out=>?NOT_SET
  }.

get_roleId(SelfMap)->
  yyu_map:get_value(roleId, SelfMap).
get_ctype(SelfMap) ->
  yyu_map:get_value(ctype, SelfMap).
get_userId(SelfMap) ->
  yyu_map:get_value(userId, SelfMap).
get_svrId(SelfMap) ->
  yyu_map:get_value(svrId, SelfMap).

on_active({UserId,Ticket},SelfMap)->
  SelfMap#{
    userId=>UserId,
    ticket=>Ticket
  }.
on_new_role({NewRoleId},SelfMap)->
  SelfMap#{
    roleId=>NewRoleId
  }.
on_reconnect({SvrId,RoleId},SelfMap)->
  SelfMap#{
    svrId =>SvrId,
    roleId=>RoleId
  }.

on_login({_Platform,_MachineInfo,SvrId,_UserId,_UserName,RoleId},SelfMap)->
  SelfMap#{
    svrId =>SvrId,
    roleId=>RoleId
  }.

is_reach_time_out_max(SelfMap)->
  MaxCount = 5,
  priv_get_time_out_count(SelfMap) > MaxCount.

on_time_out(NowTimeSecond,SelfMap)->
  LastTimeOut = priv_get_last_time_out(SelfMap),
  ResetTime = 60*5,
  SelfMap_1 =
  case LastTimeOut =/= ?NOT_SET andalso NowTimeSecond - LastTimeOut > ResetTime  of
    ?TRUE ->SelfMap#{
              time_out_count=>0,
              last_time_out=>?NOT_SET
            };
    ?FALSE ->
      SelfMapTmp_1 = priv_incr_time_out_count(SelfMap),
      SelfMapTmp_1#{last_time_out=>NowTimeSecond}
  end,
  SelfMap_1.


priv_incr_time_out_count(SelfMap) ->
  Cur = priv_get_time_out_count(SelfMap),
  priv_set_time_out_count(Cur+1, SelfMap).
priv_get_time_out_count(SelfMap) ->
  yyu_map:get_value(time_out_count, SelfMap).
priv_set_time_out_count(Value, SelfMap) ->
  yyu_map:put_value(time_out_count, Value, SelfMap).
priv_get_last_time_out(SelfMap) ->
  yyu_map:get_value(last_time_out, SelfMap).




