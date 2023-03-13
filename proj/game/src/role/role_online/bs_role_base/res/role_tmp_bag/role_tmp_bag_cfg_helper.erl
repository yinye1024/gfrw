%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 28. 2月 2023 11:22
%%%-------------------------------------------------------------------
-module(role_tmp_bag_cfg_helper).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API
-export([get_expired_time/1, get_max_count_per_tmp_bag_item/1]).

get_expired_time(_CfgId)->
  -1.
get_max_count_per_tmp_bag_item(_CfgId)->
  99.
