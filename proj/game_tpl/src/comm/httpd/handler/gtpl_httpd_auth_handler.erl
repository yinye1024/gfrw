%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%     处理具体业务
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(gtpl_httpd_auth_handler).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

-define(COOKIE_USER_ID,"userId").
-define(COOKIE_TOKEN,"token").
-define(COOKIE_CLIENT_TYPE,"client_type").

-export([handle/2,check_auth/1, set_auth_fail/1]).


%% ===================================================================================
%% API functions implements
%% ===================================================================================
handle(Req, [Path1|_Less] = _BsPath)->
  Method = yynw_http_utils:get_method(Req),
  priv_handle(Path1,Method,Req),
  ?OK.
priv_handle("login",'POST',Req)->
  JsonData = yynw_http_utils:get_post_json("data",Req),

  MapData = yyu_json:json_to_map(JsonData),
  Account = yynw_form_utils:get_binary(account,MapData),
  Password = yynw_form_utils:get_string(password,MapData),
  ClientTypeNo = yynw_http_utils:get_header_int(?COOKIE_CLIENT_TYPE,Req),

  Result =
  case gtpl_auth_mgr:get_by_account(Account) of
    ?NOT_SET ->
      {?FALSE,"账号不存在"};
    UserPojo ->
      CUserId = gtpl_user_pojo:get_id(UserPojo),
      gtpl_user_mgr:call_do_login(CUserId,{Password,ClientTypeNo})
  end,

  case  Result of
    {?TRUE, NewUserPojo} ->
      UserId = gtpl_user_pojo:get_id(NewUserPojo),
      Token = gtpl_user_pojo:get_token(ClientTypeNo,NewUserPojo),
      SUser = priv_new_ClientSUser(UserId,Token),
      ?LOG_INFO({userPojo, NewUserPojo}),
      yynw_http_utils:resp_ok(gtpl_resp_restful:new_success_tjson(SUser),Req),
      ?OK;
    {?FALSE,Tips} ->
      yynw_http_utils:resp_ok(gtpl_resp_restful:new_fail(Tips),Req),
      ?OK
  end,
  ?OK;

priv_handle("reg",'POST',Req)->
  JsonData = yynw_http_utils:get_post_json("data",Req),
  MapData = yyu_json:json_to_map(JsonData),
  Account = yynw_form_utils:get_binary(account,MapData),
  Password = yynw_form_utils:get_string(password,MapData),

  ?LOG_INFO({Account,Password}),
  case gtpl_auth_mgr:create_user(Account,Password) of
    {?OK,_UserPojo} ->
      yynw_http_utils:resp_ok(gtpl_resp_restful:new_success(),Req),
      ?OK;
    {?FAIL,Tips}->
      yynw_http_utils:resp_ok(gtpl_resp_restful:new_fail(Tips),Req),
      ?OK
  end,
  ?OK;

priv_handle("resetpwd",'POST',Req)->
  JsonData = yynw_http_utils:get_post_json("data",Req),
  MapData = yyu_json:json_to_map(JsonData),
  Account = yynw_form_utils:get_binary(account,MapData),
  NewPwd = yynw_form_utils:get_string(password,MapData),

  Result =
    case gtpl_auth_mgr:get_by_account(Account) of
      ?NOT_SET ->
        {?FALSE,"账号不存在"};
      UserPojo ->
        CUserId = gtpl_user_pojo:get_id(UserPojo),
        gtpl_user_mgr:call_reset_pwd(CUserId, NewPwd)
    end,

  case Result of
    {?OK,_UserPojo} ->
      yynw_http_utils:resp_ok(gtpl_resp_restful:new_success(),Req),
      ?OK;
    {?FALSE,Tips}->
      yynw_http_utils:resp_ok(gtpl_resp_restful:new_fail(Tips),Req),
      ?OK
  end,
  ?OK;
priv_handle(_Other,_Other,Req)->
  yynw_http_utils:resp_ok(gtpl_resp_restful:new_fail("未知请求，_Other"),Req),
  ?OK.

check_auth(_Req)->
  {?TRUE,1}.
%%  {IsPassed, UserId} =
%%    case yynw_http_utils:get_header_int(?COOKIE_USER_ID,Req) of
%%      ?NOT_SET -> {?FALSE,?NOT_SET};
%%      UserIdNo ->
%%        case yynw_http_utils:get_header_value(?COOKIE_TOKEN,Req) of
%%          ?NOT_SET ->{?FALSE,?NOT_SET};
%%          Token ->
%%            ClientTypeNo = yynw_http_utils:get_header_int(?COOKIE_CLIENT_TYPE,Req),
%%            Pass =
%%              case gtpl_auth_mgr:check_userId_exist(UserIdNo) of
%%                ?TRUE ->
%%                  gtpl_user_mgr:call_check_token(UserIdNo,{Token,ClientTypeNo});
%%                ?FALSE ->?FALSE
%%              end,
%%            {Pass, UserIdNo}
%%        end
%%    end,
%%  {IsPassed, UserId}.

set_auth_fail(Resp) when is_map(Resp)->
  yyu_map:put_value(auth_pass,?FALSE,Resp).

priv_new_ClientSUser(UserId,Token)->
  #{
    userId=>UserId,
    token=>Token
  }.
