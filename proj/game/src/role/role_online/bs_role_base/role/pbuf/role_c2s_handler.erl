%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 12. 1月 2023 19:22
%%%-------------------------------------------------------------------
-module(role_c2s_handler).
-author("yinye").
-include_lib("yyutils/include/yyu_comm.hrl").
-include("role/role_gw/login.hrl").

%% API
-export([role_logout_c2s/1]).

role_logout_c2s(C2SRD)->
  ?LOG_INFO({"role_logout_c2s,",C2SRD}),
  role_s2c_handler:send_role_logout_s2c(?Logout_Normal),
  ?OK.

