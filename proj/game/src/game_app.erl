%%%-------------------------------------------------------------------
%% @doc game public API
%% @end
%%%-------------------------------------------------------------------

-module(game_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    %% 启动日志服务
    yyu_logger:start(),
    %% 启动mongodb服务
    gs_game_mongo_mgr:init(),

    %%启动玩家服务，监听网关端口
    role_app_starter:start_svr(10090),

    game_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
