%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 12. 1月 2023 19:22
%%%-------------------------------------------------------------------
-module(gtpl_s2c_handler).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
%% API
-export([send_all_gtpl_info/1]).
send_all_gtpl_info(TplItemList)->
  gtpl_pbuf_helper:build_gtpl_info_list(TplItemList),
  ?OK.
