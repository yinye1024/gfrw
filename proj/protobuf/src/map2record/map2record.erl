%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 04. 1月 2023 16:04
%%%-------------------------------------------------------------------
-module(map2record).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

-export([to_record/3]).

to_record(RecordName, Data, PBufPbMod) when is_map(Data)->
  case pbuf_utils:is_record(RecordName,PBufPbMod) of
    ?TRUE->
      FieldInfoList = pbuf_utils:get_fieldInfoList(RecordName,PBufPbMod),
      Values = lists:map(fun(FieldInfoItem)-> priv_get_value(FieldInfoItem,Data,PBufPbMod) end, FieldInfoList),
      list_to_tuple([RecordName|Values]);
    ?FALSE->
      Data
  end;
to_record(RecordName, Data, PBufPbMod) when is_list(Data)->
  case pbuf_utils:is_record(RecordName,PBufPbMod)of
    ?TRUE->
      lists:map(fun(ItemData)-> to_record(RecordName,ItemData, PBufPbMod) end, Data);
    ?FALSE->
      Data
  end;
to_record(_RecordName, Data, _PBufPbMod)->
  Data.




priv_get_value({field,FieldName,_,_,{msg,RecordName},_,_},MapData,PBufPbMod)->
  FieldData = maps:get(FieldName,MapData,?UNDEFINED),
  to_record(RecordName,FieldData, PBufPbMod);
priv_get_value({field,FieldName,_,_,_,_,_},MapData,_PBufPbMod)->
  FieldData = maps:get(FieldName,MapData,?UNDEFINED),
  FieldData;
priv_get_value(_Other,_MapData,_PBufPbMod)->
  {?UNKNOWN,_Other}.




