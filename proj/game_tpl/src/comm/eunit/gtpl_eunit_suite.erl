%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. 六月 2021 19:07
%%%-------------------------------------------------------------------
-module(gtpl_eunit_suite).
-author("yinye").
-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("eunit/include/eunit.hrl").



%% ===================================================================================
%% API functions implements
%% ===================================================================================
api_test_() ->
  yyu_logger:start(),
  [{setup,
    fun start_suite/0,
    fun stop_suite/1,
    fun (_SetupData) ->
      [
        {foreach,
          fun start_case/0,
          fun stop_case/1,
          [
            fun test_a/1,
            fun test_b/1,
            fun test_c/1
          ]
        }
      ]
    end}].


start_suite() ->
  ?LOG_INFO({"api test suite start ==================="}),
  SP1 ="sp1",
  SP2 = "sp2",
  {SP1, SP2}.

stop_suite({SP1,SP2}) ->
  ?LOG_INFO({"api test suite end ======================",SP1,SP2}),
  ?OK.

start_case()->
  P1 ="sp1",
  P2 = "sp2",
  ?LOG_INFO({"start case ===================",P1,P2}),
  {P1,P2}.

stop_case({P1,P2})->
  %% 清理数据
  ?LOG_INFO({"stop case ===================",P1,P2}),
  ?OK.

test_a({_P1,_P2})->
  [
    ?_assertMatch(1,1)
  ].

test_b({P1,P2})->
  [
    ?_assertNotMatch(P1,P2)
  ].

test_c({P1,P2})->

  [
    ?_assertNotMatch(P1,P2),
    ?_assertMatch(1,1)
  ].
