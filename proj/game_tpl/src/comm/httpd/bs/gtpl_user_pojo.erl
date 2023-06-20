%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(gtpl_user_pojo).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([new_pojo/2,new_mock/0,get_id/1,get_ver/1,incr_ver/1]).
-export([get_createTime/1,set_createTime/2]).
-export([get_md5_psw/1,set_md5_psw/2]).
-export([get_account/1, set_account/2]).
-export([get_token/2,put_token/3]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
new_pojo(_UserId,{_Account,_Md5Pwd})->
  new_mock().
new_mock()->
  #{
    '_id' => 1,ver=>0,
    account =><<"1@qq.com">>,
    md5_psw =>  yyu_auth:to_md5("md5_123456"), %% md5 加密后的用户密码
    token_map => yyu_map:new_map(), %%  <ClientType,Token> 存在客户端的 token， 带token可不做登陆校验
    createTime => yyu_time:now_seconds()
  }.

get_id(ItemMap) ->
  yyu_map:get_value('_id', ItemMap).

get_ver(ItemMap) ->
  yyu_map:get_value(ver, ItemMap).
incr_ver(ItemMap) ->
  CurVer = get_ver(ItemMap),
  NewVer = yyu_misc:incr_ver(CurVer),
  yyu_map:put_value(ver, NewVer, ItemMap).

get_createTime(ItemMap) ->
  yyu_map:get_value(createTime, ItemMap).

set_createTime(Value, ItemMap) ->
  yyu_map:put_value(createTime, Value, ItemMap).

get_md5_psw(ItemMap) ->
  yyu_map:get_value(md5_psw, ItemMap).

set_md5_psw(Value, ItemMap) ->
  yyu_map:put_value(md5_psw, Value, ItemMap).

get_account(ItemMap) ->
  yyu_map:get_value(account, ItemMap).

set_account(Value, ItemMap) ->
  yyu_map:put_value(account, Value, ItemMap).

get_token(ClientType,ItemMap) when is_integer(ClientType)->
  TokenMap = priv_get_token_map(ItemMap),
  yyu_map:get_value(ClientType,TokenMap).

put_token(ClientType,Token, ItemMap) when is_integer(ClientType) ->
  TokenMap = priv_get_token_map(ItemMap),
  TokenMap_1 = yyu_map:put_value(ClientType,Token,TokenMap),
  priv_set_token_map(TokenMap_1, ItemMap).

priv_get_token_map(ItemMap) ->
  yyu_map:get_value(token_map, ItemMap).

priv_set_token_map(Value, ItemMap) ->
  yyu_map:put_value(token_map, Value, ItemMap).

