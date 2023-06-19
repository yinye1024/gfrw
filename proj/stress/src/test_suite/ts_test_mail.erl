%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 23. 2月 2023 15:40
%%%-------------------------------------------------------------------
-module(ts_test_mail).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("game_proto/include/mail_pb.hrl").

%% API
-export([do_test/0]).
%% ts_test_mail:do_test().
do_test()->
  UserId = 1023,
  RobotGenA = ts_helper:new_robot(UserId),
  yyu_time:sleep(1000),

  priv_gm_send_mail(UserId),

  MailList = priv_get_mailList(UserId),
  UnReadPMail = yyu_list:filter_one(fun(PMail) -> not PMail#p_mailInfo.is_read end,MailList),
  UnReadPMaiId = UnReadPMail#p_mailInfo.id,


  s2s_robot_mgr:cast_do_fun(UserId,{fun robot_mail_mgr:mail_open_c2s/1, [UnReadPMaiId]}),
  yyu_time:sleep(1000),

  MailList_1 = priv_get_mailList(UserId),
  LastPMail = yyu_list:filter_one(fun(PMail) -> PMail#p_mailInfo.id==UnReadPMaiId end,MailList_1),

  yyu_error:assert_true(LastPMail#p_mailInfo.is_read,"the mail should be marked readed"),
  ?OK.

priv_gm_send_mail(UserId)->
  UserRoleId = s2s_robot_mgr:get_roleId(UserId),
  StrCmd = "add_mail,"++yyu_misc:to_list(UserRoleId)++",1,\"Title_1\",\"Content\",\"attachment\"",
  s2s_robot_mgr:cast_do_fun(UserId,{fun robot_gm_mgr:gm_cmd_c2s/1, [StrCmd]}),
  yyu_time:sleep(1000),
  ?OK.


priv_get_mailList(UserId)->
  s2s_robot_mgr:cast_do_fun(UserId,{fun robot_mail_mgr:mail_list_c2s/0, []}),
  yyu_time:sleep(1000),
  MailData = s2s_robot_mgr:call_do_fun(UserId, {fun robot_mail_mgr:get_data/0, []}),
  MailList = robot_mail_data:get_mail_list(MailData),
  MailList.



