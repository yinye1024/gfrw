%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 05. 1月 2023 9:58
%%%-------------------------------------------------------------------
-module(pbuf_utils).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

-export([is_record/2,get_fieldInfoList/2]).

%% API
is_record(RecordName,PBufPbMod)->
  case PBufPbMod:find_msg_def(RecordName) of
    ?ERROR -> ?FALSE;
    _Other -> ?TRUE
  end.

get_fieldInfoList(RecordName,PBufPbMod)->
  case PBufPbMod:find_msg_def(RecordName) of
    ?ERROR -> [];
    FieldInfoList -> FieldInfoList
  end.
