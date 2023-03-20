%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(tpl_multi_pc_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([init/1]).
-export([get_multiId/0]).
-export([get_last_req/0,update_last_req/0]).
-export([tick/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init(MultiId)->
  tpl_multi_pc_dao:init(MultiId),
  ?OK.

get_multiId()->
  Data = tpl_multi_pc_dao:get_data(),
  tpl_multi_pc_pojo:get_multiId(Data).


get_last_req()->
  Data = tpl_multi_pc_dao:get_data(),
  WorkData = tpl_multi_pc_pojo:get_last_req(Data),
  WorkData.

%% 更新最后一次请求时间，超过时间没有请求，自动退出进程
update_last_req()->
  Data = tpl_multi_pc_dao:get_data(),
  NewData = tpl_multi_pc_pojo:set_last_req(yyu_time:now_seconds(),Data),
  tpl_multi_pc_dao:put_data(NewData),
  ?OK.

tick()->
  ?OK.


