%%%-------------------------------------------------------------------
%% @doc game public API
%% @end
%%%-------------------------------------------------------------------

-module(game_app).

-behaviour(application).
-include_lib("yyutils/include/yyu_comm.hrl").
%% Application callbacks
-export([start/0,start/2, stop/0, stop/1]).

%%====================================================================
%% API
%%====================================================================
start()->
    try
        application:start(sasl),
        application:start(crypto),
        application:start(inets),
        application:start(asn1),
        ok = application:start(game)
    catch
        Error:Reason:STK  ->
            io:format("****************** game start error ********************* ~n~p:~p~n ~p",[Error,Reason,STK]),
            yyu_time:sleep(1000000),
            init:stop()
    end.


start(_StartType, _StartArgs) ->
    io:format("*************** game app start ************************ ~n~p:~p~n",[_StartType, _StartArgs]),
    io:format("game_root_dir:~p~n",[init:get_argument(game_root_dir)]),
    %% 如果有 自定义的flag  game_root_dir，设置成工作目录
    case init:get_argument(game_root_dir) of
        {?OK,[[GameRootDir]]}->
            io:format("set_cwd:~p~n",[GameRootDir]),
            file:set_cwd(GameRootDir);
        _Other ->
            ?OK
    end,
    %% 动态配置初始化
    game_cfg:init(),
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
stop() ->
    lc_app_starter:stop_svr(),
    init:stop(),
    ?OK.

%%====================================================================
%% Internal functions
%%====================================================================
stop(_State) ->
    ?OK.