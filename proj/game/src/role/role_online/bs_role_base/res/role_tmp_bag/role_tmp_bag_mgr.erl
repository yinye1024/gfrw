%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%    异步交易的时候，比如跨进程消费，用来保存临时扣除的物件，
%%    1 如果失败要还原物品
%%    2 成功则移除临时背包的记录
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(role_tmp_bag_mgr).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([proc_init/0]).

-export([new_item/2,get_and_rm_item/1]).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
proc_init()->
  RoleId = role_adm_mgr:get_roleId(),
  role_tmp_bag_pdb_holder:init(RoleId),
  ?OK.

new_item(OnFailReturn,OnSuccessReturn)->
  Data = priv_get_data(),
  {ItemId,Data_1} = role_tmp_bag_pdb_pojo:new_item(OnFailReturn,OnSuccessReturn,Data),
  priv_update_data(Data_1),
  ItemId.


get_and_rm_item(ItemId)->
  Data = priv_get_data(),
  TmpBagItem = role_tmp_bag_pdb_pojo:get_item(ItemId,Data),
  Data_1 = role_tmp_bag_pdb_pojo:rm_item(ItemId,Data),
  priv_update_data(Data_1),
  TmpBagItem.

priv_get_data()->
  RoleId = role_adm_mgr:get_roleId(),
  Data = role_tmp_bag_pdb_holder:get_data(RoleId),
  Data.

priv_update_data(MultiData)->
  NewMultiData = role_tmp_bag_pdb_pojo:incr_ver(MultiData),
  role_tmp_bag_pdb_holder:put_data(NewMultiData),
  ?OK.
