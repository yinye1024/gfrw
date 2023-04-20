%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_mail_cb_handler).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

-define(Syn_Role_Mails,1).
%% API functions defined
-export([handle_callback/1]).
-export([get_cb_on_syn_role_mails/0]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
handle_callback({?Syn_Role_Mails,CbParam})->
  role_mail_mgr:cb_on_syn_role_mails(CbParam),
  ?OK;
handle_callback({LocalParam,CbParam})->
  ?LOG_ERROR({"unknow callback:",LocalParam,CbParam}),
  ?OK.

get_cb_on_syn_role_mails()->
  Cb = yyu_local_callback_pojo:new_cb(priv_get_cbfun(),?Syn_Role_Mails),
  Cb.

priv_get_cbfun()->
  fun s2s_role_mail_mgr:callback_from_lc_mail/2.
