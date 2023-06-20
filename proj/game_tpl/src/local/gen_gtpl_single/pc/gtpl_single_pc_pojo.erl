%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(gtpl_single_pc_pojo).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([new_pojo/2,get_id/1,get_singleId/1]).
-export([get_last_req/1,set_last_req/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(DataId, SingleId)->
  #{
    id => DataId,
    singleId=>SingleId,
    last_req => yyu_time:now_seconds()    %% 上一次请求时间
  }.

get_id(ItemMap) ->
  yyu_map:get_value(id, ItemMap).

get_singleId(ItemMap) ->
  yyu_map:get_value(singleId, ItemMap).

get_last_req(ItemMap) ->
  yyu_map:get_value(last_req, ItemMap).

set_last_req(Value, ItemMap) ->
  yyu_map:put_value(last_req, Value, ItemMap).

