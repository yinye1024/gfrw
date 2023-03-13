%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(tpl_single_pc_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([init/1]).
-export([get_singleId/0]).
-export([get_last_req/0,update_last_req/0,tick/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init(SingleId)->
  tpl_single_pc_dao:init(SingleId),
  ?OK.

get_singleId()->
  Data = tpl_single_pc_dao:get_data(),
  tpl_single_pc_pojo:get_singleId(Data).


get_last_req()->
  Data = tpl_single_pc_dao:get_data(),
  WorkData = tpl_single_pc_pojo:get_last_req(Data),
  WorkData.

%% 更新最后一次请求时间，超过时间没有请求，自动退出进程
update_last_req()->
  Data = tpl_single_pc_dao:get_data(),
  NewData = tpl_single_pc_pojo:set_last_req(yyu_time:now_seconds(),Data),
  tpl_single_pc_dao:put_data(NewData),
  ?OK.

tick()->
  ?OK.


