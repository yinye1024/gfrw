%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 12. 1月 2023 19:22
%%%-------------------------------------------------------------------
-module(prop_pbuf_helper).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("protobuf/include/prop_pb.hrl").
%% API
-export([to_p_prop_kv_list/1]).

%% ApplyItem lc_prop_apply_item
to_p_prop_kv_list(PropKvList)->
  Fun = fun({PropKey, PropValue}) ->
    #p_kv_int{
      key = PropKey,
      value = PropValue
    } end,
  PKVList = yyu_list:map(Fun, PropKvList),
  PKVList.








