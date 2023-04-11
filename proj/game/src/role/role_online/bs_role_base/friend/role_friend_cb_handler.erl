%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_friend_cb_handler).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

-define(Get_All_Apply,1).
%% API functions defined
-export([handle_callback/1]).
-export([get_cb_on_get_all_apply/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
handle_callback({?Get_All_Apply,CbParam})->
  role_friend_mgr:cb_on_get_all_apply(CbParam),
  ?OK;
handle_callback({LocalParam,CbParam})->
  ?LOG_ERROR({"unknow callback:",LocalParam,CbParam}),
  ?OK.

get_cb_on_get_all_apply()->
  Cb = yyu_local_callback_pojo:new_cb(priv_get_cbfun(),?Get_All_Apply),
  Cb.

priv_get_cbfun()->
  fun s2s_role_friend_mgr:callback_from_lc_friend/2.
