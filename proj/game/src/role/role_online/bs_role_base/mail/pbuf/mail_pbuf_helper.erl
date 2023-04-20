%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 12. 1月 2023 19:22
%%%-------------------------------------------------------------------
-module(mail_pbuf_helper).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("protobuf/include/mail_pb.hrl").
%% API
-export([to_p_mailInfo_list/1]).

%% ApplyItem lc_mail_apply_item
to_p_mailInfo_list(MailItemList)->
  PMailInfoList = yyu_list:map(fun(MailItem) -> priv_to_p_mailInfo(MailItem) end, MailItemList),
  PMailInfoList.

priv_to_p_mailInfo(MailItem)->
  #p_mailInfo{
    id = role_mail_item:get_id(MailItem),
    type = role_mail_item:get_type(MailItem),
    title = role_mail_item:get_title(MailItem),
    content = role_mail_item:get_content(MailItem),
    is_read = role_mail_item:is_read(MailItem),
    is_extract = role_mail_item:is_extract(MailItem)
    }.







