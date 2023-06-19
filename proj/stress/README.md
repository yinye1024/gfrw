
# 集成和压力测试

## 如何使用

1. src/game_test/robot/bs  目录

   根据业务扩展添加机器人脚本

   robot_XXX_c2s_sender  发送给服务端的协议
   
   robot_XXX_s2c_handler 接收服务端的信息 做处理
   
   robot_XXX_mgr 封装业务接口给外部逻辑串联调用

2. src/game_test/test_suite 目录

   业务集成测试，根据业务做扩展
3. src/game_test/test_stress 目录

   压力测试
   stress_robot_decorator 串联压测的业务逻辑
   bs_stress_adm_mgr 压测tps等的控制逻辑
 



 