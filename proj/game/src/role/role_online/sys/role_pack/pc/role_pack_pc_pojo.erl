%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_pack_pc_pojo).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([new_pojo/1,get_id/1]).
-export([get_recv_pack_id/1,set_recv_pack_id/2, get_pack_queue/1,set_pack_queue/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(DataId)->
  #{
    id => DataId,
    recv_pack_id => 0,
    pack_queue => {[],[]}
  }.

get_id(SelfMap) ->
  yyu_map:get_value(id, SelfMap).


get_recv_pack_id(SelfMap) ->
  yyu_map:get_value(recv_pack_id, SelfMap).

set_recv_pack_id(Value, SelfMap) ->
  yyu_map:put_value(recv_pack_id, Value, SelfMap).

get_pack_queue(SelfMap) ->
  yyu_map:get_value(pack_queue, SelfMap).

set_pack_queue(Value, SelfMap) ->
  yyu_map:put_value(pack_queue, Value, SelfMap).

