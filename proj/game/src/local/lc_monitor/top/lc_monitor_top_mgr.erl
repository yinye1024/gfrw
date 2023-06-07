%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_monitor_top_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([init/0, on_new_loop/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
init()->
  lc_monitor_top_pc_mgr:proc_init(),
  ?OK.

on_new_loop()->
  priv_sum_new_info(),
  lc_monitor_top_log_mgr:prin_log(),
  ?OK.

priv_sum_new_info()->
  PidItemMap = lc_monitor_top_pc_mgr:get_PidItemMap(),
  PidList = priv_add_new_pids(PidItemMap),
  {PidInfoList,RmPidList} = priv_sum_new_info(PidList,{[],[]}),
  lc_monitor_top_pc_mgr:put_PidTopInfo(PidInfoList),
  lc_monitor_top_pc_mgr:rm_PidTopInfo(RmPidList),
  ?OK.
priv_sum_new_info([Pid |Less],{AccPIdInfoList,AccRmPidList})->
  {AccPIdInfoList_1,AccRmPidList_1} =
  case recon:info(Pid, [message_queue_len,memory,reductions,current_function]) of
    ?UNDEFINED -> {AccPIdInfoList,[Pid |AccRmPidList]};
    [{message_queue_len,MsgQueueLen},{memory,MemBytes},{reductions,Reds},{current_function,CurFun}] ->
      CurStk =
      case MsgQueueLen > 0 of
        ?TRUE -> {current_stacktrace,CurStkTmp} = recon:info(Pid,current_stacktrace),
          CurStkTmp;
        ?FALSE -> ?NOT_SET
      end,
      PidInfo = {Pid,MsgQueueLen,MemBytes,Reds,CurFun,CurStk},
      {[PidInfo|AccPIdInfoList],AccRmPidList}
  end,
  priv_sum_new_info(Less, {AccPIdInfoList_1,AccRmPidList_1});
priv_sum_new_info([],{AccPIdInfoList,AccRmPidList})->
  {AccPIdInfoList,AccRmPidList}.

priv_add_new_pids(PidItemMap)->
  CurPidList = erlang:processes(),
  PidItemMap_1 = priv_add_new_pid(CurPidList,PidItemMap),
  yyu_map:all_keys(PidItemMap_1).
priv_add_new_pid([Pid|Less],AccPidItemMap)->
  AccPidItemMap_1 =
  case yyu_map:has_key(Pid,AccPidItemMap) of
    ?TRUE ->AccPidItemMap;
    ?FALSE -> yyu_map:put_value(Pid,1,AccPidItemMap)
  end,
  priv_add_new_pid(Less,AccPidItemMap_1);
priv_add_new_pid([],AccPidItemMap)->
  AccPidItemMap.
