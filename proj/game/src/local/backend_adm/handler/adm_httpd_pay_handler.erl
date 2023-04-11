%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%     处理具体业务
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(adm_httpd_pay_handler).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

-export([handle/3]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
handle(Method,Req, BsPathList)->
  {?OK,Resp} = priv_handle(Method,Req, BsPathList),
  Resp.

priv_handle('POST',Req,_BsPathList)->
  PayJson = yynw_http_utils:get_post_json("pay_data",Req),
  PayInfoMap = yyu_json:json_to_map(PayJson),
  ?LOG_INFO({"pay_data", PayInfoMap}),
  RoleId = yyu_map:get_value(roleId,PayInfoMap),
  Result = lc_pay_app_api:call_add_pay(RoleId, priv_to_payItem(RoleId,PayInfoMap)),
  {?OK, adm_httpd_resp_restful:new_success_tjson(Result)};
priv_handle(_Other,_Req,_BsPathList)->
  {?OK, adm_httpd_resp_restful:new_fail("未知请求，_Other")}.

priv_to_payItem(RoleId,PayInfoMap)->
  OrderId = 1,
  {GameId,SvrId,PlatformId,RoleId} = {1,1,1,RoleId},
  {PayWay,Amount,ProductId,PayTime}={1,200,201,yyu_time:now_seconds()},
  lc_pay_item:new_item(OrderId, {GameId,SvrId,PlatformId,RoleId},{PayWay,Amount,ProductId,PayTime}).
