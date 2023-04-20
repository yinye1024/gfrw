%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 12. 1月 2023 19:22
%%%-------------------------------------------------------------------
-module(mail_c2s_handler).
-author("yinye").
-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("protobuf/include/mail_pb.hrl").

%% API
-export([mail_list_c2s/1, mail_open_c2s/1,clean_mails_c2s/1]).

mail_list_c2s(C2SRD = #mail_list_c2s{})->
  ?LOG_INFO({"mail_list_c2s,",C2SRD}),

  MailItemList = role_mail_mgr:get_all_mails(),
  PMailInfoList = mail_pbuf_helper:to_p_mailInfo_list(MailItemList),
  mail_s2c_handler:mail_list_s2c(PMailInfoList),
  ?OK.

mail_open_c2s(C2SRD = #mail_open_c2s{mail_id = MailId})->
  ?LOG_INFO({"mail_open_c2s,",C2SRD}),

  ?OK = role_mail_mgr:on_mail_read(MailId),
  mail_s2c_handler:mail_open_s2c(?TRUE),
  ?OK.

clean_mails_c2s(C2SRD = #clean_mails_c2s{})->
  ?LOG_INFO({"clean_mails_c2s,",C2SRD}),
  ?OK = role_mail_mgr:clean_readed_and_extracted(),

  MailItemList = role_mail_mgr:get_all_mails(),
  PMailInfoList = mail_pbuf_helper:to_p_mailInfo_list(MailItemList),
  mail_s2c_handler:mail_list_s2c(PMailInfoList),
  ?OK.
