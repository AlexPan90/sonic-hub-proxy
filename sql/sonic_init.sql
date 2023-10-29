# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# Database: sonic
# Generation Time: 2023-10-29 09:00:06 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table devices
# ------------------------------------------------------------

# Dump of table elements
# ------------------------------------------------------------

DROP TABLE IF EXISTS `elements`;

CREATE TABLE `elements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ele_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '控件名称',
  `ele_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '控件类型',
  `ele_value` longtext COLLATE utf8mb4_unicode_ci COMMENT '控件内容',
  `project_id` int(11) NOT NULL COMMENT '所属项目id',
  `module_id` int(11) DEFAULT '0' COMMENT '所属项目id',
  PRIMARY KEY (`id`),
  KEY `actable_idx_IDX_PROJECT_ID` (`project_id`),
  KEY `actable_idx_IDX_MODULE_ID` (`module_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='控件元素表';

LOCK TABLES `elements` WRITE;
/*!40000 ALTER TABLE `elements` DISABLE KEYS */;

INSERT INTO `elements` (`id`, `ele_name`, `ele_type`, `ele_value`, `project_id`, `module_id`)
VALUES
	(3,'【小红书 - 列表】帖子标题','xpath','//android.widget.TextView[@resource-id=\'com.xingin.xhs:id/dya\']',1,0),
	(7,'获取账号名称','xpath','//android.widget.TextView[@resource-id=\'com.xingin.xhs:id/fz1\']',1,0),
	(8,'获取账号ID','xpath','//android.widget.TextView[@resource-id=\'com.xingin.xhs:id/fz2\']',1,0),
	(9,'退出登录','xpath','//android.widget.TextView[@resource-id=\'com.xingin.xhs:id/akp\']',1,0),
	(10,'退出登录确认按钮','xpath','//android.widget.Button[@resource-id=\'android:id/button1\']',1,0),
	(11,'退出登录取消按钮','xpath','//android.widget.Button[@resource-id=\'android:id/button2\']',1,0),
	(12,'【登录】 同意按钮','xpath','//android.widget.ImageView[@resource-id=\'com.xingin.xhs:id/fwm\']',1,0),
	(13,'【登录】 其他方式登录 按钮','xpath','//android.widget.TextView[@resource-id=\'com.xingin.xhs:id/fkx\']',1,0),
	(14,'【登录】手机登录','xpath','//android.widget.ImageView[@resource-id=\'com.xingin.xhs:id/ale\']',1,0),
	(15,'【登录】输入手机号','xpath','//android.widget.EditText[@resource-id=\'com.xingin.xhs:id/ee_\']',1,0),
	(16,'xhs_post_button','xpath','//android.widget.RelativeLayout[@resource-id=\'com.xingin.xhs:id/d79\']',1,1),
	(18,'xhs_post_select_images_button','xpath','//android.widget.FrameLayout[@resource-id=\'com.xingin.xhs:id/grk\']',1,1),
	(19,'xhs_post_select_images_next_button','xpath','//android.widget.TextView[@resource-id=\'com.xingin.xhs:id/a32\']',1,1),
	(20,'xhs_post_select_images_confirm_button','xpath','//android.widget.TextView[@resource-id=\'com.xingin.xhs:id/axd\']',1,1),
	(21,'xhs_post_title_input','xpath','//android.widget.EditText[@resource-id=\'com.xingin.xhs:id/bi9\']',1,1),
	(22,'xhs_post_content_input','xpath','//android.widget.EditText[@resource-id=\'com.xingin.xhs:id/bgt\']',1,1),
	(23,'xhs_post_publish_button','xpath','//android.widget.Button[@resource-id=\'com.xingin.xhs:id/abj\']',1,1),
	(24,'xhs_post_save_exit_button','xpath','//android.widget.Button[@resource-id=\'com.xingin.xhs:id/isx\']',1,1),
	(25,'xhs_post_publish_cancel_button','xpath','//android.widget.Button[@resource-id=\'com.xingin.xhs:id/a91\']',1,1),
	(26,'xhs_post_select_location_button','xpath','//android.widget.TextView[@resource-id=\'com.xingin.xhs:id/fbr\']',1,1),
	(27,'xhs_post_search_location_input','xpath','//android.widget.EditText[@resource-id=\'com.xingin.xhs:id/hf7\']',1,1),
	(28,'xhs_post_confirm_location_button','xpath','//android.widget.RelativeLayout[@resource-id=\'com.xingin.xhs:id/dpd\']',1,1),
	(29,'xhs_post_mine','xpath','//android.widget.TextView[@resource-id=\'com.xingin.xhs:id/har\']',1,1),
	(30,'xhs_home_button','xpath','//android.widget.TextView[@resource-id=\'com.xingin.xhs:id/har\']',1,1);

/*!40000 ALTER TABLE `elements` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table global_params
# ------------------------------------------------------------

DROP TABLE IF EXISTS `global_params`;

CREATE TABLE `global_params` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `params_key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '参数key',
  `params_value` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '参数value',
  `project_id` int(11) NOT NULL COMMENT '所属项目id',
  PRIMARY KEY (`id`),
  KEY `actable_idx_IDX_PROJECT_ID` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='全局参数表';

LOCK TABLES `global_params` WRITE;
/*!40000 ALTER TABLE `global_params` DISABLE KEYS */;

INSERT INTO `global_params` (`id`, `params_key`, `params_value`, `project_id`)
VALUES
	(1,'global_content_url','http://127.0.0.1:8080/get',1),
	(2,'global_xhs_account_id','//android.widget.TextView[@resource-id=\'com.xingin.xhs:id/fz2\']	',1),
	(3,'global_xhs_account_name','//android.widget.TextView[@resource-id=\'com.xingin.xhs:id/fz1\']',1),
	(4,'global_xhs_account_button','//android.view.ViewGroup[@resource-id=\'com.xingin.xhs:id/d77\']',1),
	(5,'global_xhs_view_post_return_button','//android.widget.ImageView[@resource-id=\'com.xingin.xhs:id/fyb\']',1),
	(6,'global_xhs_shop_goods_detail_return_button','//android.widget.ImageView[@resource-id=\'com.xingin.xhs:id/caf\']',1),
	(7,'global_friend_details_return_button','//android.widget.ImageView[@resource-id=\'com.xingin.xhs:id/fyb\']',1),
	(8,'xhs_post_select_images_button','//android.widget.FrameLayout[@resource-id=\'com.xingin.xhs:id/grk\']	',1),
	(9,'global_xhs_mine_posts','//android.view.View[@resource-id=\'com.xingin.xhs:id/h43\']',1);

/*!40000 ALTER TABLE `global_params` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table modules
# ------------------------------------------------------------

DROP TABLE IF EXISTS `modules`;

CREATE TABLE `modules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `project_id` int(11) NOT NULL COMMENT '所属项目名称',
  PRIMARY KEY (`id`),
  KEY `actable_idx_IDX_PROJECT_ID` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='模块表';

LOCK TABLES `modules` WRITE;
/*!40000 ALTER TABLE `modules` DISABLE KEYS */;

INSERT INTO `modules` (`id`, `name`, `project_id`)
VALUES
	(1,'【小红书】- 发帖',1);

/*!40000 ALTER TABLE `modules` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table projects
# ------------------------------------------------------------

DROP TABLE IF EXISTS `projects`;

CREATE TABLE `projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `edit_time` datetime DEFAULT NULL COMMENT '更改时间',
  `project_des` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '项目描述',
  `project_img` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '项目封面',
  `project_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '项目名',
  `robot_secret` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '机器人秘钥',
  `robot_token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '机器人token',
  `robot_type` int(11) NOT NULL COMMENT '机器人类型',
  `testsuite_alert_robot_ids` varchar(1024) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '项目内测试套件默认通知机器人，逗号分隔id串，为null时自动选取所有可用机器人',
  `global_robot` bit(1) NOT NULL DEFAULT b'1' COMMENT '启用全局机器人',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='项目表';

LOCK TABLES `projects` WRITE;
/*!40000 ALTER TABLE `projects` DISABLE KEYS */;

INSERT INTO `projects` (`id`, `edit_time`, `project_des`, `project_img`, `project_name`, `robot_secret`, `robot_token`, `robot_type`, `testsuite_alert_robot_ids`, `global_robot`)
VALUES
	(1,'2023-08-19 17:06:43',"Feiyu's sonic server service",'http://192.168.1.11:3000/server/api/folder/keepFiles/20230819/dacc3610-dc15-47ad-afb7-617d34d0e722.png','Feiyu','','',-1,NULL,b'1');

/*!40000 ALTER TABLE `projects` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table scripts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `scripts`;

CREATE TABLE `scripts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL COMMENT '所属项目id',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'name',
  `script_language` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'language',
  `content` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'content',
  PRIMARY KEY (`id`),
  KEY `actable_idx_IDX_PROJECT_ID` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='scripts表';

LOCK TABLES `scripts` WRITE;
/*!40000 ALTER TABLE `scripts` DISABLE KEYS */;

INSERT INTO `scripts` (`id`, `project_id`, `name`, `script_language`, `content`)
VALUES
	(3,1,'OpenXiaohongshu','Groovy','import com.alibaba.fastjson.JSONObject;\nimport org.springframework.http.HttpEntity;\nimport org.springframework.http.HttpHeaders;\nimport org.springframework.http.HttpMethod;\nimport org.springframework.web.client.RestTemplate;\nimport org.cloud.sonic.agent.tools.SpringTool;\nimport org.cloud.sonic.agent.tests.LogUtil;\nimport org.cloud.sonic.agent.common.interfaces.StepType;\n\ndef GetSN() {\n  String SN = androidStepHandler.iDevice.getSerialNumber()\n  return SN\n}\n\ndef GetContentURL() {\n  String url = androidStepHandler.globalParams.getString(\"global_content_url\")\n  return url\n}\n\ndef Request(String url){\n      LogUtil log =  androidStepHandler.log\n      \n      RestTemplate restTemplate = SpringTool.getBean(RestTemplate.class)\n      \n      HttpHeaders headers = new HttpHeaders()\n      headers.add(\"auth-token\", \"qa-test-20230820\")\n  \n      JSONObject result = restTemplate.exchange(url, HttpMethod.GET, new HttpEntity<>(headers),JSONObject.class).getBody()\n      \n      //assertEquals(result.getInteger(\"code\"), 200)\n  \n      log.sendStepLog(StepType.INFO,\"rest api assert\",\"result: \" + result.toJSONString())\n}\n\ndef main(){\n  LogUtil log = androidStepHandler.log\n  \n  sn = GetSN()\n  log.sendStepLog(StepType.INFO, \"current_sn\", sn)\n    \n  apiURL = GetContentURL()\n  log.sendStepLog(StepType.INFO,\"request_url\", apiURL)\n  \n  Request(apiURL)\n}\n\nmain()\n'),
	(4,1,'PostXiaohonshu','Groovy','import org.cloud.sonic.driver.android.service.AndroidElement;\nimport org.cloud.sonic.driver.android.AndroidDriver;\nimport org.cloud.sonic.driver.android.enmus.AndroidSelector;\n\ndef GetElementWithXpath(String xpath) {\n  AndroidDriver androidDriver = androidStepHandler.androidDriver;\n\n  List<AndroidElement> element = androidDriver.findElementList(AndroidSelector.XPATH, xpath);\n\n  androidStepHandler.log.sendStepLog(1, elementList.getText());\n}\n\nGetElementWithXpath(\"//android.widget.TextView[@resource-id=\'com.xingin.xhs:id/dya\']\")');

/*!40000 ALTER TABLE `scripts` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table steps
# ------------------------------------------------------------

DROP TABLE IF EXISTS `steps`;

CREATE TABLE `steps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) NOT NULL DEFAULT '0' COMMENT '父级id，一般父级都是条件步骤',
  `case_id` int(11) NOT NULL COMMENT '所属测试用例id',
  `content` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '输入文本',
  `error` int(11) NOT NULL COMMENT '异常处理类型',
  `platform` int(11) NOT NULL COMMENT '设备系统类型',
  `project_id` int(11) NOT NULL COMMENT '所属项目id',
  `sort` int(11) NOT NULL COMMENT '排序号',
  `step_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '步骤类型',
  `text` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '其它信息',
  `condition_type` int(11) NOT NULL DEFAULT '0' COMMENT '条件类型',
  `disabled` int(11) NOT NULL DEFAULT '0' COMMENT '是否禁用',
  PRIMARY KEY (`id`),
  KEY `actable_idx_IDX_CASE_ID` (`case_id`),
  KEY `actable_idx_IDX_PROJECT_ID` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='测试步骤表';

LOCK TABLES `steps` WRITE;
/*!40000 ALTER TABLE `steps` DISABLE KEYS */;

INSERT INTO `steps` (`id`, `parent_id`, `case_id`, `content`, `error`, `platform`, `project_id`, `sort`, `step_type`, `text`, `condition_type`, `disabled`)
VALUES
	(1,0,0,'',3,1,1,1,'openApp','小红书',0,0),
	(2,0,0,'',3,1,1,2,'openApp','小红书',0,0),
	(4,0,0,'',3,1,1,3,'openApp','小红书',0,0),
	(6,0,3,'import com.alibaba.fastjson.JSONObject;\nimport org.springframework.http.HttpEntity;\nimport org.springframework.http.HttpHeaders;\nimport org.springframework.http.HttpMethod;\nimport org.springframework.web.client.RestTemplate;\nimport org.cloud.sonic.agent.tools.SpringTool;\nimport org.cloud.sonic.agent.tests.LogUtil;\nimport org.cloud.sonic.agent.common.interfaces.StepType;\n\ndef GetSN() {\n  String SN = androidStepHandler.iDevice.getSerialNumber()\n  return SN\n}\n\ndef GetContentURL() {\n  String url = androidStepHandler.globalParams.getString(\"global_content_url\")\n  return url\n}\n\ndef Request(String url){\n      LogUtil log =  androidStepHandler.log\n      \n      RestTemplate restTemplate = SpringTool.getBean(RestTemplate.class)\n      \n      HttpHeaders headers = new HttpHeaders()\n      headers.add(\"auth-token\", \"qa-test-20230820\")\n  \n      JSONObject result = restTemplate.exchange(url, HttpMethod.GET, new HttpEntity<>(headers),JSONObject.class).getBody()\n      \n      //assertEquals(result.getInteger(\"code\"), 200)\n  \n      log.sendStepLog(StepType.INFO,\"rest api assert\",\"result: \" + result.toJSONString())\n}\n\ndef main(){\n  LogUtil log = androidStepHandler.log\n  \n  sn = GetSN()\n  log.sendStepLog(StepType.INFO, \"current_sn\", sn)\n    \n  apiURL = GetContentURL()\n  log.sendStepLog(StepType.INFO,\"request_url\", apiURL)\n  \n  Request(apiURL)\n}\n\nmain()\n',1,1,1,4,'runScript','Groovy',1,0),
	(7,6,3,'',1,1,1,5,'openApp','com.xingin.xhs',1,0),
	(9,8,3,'ADB',1,1,1,7,'switchTouchMode','',4,0),
	(10,9,3,'100',1,1,1,8,'swipeByDefinedDirection','down',1,0),
	(11,7,3,'SONIC_APK',1,1,1,9,'switchTouchMode','',1,0),
	(12,11,3,'500',1,1,1,10,'swipeByDefinedDirection','up',1,0),
	(13,12,3,'post_title',1,1,1,11,'getTextValue','',1,0),
	(14,13,3,'',3,1,1,12,'stepScreen','',0,0),
	(17,0,6,'',1,1,1,15,'openApp','com.xingin.xhs',1,0),
	(18,17,6,'',1,1,1,17,'click','',1,0),
	(19,18,6,'import org.cloud.sonic.driver.android.service.AndroidElement;\nimport org.cloud.sonic.driver.android.AndroidDriver;\nimport org.cloud.sonic.driver.android.enmus.AndroidSelector;\nimport org.cloud.sonic.driver.common.tool.SonicRespException;\nimport org.cloud.sonic.agent.bridge.android.AndroidDeviceBridgeTool;\n\ndef GetElementsWithXpath(String xpath) {\n  AndroidDriver androidDriver = androidStepHandler.androidDriver;\n  elements = androidDriver.findElementList(AndroidSelector.XPATH, xpath)\n  return elements\n}\n    \ndef SelectImages() {    \n  def imageSizeStr = androidStepHandler.globalParams.getString(\"xhs_post_images_count_temp\")\n  def imageSize = imageSizeStr.toInteger()\n  try {\n      String imageButton = androidStepHandler.globalParams.getString(\"xhs_post_select_images_button\")\n      w = GetElementsWithXpath(imageButton);\n      for (int i = 0; i < imageSize; i++) {\n        w[i].click();\n      }\n   } catch (SonicRespException e) {\n      println(e);\n   } catch (Exception e) {\n      println(e);\n   }\n}\n\nSelectImages();\n',1,1,1,18,'runScript','Groovy',1,0),
	(21,20,6,'',1,1,1,20,'click','',1,0),
	(22,21,6,'{{xhs_post_title_temp}}',1,1,1,21,'sendKeysByActions','',1,0),
	(23,22,6,'{{xhs_post_content_temp}}',1,1,1,22,'sendKeysByActions','',1,0),
	(24,17,6,'import org.cloud.sonic.driver.android.service.AndroidElement;\nimport org.cloud.sonic.driver.android.AndroidDriver;\nimport org.cloud.sonic.driver.android.enmus.AndroidSelector;\nimport org.cloud.sonic.driver.common.tool.SonicRespException;\nimport org.cloud.sonic.agent.bridge.android.AndroidDeviceBridgeTool;\nimport org.springframework.http.HttpEntity;\nimport org.springframework.http.HttpHeaders;\nimport org.springframework.http.MediaType;\nimport org.springframework.http.ResponseEntity;\nimport org.springframework.web.client.RestTemplate;\nimport com.alibaba.fastjson.JSON;\nimport com.alibaba.fastjson.JSONArray;\nimport com.alibaba.fastjson.JSONObject;\n\ndef GetElementTextWithXpath(String xpath) {\n  AndroidDriver androidDriver = androidStepHandler.androidDriver;\n  AndroidElement w = androidDriver.findElement(AndroidSelector.XPATH, xpath);\n  return w.getText()\n}\n\ndef GetSingleElementWithXpath(String xpath) {\n  AndroidDriver androidDriver = androidStepHandler.androidDriver;\n  AndroidElement w = androidDriver.findElement(AndroidSelector.XPATH, xpath);\n  return w\n}\n\ndef parseAccountIDFromString(String input) {\n    def pattern = /(\\d+)/\n    def matcher = (input =~ pattern)\n    \n    if (matcher.find()) {\n        return matcher[0][1]\n    } else {\n        return null\n    }\n}\n\ndef ReturnButtons = [\n  \"global_xhs_view_post_return_button\", \n  \"global_xhs_shop_goods_detail_return_button\", \n  \"global_friend_details_return_button\"\n];\n  \ndef ReturnPageWithAccountButton() {\n  for (String xpath in ReturnButtons) {\n       try {\n         String xpathAccountButton = androidStepHandler.globalParams.getString(xpath)\n         w = GetSingleElementWithXpath(xpathAccountButton)\n         w.click();\n         break;\n       } catch (SonicRespException e) {\n        continue;\n       } catch (Exception e) {\n       }\n  }\n}\n\ndef EnterAccountPage() {\n  //点击账号信息按钮\n  try {\n      String xpathAccountButton = androidStepHandler.globalParams.getString(\"global_xhs_account_button\")\n      w = GetSingleElementWithXpath(xpathAccountButton)\n      w.click();\n   } catch (SonicRespException e) {\n      //\n     ReturnPageWithAccountButton()\n   } catch (Exception e) {\n      \n   }\n}\n\nboolean downloadImage(String imageUrl) {\n   AndroidDeviceBridgeTool.pushToCamera(androidStepHandler.iDevice, imageUrl)\n}\n\n\ndef GetXHSAccountInfo() {\n  \n  EnterAccountPage()\n    \n  Thread.sleep(1000);\n  \n  String xpathAccountID = androidStepHandler.globalParams.getString(\"global_xhs_account_id\")\n  accountID = parseAccountIDFromString(GetElementTextWithXpath(xpathAccountID))\n    \n  String xpathAccountName = androidStepHandler.globalParams.getString(\"global_xhs_account_name\")\n  accountName = GetElementTextWithXpath(xpathAccountName)\n}\n\n// 获取任务内容\ndef GetTask(String apiUrl) {\n    // 创建 RestTemplate 实例\n    RestTemplate restTemplate = new RestTemplate();\n\n    // 设置请求头\n    HttpHeaders headers = new HttpHeaders();\n    headers.setContentType(MediaType.APPLICATION_JSON);\n\n    device_id = androidStepHandler.getUdId()\n\n    // 设置请求体数据\n    String requestBody = \"{\\\"SonicDeviceID\\\": \\\"\" + device_id + \"\\\"}\";\n\n    // 将请求头和请求体组合成 HttpEntity\n    HttpEntity<String> requestEntity = new HttpEntity<>(requestBody, headers);\n\n    // 发送 POST 请求\n    ResponseEntity<String> responseEntity = restTemplate.postForEntity(apiUrl, requestEntity, String.class);\n\n    // 检查响应状态码\n    if (responseEntity.getStatusCode().is2xxSuccessful()) {\n        // 获取响应数据\n        String responseBody = responseEntity.getBody();\n        JSONObject resp = JSONObject.parseObject(responseBody);\n        JSONObject data = resp.getJSONObject(\"data\");\n      \n        JSONArray extra = data.getJSONArray(\"extra_data\");\n       \n        JSONObject extraData = extra.getJSONObject(0);\n        String title = extraData.getString(\"title\");\n      \n        androidStepHandler.globalParams.put(\"xhs_post_title_temp\", title)\n        \n        String description = extraData.getString(\"description\");\n        androidStepHandler.globalParams.put(\"xhs_post_content_temp\", description)\n        \n        JSONArray images = extraData.getJSONArray(\"image_url_list\");\n        for (int i = 0; i < images.size(); i++) {\n           String imageURL = images.getString(i);\n           downloadImage(imageURL)\n        }\n        androidStepHandler.globalParams.put(\"xhs_post_images_count_temp\", images.size())\n        \n        return responseBody\n    } else {\n        return responseEntity.getStatusCode()\n    }\n}\n\ndef init() {\n   // 获取任务\n   responseBody = GetTask(\"http://192.168.1.15:9123/v1/task/get\")\n   \n   // 获取账户信息\n   GetXHSAccountInfo()\n}\n\ninit()',1,1,1,16,'runScript','Groovy',1,0),
	(26,25,6,'你好，我的无聊周末',1,1,1,24,'sendKeysByActions','',1,0),
	(27,26,6,'无聊的周六在家清理鱼缸，哎！！！',1,1,1,26,'sendKeysByActions','',1,0),
	(28,0,5,'import org.cloud.sonic.driver.android.service.AndroidElement;\nimport org.cloud.sonic.driver.android.AndroidDriver;\nimport org.cloud.sonic.driver.android.enmus.AndroidSelector;\nimport org.cloud.sonic.driver.common.tool.SonicRespException;\nimport org.cloud.sonic.agent.bridge.android.AndroidDeviceBridgeTool;\n\ndef GetElementsWithXpath(String xpath) {\n  AndroidDriver androidDriver = androidStepHandler.androidDriver;\n  elements = androidDriver.findElementList(AndroidSelector.XPATH, xpath)\n  return elements\n}\n    \ndef SelectPost() {    \n  // title = androidStepHandler.globalParams.getString(\"xhs_post_title_temp\")\n  title = \"我的标题\"\n  try {\n      String postXpath = androidStepHandler.globalParams.getString(\"global_xhs_mine_posts\")\n      w = GetElementsWithXpath(postXpath);\n      for (int i = 0; i < w.size(); i++) {\n        value = w[i].getText()\n        if value == title {\n           w[i].click();\n        }\n      }\n   } catch (SonicRespException e) {\n      println(e);\n   } catch (Exception e) {\n      println(e);\n   }\n}\n\nSelectPost();',1,1,1,27,'runScript','Groovy',1,0),
	(29,17,6,'',1,1,1,28,'click','',1,0),
	(31,29,6,'',1,1,1,29,'click','',1,0),
	(32,31,6,'{{xhs_post_title_temp}}',1,1,1,30,'sendKeys','',1,0),
	(33,32,6,'{{xhs_post_content_temp}}',1,1,1,31,'sendKeys','',1,0),
	(35,17,6,'',1,1,1,32,'click','',1,0),
	(37,36,6,'{{xhs_post_title_temp}}',1,1,1,35,'sendKeys','',1,0),
	(38,37,6,'{{xhs_post_content_temp}}',1,1,1,38,'sendKeys','',1,0),
	(39,35,6,'',1,1,1,39,'click','',1,0),
	(41,39,6,'1000',1,1,1,40,'stepHold','',1,0),
	(42,41,6,'',1,1,1,41,'click','',1,0);

/*!40000 ALTER TABLE `steps` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table steps_elements
# ------------------------------------------------------------

DROP TABLE IF EXISTS `steps_elements`;

CREATE TABLE `steps_elements` (
  `steps_id` int(11) NOT NULL COMMENT '步骤id',
  `elements_id` int(11) NOT NULL COMMENT '控件id'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='步骤 - 控件 关系映射表';

LOCK TABLES `steps_elements` WRITE;
/*!40000 ALTER TABLE `steps_elements` DISABLE KEYS */;

INSERT INTO `steps_elements` (`steps_id`, `elements_id`)
VALUES
	(13,3),
	(18,16),
	(21,20),
	(26,21),
	(27,22),
	(22,21),
	(23,22),
	(29,19),
	(31,20),
	(32,21),
	(33,22),
	(37,21),
	(38,22),
	(35,23),
	(39,29),
	(42,30);

/*!40000 ALTER TABLE `steps_elements` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table test_cases
# ------------------------------------------------------------

DROP TABLE IF EXISTS `test_cases`;

CREATE TABLE `test_cases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `des` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用例描述',
  `designer` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用例设计人',
  `edit_time` datetime NOT NULL COMMENT '最后修改日期',
  `module_id` int(11) DEFAULT '0' COMMENT '所属模块',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用例名称',
  `platform` int(11) NOT NULL COMMENT '设备系统类型',
  `project_id` int(11) NOT NULL COMMENT '所属项目id',
  `version` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '版本号',
  PRIMARY KEY (`id`),
  KEY `actable_idx_IDX_MODULE_ID` (`module_id`),
  KEY `actable_idx_IDX_PROJECT_ID` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='测试用例表';

LOCK TABLES `test_cases` WRITE;
/*!40000 ALTER TABLE `test_cases` DISABLE KEYS */;

INSERT INTO `test_cases` (`id`, `des`, `designer`, `edit_time`, `module_id`, `name`, `platform`, `project_id`, `version`)
VALUES
	(3,'','admin','2023-08-22 23:23:06',0,'小红书',1,1,''),
	(4,'','admin','2023-08-23 00:26:50',0,'IOS',2,1,''),
	(5,'','admin','2023-08-24 23:21:10',0,'测试',1,1,''),
	(6,'','admin','2023-09-17 18:58:16',0,'【小红书】发帖',1,1,'');

/*!40000 ALTER TABLE `test_cases` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table test_suites
# ------------------------------------------------------------

DROP TABLE IF EXISTS `test_suites`;

CREATE TABLE `test_suites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cover` int(11) NOT NULL COMMENT '覆盖类型',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '测试套件名字',
  `platform` int(11) NOT NULL COMMENT '测试套件系统类型（android、ios...）',
  `is_open_perfmon` int(11) NOT NULL DEFAULT '0' COMMENT '是否采集系统性能数据',
  `perfmon_interval` int(11) NOT NULL DEFAULT '1000' COMMENT '采集性能数据间隔',
  `project_id` int(11) NOT NULL COMMENT '覆盖类型',
  `alert_robot_ids` varchar(1024) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '项目内测试套件默认通知配置，为null时取项目配置的默认值',
  PRIMARY KEY (`id`),
  KEY `actable_idx_IDX_PROJECT_ID` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='测试套件表';

LOCK TABLES `test_suites` WRITE;
/*!40000 ALTER TABLE `test_suites` DISABLE KEYS */;

INSERT INTO `test_suites` (`id`, `cover`, `name`, `platform`, `is_open_perfmon`, `perfmon_interval`, `project_id`, `alert_robot_ids`)
VALUES
	(1,2,'【小红书】帖子浏览',1,0,1000,1,NULL),
	(2,2,'【小红书】自动登录',1,0,1000,1,NULL),
	(3,2,'red_content_publish',1,0,1000,1,NULL),
	(4,2,'测试001',1,0,1000,1,NULL);

/*!40000 ALTER TABLE `test_suites` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table test_suites_test_cases
# ------------------------------------------------------------

DROP TABLE IF EXISTS `test_suites_test_cases`;

CREATE TABLE `test_suites_test_cases` (
  `test_suites_id` int(11) NOT NULL COMMENT '测试套件id',
  `test_cases_id` int(11) NOT NULL COMMENT '测试用例id',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序用'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='测试套件 - 测试用例 关系映射表';

LOCK TABLES `test_suites_test_cases` WRITE;
/*!40000 ALTER TABLE `test_suites_test_cases` DISABLE KEYS */;

INSERT INTO `test_suites_test_cases` (`test_suites_id`, `test_cases_id`, `sort`)
VALUES
	(1,3,1),
	(2,5,1),
	(3,6,1),
	(4,5,1);

/*!40000 ALTER TABLE `test_suites_test_cases` ENABLE KEYS */;
UNLOCK TABLES;


/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
