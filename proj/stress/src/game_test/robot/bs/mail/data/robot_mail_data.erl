%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(robot_mail_data).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([new_pojo/0]).
-export([get_apply_list/1,set_apply_list/2]).
-export([get_mail_list/1,set_mail_list/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo()->
  #{
    apply_list => [],
    mail_list => []
  }.

get_apply_list(ItemMap) ->
  yyu_map:get_value(apply_list, ItemMap).

set_apply_list(Value, ItemMap) ->
  yyu_map:put_value(apply_list, Value, ItemMap).


get_mail_list(ItemMap) ->
  yyu_map:get_value(mail_list, ItemMap).

set_mail_list(Value, ItemMap) ->
  yyu_map:put_value(mail_list, Value, ItemMap).

