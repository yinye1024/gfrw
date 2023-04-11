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
-export([friend_apply_list_c2s/1]).

friend_apply_list_c2s(C2SRD = #friend_apply_list_c2s{})->
  ?LOG_INFO({"friend_head_change_c2s,",C2SRD}),

  {IsSuccess,HeadId_1,HeadBorder_1} = role_friend_mgr:do_head_change(HeadId,HeadBorder),
  friend_s2c_handler:friend_head_change_s2c(IsSuccess,{HeadId_1,HeadBorder_1}),
  ?OK.
