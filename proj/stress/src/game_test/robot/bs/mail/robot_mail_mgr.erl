%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(robot_mail_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([mail_list_c2s/0,mail_list_s2c/1]).
-export([mail_open_c2s/1,mail_open_s2c/1]).
-export([get_data/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
mail_list_c2s() ->
  robot_mail_c2s_sender:mail_list_c2s(),
  ?OK.
mail_list_s2c(BinData)->
  robot_mail_s2c_handler:mail_list_s2c(BinData),
  ?OK.

mail_open_c2s(MailId) ->
  robot_mail_c2s_sender:mail_open_c2s(MailId),
  ?OK.
mail_open_s2c(BinData)->
  robot_mail_s2c_handler:mail_open_s2c(BinData),
  ?OK.


get_data()->
  robot_mail_data_mgr:get_data().
