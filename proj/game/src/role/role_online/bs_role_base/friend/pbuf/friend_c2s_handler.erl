%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 12. 1月 2023 19:22
%%%-------------------------------------------------------------------
-module(friend_c2s_handler).
-author("yinye").
-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("protobuf/include/friend_pb.hrl").

%% API
-export([friend_apply_list_c2s/1,friend_new_apply_c2s/1,friend_handle_apply_c2s/1,friend_list_c2s/1]).

friend_apply_list_c2s(C2SRD = #friend_apply_list_c2s{})->
  ?LOG_INFO({"friend_apply_list_c2s,",C2SRD}),

  ApplyList = role_friend_mgr:get_all_apply(),
  PApplyInfoList = friend_pbuf_helper:to_p_applyInfo_list(ApplyList),
  friend_s2c_handler:friend_apply_list_s2c(PApplyInfoList),
  ?OK.

friend_new_apply_c2s(C2SRD = #friend_new_apply_c2s{friend_uid = FriendRoleId})->
  ?LOG_INFO({"friend_new_apply_c2s,",C2SRD}),
  ?OK = role_friend_mgr:new_apply(FriendRoleId),
  friend_s2c_handler:friend_new_apply_s2c(?TRUE),
  ?OK.

friend_handle_apply_c2s(C2SRD = #friend_handle_apply_c2s{apply_id = ApplyId,is_accept = IsAccept})->
  ?LOG_INFO({"friend_handle_apply_c2s,",C2SRD}),
  ?OK = role_friend_mgr:handle_apply(ApplyId,IsAccept),
  friend_s2c_handler:friend_handle_apply_s2c(?TRUE),
  ?OK.

friend_list_c2s(C2SRD = #friend_list_c2s{})->
  ?LOG_INFO({"friend_list_c2s,",C2SRD}),
  LcRoleList = role_friend_mgr:get_friendList(),
  PFriendInfoList = friend_pbuf_helper:to_p_friendInfo_list(LcRoleList),
  friend_s2c_handler:friend_list_s2c(PFriendInfoList),
  ?OK.
