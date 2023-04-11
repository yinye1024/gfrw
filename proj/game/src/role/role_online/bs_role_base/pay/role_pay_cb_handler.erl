%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_pay_cb_handler).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

-define(Get_All_Pay,1).
%% API functions defined
-export([handle_callback/1]).
-export([get_cb_on_Get_All_Pay/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
handle_callback({?Get_All_Pay,CbParam})->
  role_pay_life_cycle:cb_on_Get_All_Pay(CbParam),
  ?OK;
handle_callback({LocalParam,CbParam})->
  ?LOG_ERROR({"unknow callback:",LocalParam,CbParam}),
  ?OK.

get_cb_on_Get_All_Pay()->
  Cb = yyu_local_callback_pojo:new_cb(priv_get_cbfun(),?Get_All_Pay),
  Cb.

priv_get_cbfun()->
  fun s2s_role_pay_mgr:callback_from_lc_pay/2.
