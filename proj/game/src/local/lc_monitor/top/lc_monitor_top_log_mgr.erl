%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_monitor_top_log_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([prin_log/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
prin_log()->
  PidItemMap = lc_monitor_top_pc_mgr:get_PidItemMap(),
  {TopSize,TopItemList} = {10,yyu_map:all_values(PidItemMap)},
  {MsgLenTopList,MemTopList,RedsTopList,InrcRedsTopList} = lc_monitor_top_helper:find_all_top_list(TopSize,TopItemList),

  priv_print_start(),
  priv_print_attr_log(message_queue_len,MsgLenTopList),
  priv_print_attr_log(memory,MemTopList),
  priv_print_attr_log(reductions,RedsTopList),
  priv_print_attr_log(incr_reductions,InrcRedsTopList),
  priv_print_end(),
  ?OK.
priv_print_start()->
  FilePath = lc_monitor_top_cfg_helper:get_log_file_path(),
  Start = io_lib:format( "~n========================================= ~p ( start ) ================================================  >>>>>>>>>>>>>>>>>>>>>>> ~n~n~n",
    [yyu_calendar:local_time()]),
  file:write_file(FilePath,[Start],[append]).
priv_print_end()->
  FilePath = lc_monitor_top_cfg_helper:get_log_file_path(),
  Start = io_lib:format( "~n~n~n============================================== ( end ) =====================================================================  >>>>>>>>>>>>>>>>>>>>>>> ~n",
    []),
  file:write_file(FilePath,[Start],[append]).


priv_print_attr_log(AttrName,TopItemList)->
  FilePath = lc_monitor_top_cfg_helper:get_log_file_path(),
  DetailList = priv_to_print_detail(TopItemList,AttrName,[]),
  Head = priv_get_print_Head(AttrName),
  file:write_file(FilePath,[Head|DetailList],[append]).

priv_get_print_Head(AttrName)->
  Head = io_lib:format(
    "~n=========================================   sorted by ~p   ==================================================~n"
    "~n~20s ~45s ~24s ~36s ~12s ~14s ~10s~n",
    [AttrName,"Pid","current_function","registered_name","initial_call","memory","reductions","msg_len"]),
  Head.
priv_to_print_detail([TopItem|Less],AttrName,AccDetailList)->
  AccDetailList_1 = priv_add_print_Detail(AttrName,TopItem,AccDetailList),
  priv_to_print_detail(Less,AttrName,AccDetailList_1);
priv_to_print_detail([],_AttrName,AccDetailList)->
  AccDetailList.

priv_add_print_Detail(message_queue_len,TopItem,DetailList)->
  {Pid, CurFun,RegName,InitCall,Mem,Reds,MsgLen,CurStk} = lc_monitor_top_pc_item:get_print_info(TopItem),
  Print_1 = io_lib:format("~20w ~45w ~30w ~35w ~12w ~12w ~6w~n",[Pid, CurFun,RegName,InitCall,Mem,Reds,MsgLen]),
  DetailList_1 =
  case MsgLen > 1 of
    ?TRUE ->
      Print_2 = io_lib:format("Pid:~p current_stacktrace:~n~p~n",[Pid,CurStk]),
      [Print_1,Print_2|DetailList];
    ?FALSE ->[Print_1|DetailList]
  end,
  DetailList_1;
priv_add_print_Detail(_AttrName,TopItem,DetailList)->
  {Pid, CurFun,RegName,InitCall,Mem,Reds,MsgLen,_CurStk} = lc_monitor_top_pc_item:get_print_info(TopItem),
  Print = io_lib:format("~20w ~45w ~30w ~35w ~12w ~12w ~6w~n",[Pid, CurFun,RegName,InitCall,Mem,Reds,MsgLen]),
  [Print|DetailList].

