%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_gw_pc_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([init/0]).
-export([check_client_mid/1, set_client_mid/1]).
-export([get_role_gen/0, set_role_gen/1]).
-export([is_max_heartbeat_time_out/0, on_receive_heartbeat/0,check_heartbeat/0]).
-export([get_context/0,set_context/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init()->
  role_gw_pc_dao:init(),
  ?OK.

check_client_mid(ClientMid)->
  Data = priv_get_data(),
  Mid = role_gw_pc_pojo:get_client_mid(Data),
%%  ?LOG_INFO({"route msg old Mid ++++++++++++ ",Mid}),
  IsSuccess =
  case Mid of
    ?NOT_SET -> ?TRUE;
    ClientMid -> ?TRUE;
    _Other -> ?FALSE
  end,
  IsSuccess.

set_client_mid(ClientMid)->
  NewMid =
    case ClientMid < ?MAX_SHORT of %% 与前端对好mid循环使用的规则
      ?TRUE -> ClientMid +1;
      ?FALSE -> 1
    end,

  Data = role_gw_pc_dao:get_data(),
  NewData = role_gw_pc_pojo:set_client_mid(NewMid,Data),
  priv_update(NewData).

get_role_gen()->
  Data = priv_get_data(),
  RoleGen = role_gw_pc_pojo:get_role_gen(Data),
  RoleGen.

set_role_gen(RoleGen)->
  Data = role_gw_pc_dao:get_data(),
  NewData = role_gw_pc_pojo:set_role_gen(RoleGen,Data),
  priv_update(NewData).

get_context()->
  Data = priv_get_data(),
  Context = role_gw_pc_pojo:get_context(Data),
  Context.

set_context(Context)->
  Data = role_gw_pc_dao:get_data(),
  NewData = role_gw_pc_pojo:set_context(Context,Data),
  priv_update(NewData).

is_max_heartbeat_time_out()->
  Data = priv_get_data(),
  RoleGen = role_gw_pc_pojo:is_max_heartbeat_time_out(Data),
  RoleGen.

on_receive_heartbeat()->
  Data = role_gw_pc_dao:get_data(),
  NowTimeSecond = yyu_time:now_seconds(),
  NewData = role_gw_pc_pojo:on_heartbeat(NowTimeSecond,Data),
  priv_update(NewData).

check_heartbeat()->
  Data = role_gw_pc_dao:get_data(),
  NowTimeSecond = yyu_time:now_seconds(),
  NewData = role_gw_pc_pojo:check_heartbeat(NowTimeSecond,Data),
  priv_update(NewData).

priv_get_data()->
  Data = role_gw_pc_dao:get_data(),
  Data.

priv_update(Data)->
  role_gw_pc_dao:put_data(Data),
  ?OK.




