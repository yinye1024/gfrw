%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(lc_monitor_top_pc_item).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([new_pojo/2,get_id/1]).
-export([get_message_queue_len/1, get_memory/1, get_reductions/1, get_incr_reductions/1]).
-export([should_be_warned/1,should_be_killed/2]).
-export([set_new_values/3,get_cur_values/1]).
-export([get_print_info/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(Pid,{CanKilled,RegName,InitCall})->

  #{
    id => Pid,
    can_killed =>CanKilled,
    regname => RegName,
    initcall => InitCall,


    message_queue_len => ?NOT_SET,
    memory =>?NOT_SET,
    reductions =>?NOT_SET,
    incr_reductions => ?NOT_SET,

    cur_fun => ?NOT_SET,
    cur_stk=>?NOT_SET
  }.

get_id(ItemMap) ->
  yyu_map:get_value(id, ItemMap).
priv_is_can_killed(SelfMap) ->
  yyu_map:get_value(can_killed, SelfMap).


%% 内存占用超过这个值会发邮件警告，单位byte
should_be_warned(MemBytes)->
  %% 100 M
  MemBytes > 100000000.

%% 内存占用超过这个值,而且前缀在列表内，会被杀掉
should_be_killed(MemBytes,SelfMap)->
  priv_is_can_killed(SelfMap) andalso MemBytes > 500000000.

set_new_values({MsgQueueLen,MemBytes,Reds},{CurFun,CurStk},SelfMap)->
  LastReds = get_reductions(SelfMap),
  IncrReds = ?IF(LastReds == ?NOT_SET,0,Reds - LastReds),
  SelfMap#{
    message_queue_len => MsgQueueLen,
    memory =>MemBytes,
    reductions =>Reds,
    incr_reductions =>IncrReds,

    cur_fun => CurFun,
    cur_stk=> CurStk
  }.

%% return {MsgLen,Mem,Reds,InrcReds}
get_cur_values(SelfMap)->
  {get_message_queue_len(SelfMap),get_memory(SelfMap),get_reductions(SelfMap),get_incr_reductions(SelfMap)}.

get_message_queue_len(SelfMap) ->
  yyu_map:get_value(message_queue_len, SelfMap).

get_memory(SelfMap) ->
  yyu_map:get_value(memory, SelfMap).

get_reductions(SelfMap) ->
  yyu_map:get_value(reductions, SelfMap).

get_incr_reductions(SelfMap) ->
  yyu_map:get_value(incr_reductions, SelfMap).

get_print_info(SelfMap)->
  #{
    id := Pid,
    regname := RegName,
    initcall := InitCall,
    message_queue_len := MsgLen,
    memory := Mem,
    reductions :=Reds,

    cur_fun := CurFun,
    cur_stk := CurStk
  } =  SelfMap,

  {Pid, CurFun,RegName,InitCall,Mem,Reds,MsgLen,CurStk}.