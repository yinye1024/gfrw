%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 12. 1月 2023 19:22
%%%-------------------------------------------------------------------
-module(avatar_c2s_handler).
-author("yinye").
-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("protobuf/include/avatar_pb.hrl").

%% API
-export([avatar_head_change_c2s/1,svr_open_time_c2s/1]).

avatar_head_change_c2s(C2SRD = #avatar_head_change_c2s{head_id = HeadId,head_border = HeadBorder})->
  ?LOG_INFO({"avatar_head_change_c2s,",C2SRD}),

  {IsSuccess,HeadId_1,HeadBorder_1} = role_avatar_mgr:do_head_change(HeadId,HeadBorder),
  avatar_s2c_handler:avatar_head_change_s2c(IsSuccess,{HeadId_1,HeadBorder_1}),
  ?OK.
svr_open_time_c2s(C2SRD = #svr_open_time_c2s{})->
  ?LOG_INFO({"svr_open_time_c2s,",C2SRD}),

  SvrOpenTime = game_cfg:svr_OpenSeconds(),
  avatar_s2c_handler:svr_open_time_s2c(SvrOpenTime),
  ?OK.