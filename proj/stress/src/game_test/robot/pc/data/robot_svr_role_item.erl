%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(robot_svr_role_item).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("protobuf/include/login_pb.hrl").

%% API functions defined
-export([new_pojo/1]).
-export([get_role_id/1, get_name/1, get_level/1,get_exp/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(_PRoleInfo = #p_roleInfo{role_id = RoleId,name = Name,level = Level,exp = Exp} )->
  #{
    role_id => RoleId,
    name => Name,
    level => Level,
    exp => Exp
  }.

get_role_id(ItemMap) ->
  yyu_map:get_value(role_id, ItemMap).

get_name(ItemMap) ->
  yyu_map:get_value(name, ItemMap).

get_level(ItemMap) ->
  yyu_map:get_value(level, ItemMap).

get_exp(ItemMap) ->
  yyu_map:get_value(exp, ItemMap).
