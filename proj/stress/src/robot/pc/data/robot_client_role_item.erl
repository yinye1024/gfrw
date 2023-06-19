%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(robot_client_role_item).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([new_pojo/1,get_id/1,get_name/1]).
-export([get_tcp_client_gen/1, set_tcp_client_gen/2]).
-export([is_active/1,set_is_active/2]).
-export([get_msg_autoId/1, get_and_incr_msgId/1]).
-export([is_role_created/1,set_is_role_created/2, is_login/1, set_is_login/2]).
-export([get_svr_role_Id/1,set_svr_role_Id/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(UserId)->
  #{
    id => UserId,
    name => "name_"++yyu_misc:to_list(UserId),
    is_role_created => ?FALSE,
    is_login =>?FALSE,

    svr_role_Id => ?NOT_SET  %% 服务端返回的roleId信息
  }.

get_id(ItemMap) ->
  yyu_map:get_value(id, ItemMap).

get_name(ItemMap) ->
  yyu_map:get_value(name, ItemMap).

get_tcp_client_gen(ItemMap) ->
  yyu_map:get_value(tcp_client_gen, ItemMap).

set_tcp_client_gen(Value, ItemMap) ->
  yyu_map:put_value(tcp_client_gen, Value, ItemMap).

is_active(ItemMap) ->
  yyu_map:get_value(is_active, ItemMap).

set_is_active(Value, ItemMap) ->
  yyu_map:put_value(is_active, Value, ItemMap).


get_msg_autoId(ItemMap) ->
  yyu_map:get_value(msg_autoId, ItemMap).

get_and_incr_msgId(ItemMap) ->
  MsgId = get_msg_autoId(ItemMap),
  NextMsgId = ?IF(MsgId+1 > ?MAX_SHORT,1,MsgId+1),  %% 和后端保持一致
  ItemMap_1 = priv_set_msg_autoId(NextMsgId, ItemMap),
  {MsgId,ItemMap_1}.

priv_set_msg_autoId(Value, ItemMap) ->
  yyu_map:put_value(msg_autoId, Value, ItemMap).


is_role_created(ItemMap) ->
  yyu_map:get_value(is_role_created, ItemMap).

set_is_role_created(Value, ItemMap) ->
  yyu_map:put_value(is_role_created, Value, ItemMap).

is_login(ItemMap) ->
  yyu_map:get_value(is_login, ItemMap).

set_is_login(Value, ItemMap) ->
  yyu_map:put_value(is_login, Value, ItemMap).

get_svr_role_Id(ItemMap) ->
  yyu_map:get_value(svr_role_Id, ItemMap).

set_svr_role_Id(Value, ItemMap) ->
  yyu_map:put_value(svr_role_Id, Value, ItemMap).

