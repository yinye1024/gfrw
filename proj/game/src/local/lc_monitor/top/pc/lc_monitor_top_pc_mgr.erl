%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_monitor_top_pc_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([proc_init/0]).
-export([put_PidTopInfo/1,rm_PidTopInfo/1,is_in_data/1, get_PidItemMap/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
proc_init()->
  lc_monitor_top_pc_dao:init(),
  ?OK.

put_PidTopInfo(PidTopInfoList)->
  Data = priv_get_data(),
  Data_1 = priv_put_PidTopInfo(PidTopInfoList, Data),
  priv_update(Data_1).
priv_put_PidTopInfo([{Pid,MsgQueueLen,MemBytes,Reds,CurFun,CurStk}|Less], AccData)->
  AccData_1 = lc_monitor_top_pc_pojo:put_PidTopInfo(Pid,{MsgQueueLen,MemBytes,Reds,CurFun,CurStk}, AccData),
  priv_put_PidTopInfo(Less, AccData_1);
priv_put_PidTopInfo([], AccData)->
  AccData.

rm_PidTopInfo(PidList)->
  Data = priv_get_data(),
  Data_1 = priv_rm_PidTopInfo(PidList, Data),
  priv_update(Data_1).
priv_rm_PidTopInfo([Pid|Less], AccData)->
  AccData_1 = lc_monitor_top_pc_pojo:rm_topItem(Pid,AccData),
  priv_rm_PidTopInfo(Less, AccData_1);
priv_rm_PidTopInfo([], AccData)->
  AccData.

is_in_data(Pid)->
  Data = priv_get_data(),
  lc_monitor_top_pc_pojo:is_in_data(Pid, Data).

get_PidItemMap()->
  Data = priv_get_data(),
  lc_monitor_top_pc_pojo:get_item_map(Data).

priv_get_data()->
  Data = lc_monitor_top_pc_dao:get_data(),
  Data.

priv_update(Data)->
  lc_monitor_top_pc_dao:put_data(Data),
  ?OK.



