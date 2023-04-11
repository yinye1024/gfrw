%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_avatar_cb_handler).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

-define(Get_All_Avartar,1).
%% API functions defined
-export([handle_callback/1]).
-export([get_cb_on_Get_All_Avartar/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
handle_callback({?Get_All_Avartar,CbParam})->
  role_avatar_life_cycle:cb_on_Get_All_Avartar(CbParam),
  ?OK;
handle_callback({LocalParam,CbParam})->
  ?LOG_ERROR({"unknow callback:",LocalParam,CbParam}),
  ?OK.

get_cb_on_Get_All_Avartar()->
  Cb = yyu_local_callback_pojo:new_cb(priv_get_cbfun(),?Get_All_Avartar),
  Cb.

priv_get_cbfun()->
  fun s2s_role_avatar_mgr:callback_from_lc_avartar/2.
