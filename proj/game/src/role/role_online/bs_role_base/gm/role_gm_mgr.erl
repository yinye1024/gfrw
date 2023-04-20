%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_gm_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined

-export([gm_cmd/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================


gm_cmd(RpcCmd)->
  ?LOG_INFO({"receive gm ",RpcCmd}),
  case game_cfg:is_open_debug() of
    ?TRUE ->
      StrCmd = string:strip(string:strip(string:strip(yyu_misc:to_list(RpcCmd),both,$\n),both,$\r)),
      priv_gm_cmd(StrCmd),
      ?OK
  end,
  ?OK.
priv_gm_cmd(StrCmd)->
  [Cmd|Params] = string:tokens(StrCmd,","),
  Cmd_1 = unicode:characters_to_list(unicode:characters_to_binary(list_to_binary(Cmd),utf8)), %% 转换utf9字符串
  priv_exec_cmd(Cmd_1,Params).

%% "add_mail,RoleId,MailType,Title,Content,[]"
priv_exec_cmd("add_mail",Params)->
  ?LOG_INFO({"do gm add_mail",Params}),
  PStr = string:join(Params,","),
  TermStr = "{" ++ PStr ++ "}",
  ?LOG_INFO({"oooooooooooooooo ",{TermStr}}),
  {RoleId,MailType,Title,Content,AttachItemList} = yyu_misc:string_to_term(TermStr),
  SendTime = yyu_time:now_milliseconds(),
  FromId = ?NOT_SET,
  MailItem = role_mail_item:new_pojo(MailType,{FromId,SendTime},{Title,Content,AttachItemList}),
  lc_mail_app_api:add_to_role_mail(RoleId,MailItem),
  ?OK;
priv_exec_cmd(Cmd,Params)->
  ?LOG_WARNING({"unknown gm ",Cmd,Params}),
  ?OK.

