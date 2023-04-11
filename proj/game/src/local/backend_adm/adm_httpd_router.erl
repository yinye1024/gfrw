%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%     转发到业务handler 处理具体业务
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(adm_httpd_router).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-export([get_mod/0,route_request/2]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
get_mod()->
  ?MODULE.

route_request(Req,DocRoot)->

  try
    Method = yynw_http_utils:get_method(Req),
    Path = yynw_http_utils:get_path(Req),
    ?LOG_INFO({route_request,Method,Path}),
    case Method of
      'OPTIONS'->
        %% 跨域OPTIONS请求，直接返回成功
        yynw_http_utils:resp_ok(adm_httpd_resp_restful:new_success(),Req);
      _other ->
        priv_route_request(Req,DocRoot)
    end
  catch
    throw:{assert_error,Tips}:STK  ->
      ?LOG_ERROR({STK}),
      ErrorResp = adm_httpd_resp_restful:new_fail(Tips),
      yynw_http_utils:resp_ok(ErrorResp,Req);
    Error:Reason  ->
      ?LOG_ERROR({Error,Reason,erlang:get_stacktrace()}),
      ErrorResp = adm_httpd_resp_restful:new_fail("内部错误，请稍后重试。"),
      yynw_http_utils:resp_ok(ErrorResp,Req)
  end.

priv_route_request(Req,_DocRoot)->
  Method = yynw_http_utils:get_method(Req),
  Path = yynw_http_utils:get_path(Req),
  [Path0|LessPath] = yyu_string:tokens(Path,"/"),

  case Path0 of
    "file"->
%%      yynw_http_utils:resp_file(Path,DocRoot,Req),
      ?OK;
    "auth"->
%%      adm_httpd_auth_handler:handle(Req,LessPath),
      ?OK;
    _->
      case adm_httpd_auth_handler:check_auth(Req) of
        ?TRUE ->
          Resp = priv_route_bs(Path0,{Method,Req,LessPath}),
          yynw_http_utils:resp_ok(Resp,Req);
        ?FALSE ->
          Resp = adm_httpd_resp_restful:new_fail("授权失败，请重新登陆"),
          yynw_http_utils:resp_ok(adm_httpd_auth_handler:set_auth_fail(Resp),Req)
      end,
      ?OK
  end,
  ?OK.

priv_route_bs("test",{Method,Req,LessPath})->
  Resp =  adm_httpd_test_handler:handle(Method,Req,LessPath),
  Resp;
priv_route_bs("pay",{Method,Req,LessPath})->
  Resp =  adm_httpd_pay_handler:handle(Method,Req,LessPath),
  Resp;
priv_route_bs(_Default,{_UserId,_Method,_Req,_LessPath})->
  ?LOG_INFO({"请求不存在",_Req}),
  Resp =  adm_httpd_resp_restful:new_fail("请求不存在"),
  Resp.
