%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2023, yinye
%%% @doc
%%%
%%% @end
%%% Created : 04. 1月 2023 16:04
%%%-------------------------------------------------------------------
-module(record2map).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

-export([to_map/3]).

to_map(RecordName, Data, PBufPbMod) when is_tuple(Data)->
  FiledInfoList = pbuf_utils:get_fieldInfoList(RecordName,PBufPbMod),
  [RecordName|ValueList] = tuple_to_list(Data),
  KVList = lists:zip(FiledInfoList,ValueList),
  Map = priv_transfer(KVList,{yyu_map:new_map(), PBufPbMod}),
  Map;
to_map(_RecordName, Data, _PBufPbMod) ->
  Data.

priv_transfer([{FieldInfo,FiledData}|Less],{AccMap, PBufPbMod})->
  AccMap_1 = priv_transfer_field(FieldInfo,{FiledData,PBufPbMod},AccMap),
  priv_transfer(Less,{AccMap_1, PBufPbMod});
priv_transfer([],{AccMap,_RecordInfo})->
  AccMap.

priv_transfer_field({field,FieldName,_,_,{msg,RecordName},_,_},{FiledData,PBufPbMod},AccMap)->
  FieldMap = to_map(RecordName,FiledData, PBufPbMod),
  AccMap_1 = yyu_map:put_value(FieldName,FieldMap,AccMap),
  AccMap_1;
priv_transfer_field({field,FieldName,_,_,_,_,_},{FiledData,_PBufPbMod},AccMap)->
  AccMap_1 = yyu_map:put_value(FieldName,FiledData,AccMap),
  AccMap_1.
