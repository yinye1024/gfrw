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
  case game_cfg:is_debug_open() of
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

%% StrCmd = "add_mail,"++yyu_misc:to_list(UserRoleId)++",1,\"Title_1\",\"Content\",\"attachment\"",
priv_exec_cmd("add_mail",Params)->
  ?LOG_INFO({"do gm add_mail",Params}),
  PStr = string:join(Params,","),
  TermStr = "{" ++ PStr ++ "}",
  {RoleId,MailType,Title,Content,AttachItemList} = yyu_misc:string_to_term(TermStr),
  SendTime = yyu_time:now_milliseconds(),
  FromId = ?NOT_SET,
  MailItem = role_mail_item:new_pojo(MailType,{FromId,SendTime},{Title,Content,AttachItemList}),
  lc_mail_app_api:add_to_role_mail(RoleId,MailItem),
  ?OK;

%%StrCmd = "add_bag_item,"++yyu_misc:to_list(101)++","++yyu_misc:to_list(Count)++"",
priv_exec_cmd("add_bag_item",Params)->
  ?LOG_INFO({"do gm add_bag_item",Params}),
  [CfgIdStr,CountStr] = Params,
  ExItem = role_bag_ex_item:new_add_item(yyu_misc:to_integer(CfgIdStr),yyu_misc:to_integer(CountStr)),
  role_res_mgr:do_bag_exchange(ExItem),
  ?OK;
priv_exec_cmd("add_wallet_item",Params)->
  ?LOG_INFO({"do gm add_wallet_item",Params}),
  [CfgIdStr,CountStr, IsBindStr] = Params,
  ExItem = role_wallet_ex_item:new_add_item(yyu_misc:to_integer(CfgIdStr),yyu_misc:to_integer(CountStr), erlang:list_to_atom(IsBindStr)),
  role_res_mgr:do_wallet_exchange(ExItem),
  ?OK;
priv_exec_cmd("set_role_prop_item",Params)->
  ?LOG_INFO({"do gm set_role_prop_item",Params}),
  [PropKeyStr,PropValueStr] = Params,
  role_prop_player_mgr:set_gm_attr(yyu_map:from_kv_list([{yyu_misc:to_integer(PropKeyStr),yyu_misc:to_integer(PropValueStr)}])),
  role_prop_player_mgr:check_and_update_tree(),
  ?OK;
priv_exec_cmd(Cmd,Params)->
  ?LOG_WARNING({"unknown gm ",Cmd,Params}),
  ?OK.

