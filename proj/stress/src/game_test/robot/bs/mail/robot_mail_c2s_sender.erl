%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(robot_mail_c2s_sender).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("protobuf/include/mail_pb.hrl").
-include_lib("protobuf/include/cmd_map.hrl").

%% API functions defined
-export([mail_list_c2s/0,mail_open_c2s/1]).


%% ===================================================================================
%% API functions implements
%% ===================================================================================


mail_list_c2s() ->
  Record = #mail_list_c2s{},

  BinData = mail_pb:encode_msg(Record),
  {C2SId,BinData} = {?MAIL_LIST_C2S,BinData},
  ?LOG_INFO({"send mail_list_c2s ++++++++++++++"}),
  robot_pc_mgr:send_msg({C2SId,BinData}),
  ?OK.

mail_open_c2s(MailId) ->
  Record = #mail_open_c2s{mail_id = MailId},
  BinData = mail_pb:encode_msg(Record),
  {C2SId,BinData} = {?MAIL_OPEN_C2S,BinData},
  ?LOG_INFO({"send mail_list_c2s ++++++++++++++"}),
  robot_pc_mgr:send_msg({C2SId,BinData}),
  ?OK.

