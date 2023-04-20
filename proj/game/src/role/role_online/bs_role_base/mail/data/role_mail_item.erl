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
-export([get_type/1, get_from_id/1, get_send_time/1, get_title/1, get_content/1, get_attach_item_list/1]).
-export([on_read/1, is_read/1,on_extract/1,is_extract/1]).
-export([is_started/2,set_start_time/2,is_expired/2,set_end_time/2]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(MailType,{FromId,SendTime},{Title,Content,AttachItemList})->
  #{
    id=>?NOT_SET,         %% 保存到玩家这边的时候才设置Id，也就是MailIndex
    type => MailType,     %% 邮件类型

    from_id => FromId,    %% 发送人id
    send_time => SendTime,%% 发送时间

    title => Title,
    content => Content,   %% 文字内容
    attach_item_list => AttachItemList, %% 附件列表，各种不同的邮件效果由附件体现

    is_read => ?FALSE,
    is_extract =>?FALSE,

    start_time => ?NOT_SET,  %% 生效时间
    end_time => ?NOT_SET     %% 失效时间
  }.

on_read(SelfMap)->
  priv_set_is_read(?TRUE,SelfMap).
on_extract(SelfMap)->
  priv_set_is_extract(?TRUE,SelfMap).


get_id(SelfMap) ->
  yyu_map:get_value(id, SelfMap).

set_id(Value, SelfMap) ->
  yyu_map:put_value(id, Value, SelfMap).

get_type(SelfMap) ->
  yyu_map:get_value(type, SelfMap).

get_from_id(SelfMap) ->
  yyu_map:get_value(from_id, SelfMap).

get_send_time(SelfMap) ->
  yyu_map:get_value(send_time, SelfMap).

get_title(SelfMap) ->
  yyu_map:get_value(title, SelfMap).

get_content(SelfMap) ->
  yyu_map:get_value(content, SelfMap).

get_attach_item_list(SelfMap) ->
  yyu_map:get_value(attach_item_list, SelfMap).

is_read(SelfMap) ->
  yyu_map:get_value(is_read, SelfMap).

priv_set_is_read(Value, SelfMap) ->
  yyu_map:put_value(is_read, Value, SelfMap).

is_extract(SelfMap) ->
  yyu_map:get_value(is_extract, SelfMap).

priv_set_is_extract(Value, SelfMap) ->
  yyu_map:put_value(is_extract, Value, SelfMap).

is_started(NowTime,SelfMap)->
  case priv_get_start_time(SelfMap) of
    ?NOT_SET -> ?TRUE;
    StartTime -> StartTime > NowTime
  end.

priv_get_start_time(SelfMap) ->
  yyu_map:get_value(start_time, SelfMap).

set_start_time(Value, SelfMap) ->
  yyu_map:put_value(start_time, Value, SelfMap).

is_expired(NowTime,SelfMap)->
  EndTime = priv_get_end_time(SelfMap),
  EndTime =/= ?NOT_SET andalso EndTime > NowTime.

priv_get_end_time(SelfMap) ->
  yyu_map:get_value(end_time, SelfMap).

set_end_time(Value, SelfMap) ->
  yyu_map:put_value(end_time, Value, SelfMap).

