%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 12. 1月 2023 19:22
%%%-------------------------------------------------------------------
-module(tpl_s2c_handler).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
%% API
-export([send_all_tpl_info/1]).
send_all_tpl_info(TplItemList)->
  tpl_pbuf_helper:build_tpl_info_list(TplItemList),
  ?OK.
