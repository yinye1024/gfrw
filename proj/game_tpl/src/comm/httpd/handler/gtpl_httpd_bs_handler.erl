%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%     处理具体业务
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(gtpl_httpd_bs_handler).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

-export([handle/3]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
handle(Method,Req, BsPathList)->
  {?OK,Resp} = priv_handle(Method,Req, BsPathList),
  Resp.

priv_handle('GET',Req,_BsPathList)->
  Qs = yynw_http_utils:get_url_params(Req),
  ?LOG_INFO({get,Qs}),
  {?OK, gtpl_resp_restful:new_success_tjson(?NOT_SET)};
priv_handle('POST',Req,_BsPathList)->
  PostData = yynw_http_utils:get_post_params(Req),
  ?LOG_INFO({post, PostData}),
  {?OK, gtpl_resp_restful:new_success_tjson(?NOT_SET)};
priv_handle('PUT',Req,[Id|_Less]=_BsPathList)->
  PostData = yynw_http_utils:get_post_params(Req),
  ?LOG_INFO({put, PostData}),
  {?OK, gtpl_resp_restful:new_success_tjson(#{id=>Id})};
priv_handle('DELETE',Req,[Id|_Less]=_BsPathList)->
  PostData = yynw_http_utils:get_post_params(Req),
  ?LOG_INFO({delete, PostData}),
  {?OK, gtpl_resp_restful:new_success_tjson(#{id=>Id})};
priv_handle(_Other,_Req,_BsPathList)->
  {?OK, gtpl_resp_restful:new_fail("未知请求，_Other")}.
