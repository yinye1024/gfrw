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
    %% 启动压测服务
    gs_robot_mgr:init(),
    gs_stress_adm_mgr:init(),
    {MaxCount,Tps,StartUserId} = {1,10,1002},
    gs_stress_adm_mgr:set_stress_cfg({MaxCount,Tps,StartUserId}),

    stress_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
