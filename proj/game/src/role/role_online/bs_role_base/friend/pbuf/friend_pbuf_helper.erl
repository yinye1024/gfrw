%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 12. 1月 2023 19:22
%%%-------------------------------------------------------------------
-module(friend_pbuf_helper).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("protobuf/include/friend_pb.hrl").
%% API
-export([to_p_applyInfo_list/1, to_p_friendInfo_list/1]).

%% ApplyItem lc_friend_apply_item
to_p_applyInfo_list(ApplyList)->
  PApplyInfoList = yyu_list:map(fun(ApplyItem) -> priv_to_p_applyInfo(ApplyItem) end,ApplyList),
  PApplyInfoList.

priv_to_p_applyInfo(ApplyItem)->
  Gender = lc_friend_apply_item:get_gender(ApplyItem),
  #p_applyInfo{
    id = lc_friend_apply_item:get_index(ApplyItem),
    role_id =  lc_friend_apply_item:get_roleId(ApplyItem),
    name =   lc_friend_apply_item:get_roleName(ApplyItem),
    gender = ?IF(Gender =/= ?NOT_SET,Gender,?UNDEFINED)
  }.

to_p_friendInfo_list(LcRoleList)->
  PFriendInfoList = yyu_list:map(fun(LcRole) -> priv_to_p_friendInfo(LcRole) end,LcRoleList),
  PFriendInfoList.

priv_to_p_friendInfo(LcRole)->
  #p_friendInfo{
    role_id = lc_role_pdb_pojo:get_id(LcRole),
    gender =  lc_role_pdb_pojo:get_gender(LcRole),
    name =   lc_role_pdb_pojo:get_name(LcRole)
  }.








