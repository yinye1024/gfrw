%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 28. 2月 2023 11:22
%%%-------------------------------------------------------------------
-module(role_wallet_cfg_helper).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API
-export([get_gold_cfgId/0, get_diamond_cfgId/0]).

%% 金币
get_gold_cfgId()->
  1.
%% 钻石
get_diamond_cfgId()->
  2.
