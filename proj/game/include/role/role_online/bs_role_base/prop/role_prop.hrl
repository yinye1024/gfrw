-ifndef(ROLE_PROP_HRL).
-define(ROLE_PROP_HRL, role_prop_hrl).


-define(RP_PercentIdMark,10000).  %% id 超过这个值的是百分比（万分比）数值，小于的是数值
-define(RP_PercentBase,10000).  %% 后台用万分比基数


%% ===================== 树类型 ==================================
-define(RP_TreeType_Player,1).  %% 玩家
-define(RP_TreeType_Hero,2).    %% 英雄

%% ===================== 节点规划 不能重复 （开始） ===========================
%%============= 根节点 固定为1 ======================
-define(RPNodeId_Root,1).

%%============= 父节点 11 - 99 =======================
%% 1 当需要单独获取对应的汇总属性（比方要在界面展示），才在这里加父节点，否则尽量直接用叶节点。
-define(RPNodeId_PNode_FB,11).    %% 联盟汇总属性
-define(RPNodeId_PNode_PB,12).    %% 玩家建筑汇总属性

%%============= 叶节点 1001 开始 ====================
%% 帮派建筑 faction building 1001 到 1100
-define(RPNodeId_Leaf_FB_City,1001).    %% 帮派城市
-define(RPNodeId_Leaf_FB_Tech,1002).    %% 帮派科技

%% 玩家建筑 player building，
-define(RPNodeId_Leaf_PB_Gm,    2001).      %% 玩家GM属性
-define(RPNodeId_Leaf_PB_Base,  2002).      %% 玩家基础属性
-define(RPNodeId_Leaf_PB_Home,  2003).      %% 家园建筑
-define(RPNodeId_Leaf_PB_Master,2004).    %% 掌门属性


%% 玩家英雄 player building，需要HeroId才能获取的属性
-define(RPNodeId_Leaf_Hero_Base,  3001).         %% 玩家英雄基础属性
-define(RPNodeId_Leaf_Hero_DanYao,3002).       %% 丹药
-define(RPNodeId_Leaf_Hero_FuWen, 3003).        %% 符文
-define(RPNodeId_Leaf_Hero_Equip, 3004).        %% 装备
-define(RPNodeId_Leaf_Hero_ShenGe,3005).       %% 神格
-define(RPNodeId_Leaf_Hero_Realm, 3006).        %% 境界





%% ===================== 节点规划 不能重复 （结束） ===========================
-endif.
