%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 23. 2月 2023 15:40
%%%-------------------------------------------------------------------
-module(ts_test_prop).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("game_proto/include/mail_pb.hrl").

%% API
-export([do_test/0]).
%% ts_test_prop:do_test().
do_test()->
  UserId = 1023,
  ts_helper:new_robot(UserId),
  yyu_time:sleep(1000),

  {PropKey,PropValue}={101,97},
  priv_gm_set_prop_attr(UserId,PropKey,PropValue),

  PropMap = priv_get_propMap(UserId),

  yyu_error:assert_true(yyu_map:get_value(PropKey,PropMap)==PropValue,{"value not correct",{PropKey,PropValue}}),
  ?OK.

priv_gm_set_prop_attr(UserId,AttrKey,AttrValue)->
  StrCmd = "set_role_prop_item,"++yyu_misc:to_list(AttrKey)++","++yyu_misc:to_list(AttrValue)++"",
  s2s_robot_mgr:cast_do_fun(UserId,{fun robot_gm_mgr:gm_cmd_c2s/1, [StrCmd]}),
  yyu_time:sleep(1000),
  ?OK.


priv_get_propMap(UserId)->
  s2s_robot_mgr:cast_do_fun(UserId,{fun robot_prop_mgr:role_prop_player_c2s/0, []}),
  yyu_time:sleep(1000),
  PropData = s2s_robot_mgr:call_do_fun(UserId, {fun robot_prop_mgr:get_data/0, []}),
  PropMap = robot_prop_data:get_prop_map(PropData),
  PropMap.



