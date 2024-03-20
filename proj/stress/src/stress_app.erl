%%%-------------------------------------------------------------------
%% @doc stress public API
%% @end
%%%-------------------------------------------------------------------

-module(stress_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->

    %% 启动日志服务
    yyu_logger:start(),
    %% 配置初始化
    test_cfg:init(),
    %% robot 初始化
    gs_robot_mgr:start_link(),

    %% 启动压测
%%    gs_stress_adm_mgr:init(),
%%    {MaxCount,Tps,StartUserId} = test_cfg:stress_cfg(),
%%    gs_stress_adm_mgr:set_stress_cfg({MaxCount,Tps,StartUserId}),


    stress_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
