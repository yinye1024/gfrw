%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. 六月 2021 19:07
%%%-------------------------------------------------------------------
-module(proto_eunit_case).
-author("yinye").
%% yyu_comm.hrl 和 eunit.hrl 都定义了 IF 宏，eunit.hrl做了保护
-include_lib("yyutils/include/yyu_comm.hrl").
-include_lib("eunit/include/eunit.hrl").
-include("login_pb.hrl").


%% ===================================================================================
%% API functions implements
%% ===================================================================================
client_test_() ->
  yyu_logger:start(),
  ?LOG_INFO({"client test ==================="}),

  {foreach,
  fun start/0,
  fun stop/1,
  [
    fun test_encode_decode/1,
    fun test_map2record/1
  ]
  }.
%%  [].


start() ->
  Context = 1,
  ?LOG_INFO({"test start",Context}),
  {Context}.

stop({Context}) ->
  ?LOG_INFO({"test end",Context}),
  ?OK.


test_encode_decode({Context})->
  Name = <<"yinye">>,
  LoginC2S = #role_login_c2s{
    uid = <<"1001">>,
    uname = Name,
    plat = <<"xiaomi">>,
    game_id = <<"101">>,
    svrId = 1,
    machine_info = #p_machineInfo{
      device = <<"xiaomi">>,
      device_id = <<"T9901">>,
      device_name = <<"X6">>
    }
  },
  Msg = login_pb:encode_msg(LoginC2S),
  ?LOG_INFO({Msg}),
  DeMsg = login_pb:decode_msg(Msg, role_login_c2s),
  ?LOG_INFO({encode,LoginC2S}),
  ?LOG_INFO({decode,DeMsg}),
  [
    ?_assertMatch(Name,LoginC2S#role_login_c2s.uname),
    ?_assertMatch(Name,DeMsg#role_login_c2s.uname)
  ].
test_map2record({Context})->

  RecordName = role_login_c2s,
  PBufPbMod = login_pb,
  Name = <<"yinye">>,
  Data = #{
    uid => <<"1001">>,
    uname => Name,
    plat => <<"xiaomi">>,
    game_id => <<"101">>,
    ticket => <<"#EDC$RFV5tgb">>,
    svrId => 1,
    machine_info => #{
      device => <<"xiaomi">>,
      device_id => <<"T9901">>,
      device_name => <<"X6">>
    }
  },
  Record = map2record:to_record(RecordName, Data, PBufPbMod),
  Map = record2map:to_map(RecordName, Record, PBufPbMod),
  ?LOG_INFO({map2record,Record}),
  ?LOG_INFO({record2map,Map}),
  [
    ?_assertMatch(Name,yyu_map:get_value(uname,Map))
  ].





