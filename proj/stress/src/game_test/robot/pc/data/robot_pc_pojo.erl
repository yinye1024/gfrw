%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(robot_pc_pojo).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([new_pojo/1,get_id/1]).
-export([get_client_role_info/1, set_client_role_info/2]).
-export([get_svr_role_info/1,set_svr_role_info/2]).
-export([get_tcp_client_gen/1, set_tcp_client_gen/2]).
-export([is_active/1,set_is_active/2]).
-export([set_client_mid/2,get_and_incr_msgId/1]).
-export([get_svr_mid/1,set_svr_mid/2]).
-export([is_miss_client_pack/1, set_is_miss_client_pack/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(UserId)->
  #{
    id => UserId,
    client_role_info => robot_client_role_item:new_pojo(UserId),
    svr_role_info => ?NOT_SET,
    tcp_client_gen => ?NOT_SET,

    is_active => ?FALSE,        %% 链接是否激活
    client_mid => 1,            %% 发信息自增id
    svr_mid => ?NOT_SET,         %% 收到的服务端mid 补包需要用到

    is_miss_client_pack = ?FALSE    %% 是否开始丢前端包
  }.

get_id(ItemMap) ->
  yyu_map:get_value(id, ItemMap).

get_client_role_info(ItemMap) ->
  yyu_map:get_value(client_role_info, ItemMap).

set_client_role_info(Value, ItemMap) ->
  yyu_map:put_value(client_role_info, Value, ItemMap).

get_svr_role_info(ItemMap) ->
  yyu_map:get_value(svr_role_info, ItemMap).

set_svr_role_info(Value, ItemMap) ->
  yyu_map:put_value(svr_role_info, Value, ItemMap).



get_tcp_client_gen(ItemMap) ->
  yyu_map:get_value(tcp_client_gen, ItemMap).

set_tcp_client_gen(Value, ItemMap) ->
  yyu_map:put_value(tcp_client_gen, Value, ItemMap).

is_active(ItemMap) ->
  yyu_map:get_value(is_active, ItemMap).

set_is_active(Value, ItemMap) ->
  yyu_map:put_value(is_active, Value, ItemMap).


priv_get_client_mid(ItemMap) ->
  yyu_map:get_value(client_mid, ItemMap).

get_and_incr_msgId(ItemMap) ->
  MsgId = priv_get_client_mid(ItemMap),
  NextMsgId = ?IF(MsgId+1 > ?MAX_SHORT,1,MsgId+1),  %% 和后端保持一致
  ItemMap_1 = set_client_mid(NextMsgId, ItemMap),
  {MsgId,ItemMap_1}.

set_client_mid(Value, ItemMap) ->
  yyu_map:put_value(client_mid, Value, ItemMap).

get_svr_mid(ItemMap) ->
  yyu_map:get_value(svr_mid, ItemMap).

set_svr_mid(Value, ItemMap) ->
  yyu_map:put_value(svr_mid, Value, ItemMap).

is_miss_client_pack(ItemMap) ->
  yyu_map:get_value(is_miss_client_pack, ItemMap).

set_is_miss_client_pack(Value, ItemMap) ->
  yyu_map:put_value(is_miss_client_pack, Value, ItemMap).

