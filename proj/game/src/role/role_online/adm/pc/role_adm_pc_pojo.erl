%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_adm_pc_pojo).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([new_pojo/2,get_id/1]).
-export([get_tcp_gen/1,set_tcp_gen/2]).
-export([get_roleId/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(DataId, {RoleId,TcpGen})->
  #{
    id => DataId,
    roleId => RoleId,
    tcp_gen => TcpGen
  }.

get_id(SelfMap) ->
  yyu_map:get_value(id, SelfMap).

get_roleId(SelfMap) ->
  yyu_map:get_value(roleId, SelfMap).

get_tcp_gen(SelfMap) ->
  yyu_map:get_value(tcp_gen, SelfMap).
set_tcp_gen(TcpGen,SelfMap) ->
  yyu_map:put_value(tcp_gen,TcpGen, SelfMap).




