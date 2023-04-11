%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_pay_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([get_all_pay/0,notify_new_pay/0, cb_on_get_all_pay/1]).
%% ===================================================================================
%% API functions implements
%% ===================================================================================
notify_new_pay()->
  get_all_pay(),
  ?OK.

get_all_pay()->
  RoleId = role_adm_mgr:get_roleId(),
  LocalCbPojo = role_pay_cb_handler:get_cb_on_Get_All_Pay(),
  lc_pay_app_api:get_data(RoleId,LocalCbPojo),
  ?OK.

cb_on_get_all_pay(PayPojo)->
  RoleId = role_adm_mgr:get_roleId(),
  LcPayItemList = lc_pay_pojo:get_pay_list(PayPojo),
  NewLastIndex = lc_pay_pojo:get_pay_index(PayPojo),

  RolePayData = priv_get_data(),
  LastIndex = role_pay_pdb_pojo:get_last_index(RolePayData),
  RolePayItemList_1 = priv_get_new_payList(LcPayItemList,LastIndex,[]),
  RolePayData_1 = role_pay_pdb_pojo:set_last_index(NewLastIndex,RolePayData),
  RolePayData_2 = role_pay_pdb_pojo:put_payList(RolePayItemList_1,RolePayData_1),
  priv_update_data(RolePayData_2),
  %% 通知 lc pay 移除已完成的pay
  lc_pay_app_api:remove_by_index(RoleId,NewLastIndex),
  ?OK.
priv_get_new_payList([LcPayItem |Less],LastIndex,AccItemList) ->
  AccItemList_1 =
  case lc_pay_item:get_index(LcPayItem) > LastIndex of
    ?TRUE ->
      LcPayItem_1 = priv_handle_payItem(LcPayItem),
      [LcPayItem_1|AccItemList];
    ?FALSE -> AccItemList
  end,
  priv_get_new_payList(Less,LastIndex,AccItemList_1);
priv_get_new_payList([],_LastIndex,AccItemList) ->
    AccItemList.

priv_handle_payItem(LcPayItem)->
  LcPayItem_1 =lc_pay_item:set_pay_done(LcPayItem),
  LcPayItem_1.

priv_get_data()->
  RoleId = role_adm_mgr:get_roleId(),
  Data = role_pay_pdb_holder:get_data(RoleId),
  Data.

priv_update_data(MultiData)->
  NewMultiData = role_pay_pdb_pojo:incr_ver(MultiData),
  role_pay_pdb_holder:put_data(NewMultiData),
  ?OK.


