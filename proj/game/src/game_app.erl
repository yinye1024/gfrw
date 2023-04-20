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
    %% 初始化 ets
    lc_app_starter:ets_init(),

    %% 本地进程业务启动
    lc_app_starter:start_svr(),

    %% 后台 http 管理服务端口
    adm_httpd_starter:start_svr(10091,10),
    %% 启动玩家进程服务，开启网关端口
    role_app_starter:start_svr(10090),

    game_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    lc_app_starter:stop_svr(),
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
