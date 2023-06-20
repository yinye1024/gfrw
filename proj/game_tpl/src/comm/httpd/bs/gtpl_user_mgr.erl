%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 十一月 2021 15:39
%%%-------------------------------------------------------------------
-module(gtpl_user_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
%% API functions defined
-export([call_do_login/2,call_check_token/2,call_reset_pwd/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
call_do_login(CUserId,{_Pwd,_ClientType}) when is_integer(CUserId)->
  Result = {?TRUE, gtpl_user_pojo:new_mock()},
  Result.
call_reset_pwd(CUserId,_NewPwd) when is_integer(CUserId)->
  Result = {?OK, gtpl_user_pojo:new_mock()} ,
  Result.
call_check_token(CUserId,{_Token,_ClientType}) when is_integer(CUserId)->
  ?TRUE,CUserId.

