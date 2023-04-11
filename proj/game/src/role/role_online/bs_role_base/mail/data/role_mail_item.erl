%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_mail_item).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([new_pojo/3]).
-export([get_id/1,set_id/2]).
-export([get_type/1, get_send_id/1, get_send_time/1, get_title/1, get_content/1, get_attach_item_list/1]).
-export([on_read/1, is_read/1,on_extract/1,is_extract/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(MailType,{SendId,SendTime},{Title,Content,AttachItemList})->
  #{
    id=>?NOT_SET,         %% 保存到玩家这边的时候才设置Id，也就是MailIndex
    type => MailType,     %% 邮件类型

    send_id => SendId,    %% 发送人id
    send_time => SendTime,%% 发送时间

    title => Title,
    content => Content,   %% 文字内容
    attach_item_list => AttachItemList, %% 附件列表，各种不同的邮件效果由附件体现

    is_read => ?FALSE,
    is_extract =>?FALSE
  }.

on_read(ItemMap)->
  priv_set_is_read(?TRUE,ItemMap).
on_extract(ItemMap)->
  priv_set_is_extract(?TRUE,ItemMap).


get_id(ItemMap) ->
  yyu_map:get_value(id, ItemMap).

set_id(Value, ItemMap) ->
  yyu_map:put_value(id, Value, ItemMap).

get_type(ItemMap) ->
  yyu_map:get_value(type, ItemMap).

get_send_id(ItemMap) ->
  yyu_map:get_value(send_id, ItemMap).

get_send_time(ItemMap) ->
  yyu_map:get_value(send_time, ItemMap).

get_title(ItemMap) ->
  yyu_map:get_value(title, ItemMap).

get_content(ItemMap) ->
  yyu_map:get_value(content, ItemMap).

get_attach_item_list(ItemMap) ->
  yyu_map:get_value(attach_item_list, ItemMap).

is_read(ItemMap) ->
  yyu_map:get_value(is_read, ItemMap).

priv_set_is_read(Value, ItemMap) ->
  yyu_map:put_value(is_read, Value, ItemMap).

is_extract(ItemMap) ->
  yyu_map:get_value(is_extract, ItemMap).

priv_set_is_extract(Value, ItemMap) ->
  yyu_map:put_value(is_extract, Value, ItemMap).

