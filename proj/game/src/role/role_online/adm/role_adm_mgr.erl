%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_adm_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([init/1]).
-export([get_tcp_gen/0, switch_tcp_gen/1]).
-export([get_roleId/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init({RoleId,TcpGen}) when is_integer(RoleId)->
  role_adm_pc_dao:init({RoleId,TcpGen}),
  ?OK.

get_roleId()->
  Data = priv_get_data(),
  RoleId = role_adm_pc_pojo:get_roleId(Data),
  RoleId.

get_tcp_gen()->
  Data = priv_get_data(),
  TcpGen = role_adm_pc_pojo:get_tcp_gen(Data),
  TcpGen.


switch_tcp_gen(TcpGen)->
  Data = priv_get_data(),
  %% 先关闭当前网关进程，再添加新网关进程
  CurTcpGen = role_adm_pc_pojo:get_tcp_gen(Data),
  case yyu_pid:is_local_alive(CurTcpGen) of
    ?TRUE ->
      yynw_tcp_gw_api:cast_stop(CurTcpGen),
      ?OK;
    _->?OK
  end,
  NewData = role_adm_pc_pojo:set_tcp_gen(TcpGen,Data),
  priv_update(NewData).

priv_get_data()->
  Data =role_adm_pc_dao:get_data(),
  Data.
priv_update(Data)->
  role_adm_pc_dao:put_data(Data),
  ?OK.



