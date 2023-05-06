%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 12. 1月 2023 19:22
%%%-------------------------------------------------------------------
-module(prop_pbuf_helper).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("protobuf/include/prop_pb.hrl").
%% API
-export([to_p_propInfo_list/1]).

%% ApplyItem lc_prop_apply_item
to_p_propInfo_list(MailItemList)->
  PMailInfoList = yyu_list:map(fun(MailItem) -> priv_to_p_propInfo(MailItem) end, MailItemList),
  PMailInfoList.

priv_to_p_propInfo(_MailItem)->
%%  #p_propInfo{
%%    id = role_prop_item:get_id(MailItem),
%%    type = role_prop_item:get_type(MailItem),
%%    title = role_prop_item:get_title(MailItem),
%%    content = role_prop_item:get_content(MailItem),
%%    is_read = role_prop_item:is_read(MailItem),
%%    is_extract = role_prop_item:is_extract(MailItem)
%%    }.
  ?OK.







