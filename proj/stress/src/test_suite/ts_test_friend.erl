%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 23. 2月 2023 15:40
%%%-------------------------------------------------------------------
-module(ts_test_friend).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("game_proto/include/friend_pb.hrl").

%% API
-export([do_test/0]).
%% ts_test_friend:do_test().
do_test()->
  UserA = 1023,
  UserB = 1024,
  RobotGenA = ts_helper:new_robot(UserA),
  RobotGenB = ts_helper:new_robot(UserB),
  priv_add_friend(UserA,UserB),
  ?OK.


priv_add_friend(UserId, FriendUid)->
  yyu_time:sleep(1000),
  UserRoleId = s2s_robot_mgr:get_roleId(UserId),
  FriendRoleId = s2s_robot_mgr:get_roleId(FriendUid),

  %%申请加好友
  s2s_robot_mgr:cast_do_fun(UserId,{fun robot_friend_mgr:friend_new_apply_c2s/1, [FriendRoleId]}),
  yyu_time:sleep(1000),

  %% 获取申请列表
  s2s_robot_mgr:cast_do_fun(FriendUid,{fun robot_friend_mgr:friend_apply_list_c2s/0, []}),
  yyu_time:sleep(1000),

  %% 同意好友申请
  ApplyId = priv_get_applyId(FriendUid,UserRoleId),
  s2s_robot_mgr:cast_do_fun(FriendUid,{fun robot_friend_mgr:friend_handle_apply_c2s/2, [ApplyId,?TRUE]}),
  ?LOG_INFO({"11111111111111111111111111"}),
  yyu_time:sleep(1000),

  ?LOG_INFO({"11111111111111111111111122"}),
  %% 获取好友列表
  s2s_robot_mgr:cast_do_fun(FriendUid,{fun robot_friend_mgr:friend_list_c2s/0, []}),
  yyu_time:sleep(1000),
  FriendItem = priv_get_friend(FriendUid, UserRoleId),
  yyu_error:assert_true(FriendItem =/= ?NOT_SET,"添加好友失败"),
  ?OK.

priv_get_applyId(FriendUid, ApplyRoleId) ->
  FriendData = s2s_robot_mgr:call_do_fun(FriendUid, {fun robot_friend_mgr:get_data/0, []}),
  ApplyList = robot_friend_data:get_apply_list(FriendData),
  yyu_list:filter(fun(ApplyItem) -> ApplyItem#p_applyInfo.role_id == ApplyRoleId end,ApplyList),
  ApplyId = priv_get_applyId_from(ApplyList, ApplyRoleId),
  ApplyId.
priv_get_applyId_from([ApplyItem|Less], ApplyUid)->
  case ApplyItem#p_applyInfo.role_id of
    ApplyUid -> ApplyItem#p_applyInfo.id;
    _-> priv_get_applyId_from(Less, ApplyUid)
  end;
priv_get_applyId_from([],_ApplyRobotGen)->?NOT_SET.

priv_get_friend(UserId, FriendRoleId) ->
  FriendData = s2s_robot_mgr:call_do_fun(UserId, {fun robot_friend_mgr:get_data/0, []}),
  FriendList = robot_friend_data:get_friend_list(FriendData),
  FriendItem = priv_get_friend_from(FriendList, FriendRoleId),
  FriendItem.
priv_get_friend_from([FriendItem |Less], FriendRoleId)->
  case FriendItem#p_friendInfo.role_id of
    FriendRoleId -> FriendItem;
    _-> priv_get_friend_from(Less, FriendRoleId)
  end;
priv_get_friend_from([],_ApplyRobotGen)->?NOT_SET.
