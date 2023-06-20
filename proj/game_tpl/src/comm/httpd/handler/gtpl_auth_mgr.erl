%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(gtpl_auth_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").


%% API functions defined
-export([create_user/2, get_by_account/1, check_account_exist/1,check_userId_exist/1]).


%% ===================================================================================
%% API functions implements
%% ===================================================================================
create_user(Account,Pwd)->
  Md5Pwd = yyu_auth:to_md5(Pwd),
  case get_by_account(Account) of
    ?NOT_SET->
      UserId = 1,
      UserPojo = gtpl_user_pojo:new_pojo(UserId,{Account,Md5Pwd}),
      {?OK,UserPojo};
    _Other ->
      {?FAIL,"账号已存在"}
  end.

check_account_exist(Account)->
  get_by_account(Account) =/= ?NOT_SET.

get_by_account(_Account)->
  ?NOT_SET.

check_userId_exist(UserId) when is_integer(UserId)->
  ?TRUE.









