# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.7.36)
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


# Dump of table agents
# ------------------------------------------------------------

DROP TABLE IF EXISTS `agents`;

CREATE TABLE `agents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `host` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'agent的ip',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'agent name',
  `port` int(11) NOT NULL COMMENT 'agent的端口',
  `secret_key` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'agent的密钥',
  `status` int(11) NOT NULL COMMENT 'agent的状态',
  `system_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'agent的系统类型',
  `version` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'agent端代码版本',
  `lock_version` bigint(20) NOT NULL DEFAULT '0' COMMENT '乐观锁，优先保证上下线状态落库',
  `high_temp` int(11) NOT NULL DEFAULT '45' COMMENT 'highTemp',
  `high_temp_time` int(11) NOT NULL DEFAULT '15' COMMENT 'highTempTime',
  `robot_secret` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '机器人秘钥',
  `robot_token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '机器人token',
  `robot_type` int(11) NOT NULL DEFAULT '1' COMMENT '机器人类型',
  `has_hub` int(11) NOT NULL DEFAULT '0' COMMENT '是否使用了Sonic hub',
  `alert_robot_ids` varchar(1024) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '逗号分隔通知机器人id串，为null时自动选取所有可用机器人',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='agents表';

LOCK TABLES `agents` WRITE;
/*!40000 ALTER TABLE `agents` DISABLE KEYS */;

INSERT INTO `agents` (`id`, `host`, `name`, `port`, `secret_key`, `status`, `system_type`, `version`, `lock_version`, `high_temp`, `high_temp_time`, `robot_secret`, `robot_token`, `robot_type`, `has_hub`, `alert_robot_ids`)
VALUES
	(1,'192.168.1.3','BZD26268-xia',7777,'30b78a05-cd29-4987-bee1-1a9a4334b97e',2,'Windows 10','v2.6.1',50,80,20,'','',-1,0,NULL);

/*!40000 ALTER TABLE `agents` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table alert_robots
# ------------------------------------------------------------

DROP TABLE IF EXISTS `alert_robots`;

CREATE TABLE `alert_robots` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL COMMENT '可用项目id， null为公共机器人',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '显示名称',
  `robot_secret` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '机器人秘钥',
  `robot_token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '机器人token/接口uri',
  `robot_type` int(11) NOT NULL COMMENT '机器人类型',
  `scene` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '使用场景，可选 agent, testsuite, summary',
  `mute_rule` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '静默规则，SpEL表达式，表达式求值为true时不发送消息，否则正常发送',
  `template` varchar(4096) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '通知模板，SpEL表达式，表达式为空时机器人类型自动使用默认值',
  PRIMARY KEY (`id`),
  KEY `actable_idx_IDX_PROJECT_ID` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='alert_robots表';

LOCK TABLES `alert_robots` WRITE;
/*!40000 ALTER TABLE `alert_robots` DISABLE KEYS */;

INSERT INTO `alert_robots` (`id`, `project_id`, `name`, `robot_secret`, `robot_token`, `robot_type`, `scene`, `mute_rule`, `template`)
VALUES
	(1,1,'设备状态',NULL,'1',3,'agent','','**Sonic设备高温#{errorType == 1 ? \'预警\' : \'超时，已关机！\'}**\n设备序列号：#{udId}\n电池温度：#{tem}℃');

/*!40000 ALTER TABLE `alert_robots` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table conf_list
# ------------------------------------------------------------

DROP TABLE IF EXISTS `conf_list`;

CREATE TABLE `conf_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `conf_key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '业务key',
  `content` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '内容',
  `extra` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '扩展信息',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `actable_idx_conf_key` (`conf_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='配置信息表';

LOCK TABLES `conf_list` WRITE;
/*!40000 ALTER TABLE `conf_list` DISABLE KEYS */;

INSERT INTO `conf_list` (`id`, `conf_key`, `content`, `extra`, `create_time`, `update_time`)
VALUES
	(1,'resource','2.6.1',NULL,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(2,'remote-debug-timeout','480',NULL,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(3,'idle-debug-timeout','480',NULL,'2023-08-19 17:05:03','2023-08-19 17:05:03');

/*!40000 ALTER TABLE `conf_list` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table devices
# ------------------------------------------------------------

DROP TABLE IF EXISTS `devices`;

CREATE TABLE `devices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `agent_id` int(11) NOT NULL COMMENT '所属agent的id',
  `cpu` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'cpu架构',
  `img_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '手机封面',
  `manufacturer` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '制造商',
  `model` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '手机型号',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '设备名称',
  `password` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '设备安装app的密码',
  `platform` int(11) NOT NULL COMMENT '系统类型 1：android 2：ios',
  `is_hm` int(11) NOT NULL DEFAULT '0' COMMENT '是否为鸿蒙类型 1：鸿蒙 0：非鸿蒙',
  `size` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '设备分辨率',
  `status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '设备状态',
  `ud_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '设备序列号',
  `version` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '设备系统版本',
  `nick_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '设备备注',
  `user` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '设备当前占用者',
  `chi_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '中文设备',
  `temperature` int(11) DEFAULT '0' COMMENT '设备温度',
  `voltage` int(11) DEFAULT '0' COMMENT '设备电池电压',
  `level` int(11) DEFAULT '0' COMMENT '设备电量',
  `position` int(11) DEFAULT '0' COMMENT 'HUB位置',
  PRIMARY KEY (`id`),
  KEY `actable_idx_IDX_UD_ID` (`ud_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='设备表';

LOCK TABLES `devices` WRITE;
/*!40000 ALTER TABLE `devices` DISABLE KEYS */;

INSERT INTO `devices` (`id`, `agent_id`, `cpu`, `img_url`, `manufacturer`, `model`, `name`, `password`, `platform`, `is_hm`, `size`, `status`, `ud_id`, `version`, `nick_name`, `user`, `chi_name`, `temperature`, `voltage`, `level`, `position`)
VALUES
	(1,1,'armeabi-v7a','','Xiaomi','MI 4LTE','cancro_wc_lte','',1,0,'','ONLINE','a16d6dbc','6.0.1','','admin','',324,4314,100,0),
	(2,1,'arm64-v8a','','Xiaomi','MI 5','gemini','',1,0,'1080x1920','OFFLINE','35ffa1b5','8.0.0','','admin','',387,4177,69,0),
	(3,1,'arm64-v8a','','Xiaomi','MI 5','gemini','',1,0,'1080x1920','OFFLINE','4d3417d','8.0.0','','admin','',397,4235,65,0),
	(4,1,'arm64-v8a','','Xiaomi','MI 5','gemini','',1,0,'1080x1920','OFFLINE','67045831','8.0.0','','admin','',380,4405,92,0),
	(5,1,'arm64-v8a','','Xiaomi','MI 5','test-J','',1,0,'1080x1920','ONLINE','4d3417d','8.0.0','','admin','',380,4405,92,0);

/*!40000 ALTER TABLE `devices` ENABLE KEYS */;
UNLOCK TABLES;


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


# Dump of table jobs
# ------------------------------------------------------------

DROP TABLE IF EXISTS `jobs`;

CREATE TABLE `jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cron_expression` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'cron表达式',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务名称',
  `project_id` int(11) NOT NULL COMMENT '所属项目id',
  `status` int(11) NOT NULL COMMENT '任务状态 1：开启 2：关闭',
  `suite_id` int(11) NOT NULL COMMENT '测试套件id',
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'testJob' COMMENT '定时任务类型',
  PRIMARY KEY (`id`),
  KEY `actable_idx_IDX_PROJECT_ID` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='定时任务表';

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;

INSERT INTO `jobs` (`id`, `cron_expression`, `name`, `project_id`, `status`, `suite_id`, `type`)
VALUES
	(1,'0 0 12 15 * ?','清理系统文件',0,1,0,'cleanFile'),
	(2,'0 0 12 15 * ?','清理测试报告',0,1,0,'cleanResult'),
	(3,'0 0 10 * * ?','发送日报',0,1,0,'sendDayReport'),
	(4,'0 0 10 ? * MON','发送周报',0,1,0,'sendWeekReport');

/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
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


# Dump of table packages
# ------------------------------------------------------------

DROP TABLE IF EXISTS `packages`;

CREATE TABLE `packages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL COMMENT '项目描述',
  `pkg_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '安装包名称',
  `platform` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '平台',
  `branch` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '构建分支',
  `url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '下载地址',
  `build_url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '来源地址',
  `create_time` datetime NOT NULL COMMENT '任务创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='安装包表';



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
	(1,'2023-08-19 17:06:43','Xinfos Test.','http://192.168.1.11:3000/server/api/folder/keepFiles/20230819/dacc3610-dc15-47ad-afb7-617d34d0e722.png','Xinfos','','',-1,NULL,b'1');

/*!40000 ALTER TABLE `projects` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table public_steps
# ------------------------------------------------------------

DROP TABLE IF EXISTS `public_steps`;

CREATE TABLE `public_steps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公共步骤名称',
  `platform` int(11) NOT NULL COMMENT '公共步骤系统类型（android、ios...）',
  `project_id` int(11) NOT NULL COMMENT '所属项目id',
  PRIMARY KEY (`id`),
  KEY `actable_idx_IDX_PROJECT_ID` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='公共步骤表';



# Dump of table public_steps_steps
# ------------------------------------------------------------

DROP TABLE IF EXISTS `public_steps_steps`;

CREATE TABLE `public_steps_steps` (
  `public_steps_id` int(11) NOT NULL COMMENT '公共步骤id',
  `steps_id` int(11) NOT NULL COMMENT '步骤id'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='公共步骤 - 步骤 关系映射表';



# Dump of table QRTZ_BLOB_TRIGGERS
# ------------------------------------------------------------

DROP TABLE IF EXISTS `QRTZ_BLOB_TRIGGERS`;

CREATE TABLE `QRTZ_BLOB_TRIGGERS` (
  `SCHED_NAME` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_NAME` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_GROUP` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `BLOB_DATA` blob,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `QRTZ_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



# Dump of table QRTZ_CALENDARS
# ------------------------------------------------------------

DROP TABLE IF EXISTS `QRTZ_CALENDARS`;

CREATE TABLE `QRTZ_CALENDARS` (
  `SCHED_NAME` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `CALENDAR_NAME` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `CALENDAR` blob NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`CALENDAR_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



# Dump of table QRTZ_CRON_TRIGGERS
# ------------------------------------------------------------

DROP TABLE IF EXISTS `QRTZ_CRON_TRIGGERS`;

CREATE TABLE `QRTZ_CRON_TRIGGERS` (
  `SCHED_NAME` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_NAME` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_GROUP` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `CRON_EXPRESSION` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `TIME_ZONE_ID` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `QRTZ_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `QRTZ_CRON_TRIGGERS` WRITE;
/*!40000 ALTER TABLE `QRTZ_CRON_TRIGGERS` DISABLE KEYS */;

INSERT INTO `QRTZ_CRON_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`, `CRON_EXPRESSION`, `TIME_ZONE_ID`)
VALUES
	('SonicQuartz','cleanFile','DEFAULT','0 0 12 15 * ?','Asia/Shanghai'),
	('SonicQuartz','cleanResult','DEFAULT','0 0 12 15 * ?','Asia/Shanghai'),
	('SonicQuartz','sendDayReport','DEFAULT','0 0 10 * * ?','Asia/Shanghai'),
	('SonicQuartz','sendWeekReport','DEFAULT','0 0 10 ? * MON','Asia/Shanghai');

/*!40000 ALTER TABLE `QRTZ_CRON_TRIGGERS` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table QRTZ_FIRED_TRIGGERS
# ------------------------------------------------------------

DROP TABLE IF EXISTS `QRTZ_FIRED_TRIGGERS`;

CREATE TABLE `QRTZ_FIRED_TRIGGERS` (
  `SCHED_NAME` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ENTRY_ID` varchar(95) COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_NAME` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_GROUP` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `INSTANCE_NAME` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `FIRED_TIME` bigint(13) NOT NULL,
  `SCHED_TIME` bigint(13) NOT NULL,
  `PRIORITY` int(11) NOT NULL,
  `STATE` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `JOB_NAME` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `JOB_GROUP` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IS_NONCONCURRENT` varchar(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `REQUESTS_RECOVERY` varchar(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`,`ENTRY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



# Dump of table QRTZ_JOB_DETAILS
# ------------------------------------------------------------

DROP TABLE IF EXISTS `QRTZ_JOB_DETAILS`;

CREATE TABLE `QRTZ_JOB_DETAILS` (
  `SCHED_NAME` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `JOB_NAME` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `JOB_GROUP` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `DESCRIPTION` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `JOB_CLASS_NAME` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `IS_DURABLE` varchar(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `IS_NONCONCURRENT` varchar(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `IS_UPDATE_DATA` varchar(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `REQUESTS_RECOVERY` varchar(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `JOB_DATA` blob,
  PRIMARY KEY (`SCHED_NAME`,`JOB_NAME`,`JOB_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `QRTZ_JOB_DETAILS` WRITE;
/*!40000 ALTER TABLE `QRTZ_JOB_DETAILS` DISABLE KEYS */;

INSERT INTO `QRTZ_JOB_DETAILS` (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`, `DESCRIPTION`, `JOB_CLASS_NAME`, `IS_DURABLE`, `IS_NONCONCURRENT`, `IS_UPDATE_DATA`, `REQUESTS_RECOVERY`, `JOB_DATA`)
VALUES
	('SonicQuartz','cleanFile','DEFAULT',NULL,'org.cloud.sonic.controller.quartz.QuartzJob','0','0','0','0',X'ACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000474797065737200116A6176612E6C616E672E496E746567657212E2A0A4F781873802000149000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B0200007870000000027800'),
	('SonicQuartz','cleanResult','DEFAULT',NULL,'org.cloud.sonic.controller.quartz.QuartzJob','0','0','0','0',X'ACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000474797065737200116A6176612E6C616E672E496E746567657212E2A0A4F781873802000149000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B0200007870000000037800'),
	('SonicQuartz','sendDayReport','DEFAULT',NULL,'org.cloud.sonic.controller.quartz.QuartzJob','0','0','0','0',X'ACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000474797065737200116A6176612E6C616E672E496E746567657212E2A0A4F781873802000149000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B0200007870000000047800'),
	('SonicQuartz','sendWeekReport','DEFAULT',NULL,'org.cloud.sonic.controller.quartz.QuartzJob','0','0','0','0',X'ACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000474797065737200116A6176612E6C616E672E496E746567657212E2A0A4F781873802000149000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B0200007870000000057800');

/*!40000 ALTER TABLE `QRTZ_JOB_DETAILS` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table QRTZ_LOCKS
# ------------------------------------------------------------

DROP TABLE IF EXISTS `QRTZ_LOCKS`;

CREATE TABLE `QRTZ_LOCKS` (
  `SCHED_NAME` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `LOCK_NAME` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`LOCK_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `QRTZ_LOCKS` WRITE;
/*!40000 ALTER TABLE `QRTZ_LOCKS` DISABLE KEYS */;

INSERT INTO `QRTZ_LOCKS` (`SCHED_NAME`, `LOCK_NAME`)
VALUES
	('SonicQuartz','STATE_ACCESS'),
	('SonicQuartz','TRIGGER_ACCESS');

/*!40000 ALTER TABLE `QRTZ_LOCKS` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table QRTZ_PAUSED_TRIGGER_GRPS
# ------------------------------------------------------------

DROP TABLE IF EXISTS `QRTZ_PAUSED_TRIGGER_GRPS`;

CREATE TABLE `QRTZ_PAUSED_TRIGGER_GRPS` (
  `SCHED_NAME` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_GROUP` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



# Dump of table QRTZ_SCHEDULER_STATE
# ------------------------------------------------------------

DROP TABLE IF EXISTS `QRTZ_SCHEDULER_STATE`;

CREATE TABLE `QRTZ_SCHEDULER_STATE` (
  `SCHED_NAME` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `INSTANCE_NAME` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `LAST_CHECKIN_TIME` bigint(13) NOT NULL,
  `CHECKIN_INTERVAL` bigint(13) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`INSTANCE_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `QRTZ_SCHEDULER_STATE` WRITE;
/*!40000 ALTER TABLE `QRTZ_SCHEDULER_STATE` DISABLE KEYS */;

INSERT INTO `QRTZ_SCHEDULER_STATE` (`SCHED_NAME`, `INSTANCE_NAME`, `LAST_CHECKIN_TIME`, `CHECKIN_INTERVAL`)
VALUES
	('SonicQuartz','791e2c40f1081698568797576',1698570003158,7500);

/*!40000 ALTER TABLE `QRTZ_SCHEDULER_STATE` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table QRTZ_SIMPLE_TRIGGERS
# ------------------------------------------------------------

DROP TABLE IF EXISTS `QRTZ_SIMPLE_TRIGGERS`;

CREATE TABLE `QRTZ_SIMPLE_TRIGGERS` (
  `SCHED_NAME` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_NAME` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_GROUP` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `REPEAT_COUNT` bigint(7) NOT NULL,
  `REPEAT_INTERVAL` bigint(12) NOT NULL,
  `TIMES_TRIGGERED` bigint(10) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `QRTZ_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



# Dump of table QRTZ_SIMPROP_TRIGGERS
# ------------------------------------------------------------

DROP TABLE IF EXISTS `QRTZ_SIMPROP_TRIGGERS`;

CREATE TABLE `QRTZ_SIMPROP_TRIGGERS` (
  `SCHED_NAME` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_NAME` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_GROUP` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `STR_PROP_1` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `STR_PROP_2` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `STR_PROP_3` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `INT_PROP_1` int(11) DEFAULT NULL,
  `INT_PROP_2` int(11) DEFAULT NULL,
  `LONG_PROP_1` bigint(20) DEFAULT NULL,
  `LONG_PROP_2` bigint(20) DEFAULT NULL,
  `DEC_PROP_1` decimal(13,4) DEFAULT NULL,
  `DEC_PROP_2` decimal(13,4) DEFAULT NULL,
  `BOOL_PROP_1` varchar(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `BOOL_PROP_2` varchar(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `QRTZ_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



# Dump of table QRTZ_TRIGGERS
# ------------------------------------------------------------

DROP TABLE IF EXISTS `QRTZ_TRIGGERS`;

CREATE TABLE `QRTZ_TRIGGERS` (
  `SCHED_NAME` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_NAME` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_GROUP` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `JOB_NAME` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `JOB_GROUP` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `DESCRIPTION` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `NEXT_FIRE_TIME` bigint(13) DEFAULT NULL,
  `PREV_FIRE_TIME` bigint(13) DEFAULT NULL,
  `PRIORITY` int(11) DEFAULT NULL,
  `TRIGGER_STATE` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `TRIGGER_TYPE` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `START_TIME` bigint(13) NOT NULL,
  `END_TIME` bigint(13) DEFAULT NULL,
  `CALENDAR_NAME` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `MISFIRE_INSTR` smallint(2) DEFAULT NULL,
  `JOB_DATA` blob,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  KEY `SCHED_NAME` (`SCHED_NAME`,`JOB_NAME`,`JOB_GROUP`),
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) REFERENCES `QRTZ_JOB_DETAILS` (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

LOCK TABLES `QRTZ_TRIGGERS` WRITE;
/*!40000 ALTER TABLE `QRTZ_TRIGGERS` DISABLE KEYS */;

INSERT INTO `QRTZ_TRIGGERS` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`, `JOB_NAME`, `JOB_GROUP`, `DESCRIPTION`, `NEXT_FIRE_TIME`, `PREV_FIRE_TIME`, `PRIORITY`, `TRIGGER_STATE`, `TRIGGER_TYPE`, `START_TIME`, `END_TIME`, `CALENDAR_NAME`, `MISFIRE_INSTR`, `JOB_DATA`)
VALUES
	('SonicQuartz','cleanFile','DEFAULT','cleanFile','DEFAULT',NULL,1700020800000,-1,5,'WAITING','CRON',1698568810000,0,NULL,2,''),
	('SonicQuartz','cleanResult','DEFAULT','cleanResult','DEFAULT',NULL,1700020800000,-1,5,'WAITING','CRON',1698568811000,0,NULL,2,''),
	('SonicQuartz','sendDayReport','DEFAULT','sendDayReport','DEFAULT',NULL,1698631200000,-1,5,'WAITING','CRON',1698568811000,0,NULL,2,''),
	('SonicQuartz','sendWeekReport','DEFAULT','sendWeekReport','DEFAULT',NULL,1698631200000,-1,5,'WAITING','CRON',1698568811000,0,NULL,2,'');

/*!40000 ALTER TABLE `QRTZ_TRIGGERS` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table resource_roles
# ------------------------------------------------------------

DROP TABLE IF EXISTS `resource_roles`;

CREATE TABLE `resource_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL COMMENT '描述',
  `res_id` int(11) NOT NULL COMMENT '描述',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色资源表表';



# Dump of table resources
# ------------------------------------------------------------

DROP TABLE IF EXISTS `resources`;

CREATE TABLE `resources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `desc` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '描述',
  `parent_id` int(11) NOT NULL DEFAULT '0' COMMENT '父级 id',
  `method` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '请求方法',
  `path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '资源路径',
  `white` int(11) NOT NULL DEFAULT '1' COMMENT '是否是白名单 url，0是 1 不是',
  `version` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'url 资源的版本，每次新增接口需要更新，当接口版本不一致时标记为white',
  `need_auth` int(11) NOT NULL DEFAULT '1' COMMENT '是否需要鉴权，0 不需要 1 需要',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `actable_idx_method` (`method`),
  KEY `actable_idx_path` (`path`),
  KEY `actable_idx_version` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='资源信息表';

LOCK TABLES `resources` WRITE;
/*!40000 ALTER TABLE `resources` DISABLE KEYS */;

INSERT INTO `resources` (`id`, `desc`, `parent_id`, `method`, `path`, `white`, `version`, `need_auth`, `create_time`, `update_time`)
VALUES
	(1,'控件元素管理相关',0,'parent','/elements',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:03'),
	(2,'更新控件元素',1,'PUT','/elements',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:01'),
	(3,'配置项相关',0,'parent','/confList',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:03'),
	(4,'获取远控超时时间',3,'GET','/confList/getRemoteTimeout',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:01'),
	(5,'定时任务相关',0,'parent','/jobs',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:03'),
	(6,'查询定时任务详细信息',5,'GET','/jobs',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:01'),
	(7,'删除控件元素',1,'DELETE','/elements',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:01'),
	(8,'告警通知机器人相关',0,'parent','/alertRobots',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:02'),
	(9,'查找项目机器人参数',8,'GET','/alertRobots/listAll',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:01'),
	(10,'调度相关',0,'parent','/exchange',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:02'),
	(11,'重启设备',10,'GET','/exchange/reboot',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:01'),
	(12,'模块管理相关',0,'parent','/modules',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:03'),
	(13,'查看模块信息',12,'GET','/modules',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:01'),
	(14,'测试用例相关',0,'parent','/testCases',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:03'),
	(15,'更新测试用例信息',14,'PUT','/testCases',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:01'),
	(16,'设置闲置超时时间',3,'GET','/confList/setIdleTimeout',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:01'),
	(17,'测试套件相关',0,'parent','/testSuites',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:03'),
	(18,'测试套件详情',17,'GET','/testSuites',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:01'),
	(19,'查询测试套件列表',17,'GET','/testSuites/listAll',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:01'),
	(20,'公共步骤相关',0,'parent','/publicSteps',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:03'),
	(21,'删除公共步骤检查',20,'GET','/publicSteps/deleteCheck',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:01'),
	(22,'安装包管理',0,'parent','/packages',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:03'),
	(23,'查找所有安装包',22,'GET','/packages/list',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:01'),
	(24,'删除测试用例',14,'DELETE','/testCases',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:01'),
	(25,'测试结果详情相关',0,'parent','/resultDetail',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:03'),
	(26,'查找测试结果详情',25,'GET','/resultDetail/list',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:01'),
	(27,'用户体系相关',0,'parent','/users',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:03'),
	(28,'修改密码',27,'PUT','/users',0,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:01'),
	(29,'查找公共步骤信息',20,'GET','/publicSteps',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:01'),
	(30,'测试结果相关',0,'parent','/results',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:03'),
	(31,'查询测试结果用例状态',30,'GET','/results/findCaseStatus',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:01'),
	(32,'操作步骤相关',0,'parent','/steps',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:03'),
	(33,'查找步骤列表',32,'GET','/steps/list',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:01'),
	(34,'请求路径资源',0,'parent','/resources',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:03'),
	(35,'查询所有资源连接',34,'GET','/resources/list',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:01'),
	(36,'下线agent',10,'GET','/exchange/stop',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:01'),
	(37,'角色相关',0,'parent','/roles',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:02'),
	(38,'查询所有角色信息',37,'GET','/roles/list',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:01'),
	(39,'脚本模板管理相关',0,'parent','/scripts',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:03'),
	(40,'查找脚本详情',39,'GET','/scripts',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:01'),
	(41,'查找控件元素列表1',1,'GET','/elements/list',1,'2.6.1',0,'2023-08-19 17:05:01','2023-08-19 17:05:01'),
	(42,'更新系统定时任务',5,'PUT','/jobs/updateSysJob',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(43,'删除测试结果',30,'DELETE','/results',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(44,'查找脚本模板列表',39,'GET','/scripts/list',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(45,'查询定时任务列表',5,'GET','/jobs/list',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(46,'复制步骤',32,'GET','/steps/copy/steps',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(47,'删除操作步骤检查',32,'GET','/steps/deleteCheck',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(48,'更新机器人参数',8,'PUT','/alertRobots',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(49,'设备管理相关',0,'parent','/devices',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:03'),
	(50,'删除设备',49,'DELETE','/devices',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(51,'版本迭代相关',0,'parent','/versions',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:03'),
	(52,'更新版本迭代',51,'PUT','/versions',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(53,'Agent端相关',0,'parent','/agents',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:03'),
	(54,'查询所有Agent端',53,'GET','/agents/list',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(55,'删除控件元素前检验',1,'GET','/elements/deleteCheck',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(56,'删除机器人参数',8,'DELETE','/alertRobots',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(57,'统计测试结果',30,'GET','/results/subResultCount',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(58,'查询Agent所有设备',49,'GET','/devices/listByAgentId',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(59,'删除版本迭代',51,'DELETE','/versions',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(60,'更改定时任务状态',5,'GET','/jobs/updateStatus',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(61,'修改设备图片',49,'PUT','/devices/updateImg',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(62,'设置远控超时时间',3,'GET','/confList/setRemoteTimeout',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(63,'删除模块',12,'DELETE','/modules',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(64,'停止测试套件运行',17,'GET','/testSuites/forceStopSuite',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(65,'未设置',53,'GET','/agents/hubControl',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(66,'复制测试用例',14,'GET','/testCases/copy',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(67,'编辑资源鉴权状态',34,'PUT','/resources/edit',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(68,'更新定时任务信息',5,'PUT','/jobs',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(69,'获取机器人对类型机器人在相应使用场景下的默认模板',8,'GET','/alertRobots/findDefaultTemplate',0,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(70,'查询步骤详情',32,'GET','/steps',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(71,'编辑或新增角色',37,'PUT','/roles/edit',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(72,'删除定时任务',5,'DELETE','/jobs',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(73,'查找项目机器人参数',8,'GET','/alertRobots/list',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(74,'更新模块信息',12,'PUT','/modules',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(75,'未设置',10,'POST','/exchange/send',0,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(76,'全局参数相关',0,'parent','/globalParams',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:03'),
	(77,'查看全局参数信息',76,'GET','/globalParams',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(78,'删除角色',37,'DELETE','/roles/delete',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(79,'更新测试套件',17,'PUT','/testSuites',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(80,'编辑角色资源鉴权状态',37,'PUT','/roles/update',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(81,'删除测试套件',17,'DELETE','/testSuites',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(82,'复制公共步骤',20,'GET','/publicSteps/copy',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(83,'更新公共步骤信息',20,'PUT','/publicSteps',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(84,'注册',27,'POST','/users/register',0,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(85,'告警通知机器人相关',0,'parent','/alertRobotsAdmin',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:03'),
	(86,'查找机器人参数',85,'GET','/alertRobotsAdmin/listAll',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(87,'刷新请求资源列表',34,'POST','/resources/refresh',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(88,'项目管理相关',0,'parent','/projects',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:03'),
	(89,'查询项目信息',88,'GET','/projects',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(90,'修改用户角色',27,'PUT','/users/changeRole',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(91,'删除公共步骤',20,'DELETE','/publicSteps',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(92,'获取电池概况',49,'GET','/devices/findTemper',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(93,'查询测试用例列表',14,'GET','/testCases/list',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(94,'运行测试套件',17,'GET','/testSuites/runSuite',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(95,'查询版本迭代列表',51,'GET','/versions/list',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(96,'查找所有项目',88,'GET','/projects/list',0,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(97,'清理测试结果',30,'GET','/results/clean',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(98,'登录',27,'POST','/users/login',0,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(99,'获取机器人对类型机器人在相应使用场景下的默认模板',85,'GET','/alertRobotsAdmin/findDefaultTemplate',0,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(100,'查询所有设备',49,'GET','/devices/listAll',1,'2.6.1',0,'2023-08-19 17:05:02','2023-08-19 17:05:02'),
	(101,'删除脚本模板',39,'DELETE','/scripts',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(102,'查找步骤列表',32,'GET','/steps/listAll',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(103,'拖拽排序步骤',32,'PUT','/steps/stepSort',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(104,'查找控件元素详情',1,'GET','/elements',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(105,'查找全局参数',76,'GET','/globalParams/list',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(106,'获取查询条件',49,'GET','/devices/getFilterOption',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(107,'更新设备Pos',49,'GET','/devices/updatePosition',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(108,'强制解除设备占用',49,'GET','/devices/stopDebug',1,'2.6.1',1,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(109,'开关步骤',32,'GET','/steps/switchStep',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(110,'移出测试用例',32,'GET','/steps/resetCaseId',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(111,'查询公共步骤列表2',20,'GET','/publicSteps/findNameByProjectId',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(112,'查找机器人参数',85,'GET','/alertRobotsAdmin/list',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(113,'批量查询设备',49,'GET','/devices/findByIdIn',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(114,'查询当前角色下资源鉴权转态',34,'GET','/resources/roleResource',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(115,'查询测试用例详情',14,'GET','/testCases',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(116,'批量查询用例',14,'GET','/testCases/findByIdIn',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(117,'更新脚本信息',39,'PUT','/scripts',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(118,'查询Agent端信息',53,'GET','/agents',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(119,'获取登录配置',27,'GET','/users/loginConfig',0,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(120,'查询公共步骤列表1',20,'GET','/publicSteps/list',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(121,'更新操作步骤',32,'PUT','/steps',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(122,'删除测试用例检查',14,'GET','/testCases/deleteCheck',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(123,'添加安装包信息',22,'PUT','/packages',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(124,'搜索查找步骤列表',32,'GET','/steps/search/list',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(125,'保存测试结果',25,'POST','/resultDetail',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(126,'查询系统定时任务详细信息',5,'GET','/jobs/findSysJobs',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(127,'查询所有用户信息',27,'GET','/users/list',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(128,'删除操作步骤',32,'DELETE','/steps',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(129,'获取用户信息',27,'GET','/users',0,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(130,'查询测试结果列表',30,'GET','/results/list',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(131,'更新全局参数',76,'PUT','/globalParams',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(132,'查询所有设备',49,'GET','/devices/list',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(133,'查询测试结果信息',30,'GET','/results',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(134,'删除全局参数',76,'DELETE','/globalParams',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(135,'删除机器人参数',85,'DELETE','/alertRobotsAdmin',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(136,'复制控件元素',1,'GET','/elements/copyEle',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(137,'设备信息',49,'GET','/devices',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(138,'获取闲置超时时间',3,'GET','/confList/getIdleTimeout',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(139,'修改设备安装密码',49,'PUT','/devices/saveDetail',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(140,'查询测试套件列表',17,'GET','/testSuites/list',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(141,'修改agent信息',53,'PUT','/agents/update',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(142,'更新项目信息',88,'PUT','/projects',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(143,'查询版本迭代信息',51,'GET','/versions',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(144,'查询测试用例列表',14,'GET','/testCases/listAll',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(145,'发送周报',30,'GET','/results/sendWeekReport',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(146,'查询报表',30,'GET','/results/chart',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(147,'查找测试结果详情2',25,'GET','/resultDetail/listAll',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(148,'通过REST API释放设备',49,'GET','/devices/release',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(149,'更新机器人参数',85,'PUT','/alertRobotsAdmin',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(150,'发送日报',30,'GET','/results/sendDayReport',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(151,'删除',88,'DELETE','/projects',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(152,'查找模块列表',12,'GET','/modules/list',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(153,'通过REST API占用设备',49,'POST','/devices/occupy',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03'),
	(154,'生成用户对外Token',27,'GET','/users/generateToken',1,'2.6.1',0,'2023-08-19 17:05:03','2023-08-19 17:05:03');

/*!40000 ALTER TABLE `resources` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table result_detail
# ------------------------------------------------------------

DROP TABLE IF EXISTS `result_detail`;

CREATE TABLE `result_detail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `case_id` int(11) NOT NULL COMMENT '测试用例id',
  `des` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '描述',
  `device_id` int(11) NOT NULL COMMENT '设备id',
  `log` longtext COLLATE utf8mb4_unicode_ci COMMENT '日志信息',
  `result_id` int(11) NOT NULL COMMENT '所属结果id',
  `status` int(11) NOT NULL COMMENT '步骤执行状态',
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '步骤执行状态',
  `type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '测试结果详情类型',
  PRIMARY KEY (`id`),
  KEY `actable_idx_IDX_RESULT_ID_CASE_ID_TYPE_DEVICE_ID` (`result_id`,`case_id`,`type`,`device_id`),
  KEY `actable_idx_IDX_TIME` (`time`),
  KEY `actable_idx_IDX_TYPE` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='任务结果详情表';

LOCK TABLES `result_detail` WRITE;
/*!40000 ALTER TABLE `result_detail` DISABLE KEYS */;

INSERT INTO `result_detail` (`id`, `case_id`, `des`, `device_id`, `log`, `result_id`, `status`, `time`, `type`)
VALUES
	(378,5,'连接 UIAutomator2 Server 成功',1,'',27,2,'2023-09-24 17:46:15','step'),
	(380,5,'',1,'设备操作系统：Android<br>操作系统版本：6.0.1<br>设备序列号：a16d6dbc<br>设备制造商：Xiaomi<br>设备型号：MI 4LTE<br>设备分辨率：1080x1920',27,1,'2023-09-24 17:46:16','step'),
	(381,5,'开始执行「if」步骤',1,'',27,2,'2023-09-24 17:46:17','step'),
	(382,5,'Script result',1,'{\"request_id\":\"\",\"code\":\"Success\",\"message\":\"Success\",\"data\":{\"id\":4,\"task_name\":\"Test-Send-Topic-001\",\"uuid\":\"b7966ff4-5b17-4ae5-ae3f-3a60c9aa6e13\",\"task_status\":\"pendding\",\"act_time_mode\":\"planned\",\"planned_start_time\":\"2023-09-18T18:20:00+08:00\",\"assigned_to\":450,\"task_reason\":\"Test\",\"max_timeout\":60,\"get_task_data_func\":\"Test\",\"create_time\":\"2023-09-17T13:28:49.733115+08:00\",\"update_time\":\"2023-09-24T14:47:18.858490+08:00\",\"template\":1,\"task_template\":{\"task_name\":\"小红书-内容发布-任务模板\",\"key\":\"red_content_publish\",\"active_status\":\"active\",\"category\":1,\"platform\":2,\"order\":1,\"parent\":null},\"extra_data\":[{\"id\":17,\"title\":\"我的标题\",\"text\":\"\",\"description\":\"这是一首简单的小情歌呀，唱给你听听啊。\",\"image_url_list\":[\"https://backend23.feiyu.ai/media/rpa_uploads/00001/6b51e8d3-ec6a-4554-ba35-3b1d35d81c53.jpeg\",\"https://backend23.feiyu.ai/media/rpa_uploads/00001/0d6d167b-a717-4ad1-aced-cdea261954e6.jpeg\"],\"video_url\":\"https://www.baidu.com/video/1.mp4\"},{\"id\":296,\"title\":\"我的标题\",\"text\":\"\",\"description\":\"这是一首简单的小曲调\",\"image_url_list\":[\"https://backend23.feiyu.ai/media/rpa_uploads/00001/0d6d167b-a717-4ad1-aced-cdea261954e6.jpeg\",\"https://backend23.feiyu.ai/media/rpa_uploads/00001/31b64f33-d06a-4666-b183-f1834ee6efb8.jpeg\"],\"video_url\":\"https://www.baidu.com/video/1.mp4\"},{\"id\":297,\"title\":\"我的标题\",\"text\":\"\",\"description\":\"这是一首简单小情歌啊，唱出我的内心所想。它表达了我对你的深情，我想让你明白我的爱意。这首歌并不复杂，但它却真挚地诉说了我的感受。希望你能够听到它的动人旋律，感受到我的爱之声。它是一种温柔的呢喃，如同春风拂面的轻抚。我用最简单的歌词，用最平凡的旋律，表达着我对你的感激和珍惜。希望这首小情歌能够成为我们之间特殊的纽带，连接着我们的心灵。让我们一起在这简单却充满真情的旋律中相守，相爱。\",\"image_url_list\":[\"https://backend23.feiyu.ai/media/rpa_uploads/00001/31b64f33-d06a-4666-b183-f1834ee6efb8.jpeg\",\"https://backend23.feiyu.ai/media/rpa_uploads/00001/31b64f33-d06a-4666-b183-f1834ee6efb8.jpeg\"],\"video_url\":\"https://www.baidu.com/video/1.mp4\"},{\"id\":298,\"title\":\"我的标题\",\"text\":\"\",\"description\":\"啊，这是一首轻松而平易近人的小曲子\",\"image_url_list\":[\"https://backend23.feiyu.ai/media/rpa_uploads/00001/6b51e8d3-ec6a-4554-ba35-3b1d35d81c53.jpeg\",\"https://backend23.feiyu.ai/media/rpa_uploads/00001/6b51e8d3-ec6a-4554-ba35-3b1d35d81c53.jpeg\"],\"video_url\":\"https://www.baidu.com/video/1.mp4\"}]}}',27,1,'2023-09-24 17:46:20','step'),
	(383,5,'Run Custom Scripts',1,'Script: <br>import org.cloud.sonic.driver.android.service.AndroidElement;\nimport org.cloud.sonic.driver.android.AndroidDriver;\nimport org.cloud.sonic.driver.android.enmus.AndroidSelector;\nimport org.cloud.sonic.driver.common.tool.SonicRespException;\nimport org.cloud.sonic.agent.bridge.android.AndroidDeviceBridgeTool;\nimport org.springframework.http.HttpEntity;\nimport org.springframework.http.HttpHeaders;\nimport org.springframework.http.MediaType;\nimport org.springframework.http.ResponseEntity;\nimport org.springframework.web.client.RestTemplate;\nimport com.alibaba.fastjson.JSON;\nimport com.alibaba.fastjson.JSONArray;\nimport com.alibaba.fastjson.JSONObject;\n\ndef GetElementTextWithXpath(String xpath) {\n  AndroidDriver androidDriver = androidStepHandler.androidDriver;\n  AndroidElement w = androidDriver.findElement(AndroidSelector.XPATH, xpath);\n  return w.getText()\n}\n\ndef GetSingleElementWithXpath(String xpath) {\n  AndroidDriver androidDriver = androidStepHandler.androidDriver;\n  AndroidElement w = androidDriver.findElement(AndroidSelector.XPATH, xpath);\n  return w\n}\n\ndef parseAccountIDFromString(String input) {\n    def pattern = /(\\d+)/\n    def matcher = (input =~ pattern)\n    \n    if (matcher.find()) {\n        return matcher[0][1]\n    } else {\n        return null\n    }\n}\n\ndef ReturnButtons = [\n  \"global_xhs_view_post_return_button\", \n  \"global_xhs_shop_goods_detail_return_button\", \n  \"global_friend_details_return_button\"\n];\n  \ndef ReturnPageWithAccountButton() {\n  for (String xpath in ReturnButtons) {\n       try {\n         String xpathAccountButton = androidStepHandler.globalParams.getString(xpath)\n         w = GetSingleElementWithXpath(xpathAccountButton)\n         w.click();\n         break;\n       } catch (SonicRespException e) {\n        continue;\n       } catch (Exception e) {\n       }\n  }\n}\n\ndef EnterAccountPage() {\n  //点击账号信息按钮\n  try {\n      String xpathAccountButton = androidStepHandler.globalParams.getString(\"global_xhs_account_button\")\n      w = GetSingleElementWithXpath(xpathAccountButton)\n      w.click();\n   } catch (SonicRespException e) {\n      //\n     ReturnPageWithAccountButton()\n   } catch (Exception e) {\n      \n   }\n}\n\nboolean downloadImage(String imageUrl) {\n   AndroidDeviceBridgeTool.pushToCamera(androidStepHandler.iDevice, imageUrl)\n}\n\n\ndef GetXHSAccountInfo() {\n  \n  EnterAccountPage()\n    \n  Thread.sleep(1000);\n  \n  String xpathAccountID = androidStepHandler.globalParams.getString(\"global_xhs_account_id\")\n  accountID = parseAccountIDFromString(GetElementTextWithXpath(xpathAccountID))\n    \n  String xpathAccountName = androidStepHandler.globalParams.getString(\"global_xhs_account_name\")\n  accountName = GetElementTextWithXpath(xpathAccountName)\n}\n\n// 获取任务内容\ndef GetTask(String apiUrl) {\n    // 创建 RestTemplate 实例\n    RestTemplate restTemplate = new RestTemplate();\n\n    // 设置请求头\n    HttpHeaders headers = new HttpHeaders();\n    headers.setContentType(MediaType.APPLICATION_JSON);\n\n    device_id = androidStepHandler.getUdId()\n\n    // 设置请求体数据\n    String requestBody = \"{\\\"SonicDeviceID\\\": \\\"\" + device_id + \"\\\"}\";\n\n    // 将请求头和请求体组合成 HttpEntity\n    HttpEntity<String> requestEntity = new HttpEntity<>(requestBody, headers);\n\n    // 发送 POST 请求\n    ResponseEntity<String> responseEntity = restTemplate.postForEntity(apiUrl, requestEntity, String.class);\n\n    // 检查响应状态码\n    if (responseEntity.getStatusCode().is2xxSuccessful()) {\n        // 获取响应数据\n        String responseBody = responseEntity.getBody();\n        JSONObject resp = JSONObject.parseObject(responseBody);\n        JSONObject data = resp.getJSONObject(\"data\");\n      \n        JSONArray extra = data.getJSONArray(\"extra_data\");\n       \n        JSONObject extraData = extra.getJSONObject(0);\n        String title = extraData.getString(\"title\");\n      \n        androidStepHandler.globalParams.put(\"xhs_post_title_temp\", title)\n        \n        String description = extraData.getString(\"description\");\n        androidStepHandler.globalParams.put(\"xhs_post_content_temp\", description)\n        \n        JSONArray images = extraData.getJSONArray(\"image_url_list\");\n        for (int i = 0; i < images.size(); i++) {\n           String imageURL = images.getString(i);\n           downloadImage(imageURL)\n        }\n      \n        return responseBody\n    } else {\n        return responseEntity.getStatusCode()\n    }\n}\n\ndef init() {\n   // 获取账户信息\n   // GetXHSAccountInfo()\n\n   // 获取任务\n   responseBody = GetTask(\"http://192.168.1.15:9123/v1/task/get\")\n\n}\n\ninit()',27,2,'2023-09-24 17:46:20','step'),
	(384,5,'「if」步骤通过，开始执行子步骤',1,'',27,2,'2023-09-24 17:46:20','step'),
	(385,5,'「if」子步骤执行完毕',1,'',27,2,'2023-09-24 17:46:20','step'),
	(386,5,'退出连接设备',1,'',27,2,'2023-09-24 17:46:21','step'),
	(387,5,'',1,'',27,1,'2023-09-24 17:46:21','status'),
	(415,6,'「if」步骤「点击xhs_post_select_images_next_button」异常',1,'点击xpath: //android.widget.TextView[@resource-id=\'com.xingin.xhs:id/a32\']',29,4,'2023-09-24 17:47:54','step'),
	(416,6,'',1,'异常信息： org.cloud.sonic.driver.common.tool.SonicRespException: An element could not be located on the page using the given search parameters',29,3,'2023-09-24 17:47:54','step'),
	(417,6,'「if」步骤执行失败，跳过',1,'',29,3,'2023-09-24 17:47:54','step'),
	(418,6,'「if」子步骤执行完毕',1,'',29,2,'2023-09-24 17:47:54','step'),
	(419,6,'退出连接设备',1,'',29,2,'2023-09-24 17:47:54','step'),
	(420,6,'',1,'',29,1,'2023-09-24 17:47:54','status'),
	(663,5,'连接 UIAutomator2 Server 成功',1,'',46,2,'2023-09-24 18:55:16','step'),
	(664,5,'',1,'设备操作系统：Android<br>操作系统版本：6.0.1<br>设备序列号：a16d6dbc<br>设备制造商：Xiaomi<br>设备型号：MI 4LTE<br>设备分辨率：1080x1920',46,1,'2023-09-24 18:55:18','step'),
	(665,5,'开始执行「if」步骤',1,'',46,2,'2023-09-24 18:55:18','step'),
	(666,5,'Script error',1,'java.util.concurrent.ExecutionException: org.codehaus.groovy.control.MultipleCompilationErrorsException: startup failed:\r\nScript1.groovy: 21: Unexpected input: \'{\\n        value = w[i].getText()\\n        if value\' @ line 21, column 12.\r\n           if value == title {\r\n              ^\r\n\r\n1 error\r\n',46,4,'2023-09-24 18:55:18','step'),
	(667,5,'「if」步骤「Run Custom Scripts」异常',1,'Script: <br>import org.cloud.sonic.driver.android.service.AndroidElement;\nimport org.cloud.sonic.driver.android.AndroidDriver;\nimport org.cloud.sonic.driver.android.enmus.AndroidSelector;\nimport org.cloud.sonic.driver.common.tool.SonicRespException;\nimport org.cloud.sonic.agent.bridge.android.AndroidDeviceBridgeTool;\n\ndef GetElementsWithXpath(String xpath) {\n  AndroidDriver androidDriver = androidStepHandler.androidDriver;\n  elements = androidDriver.findElementList(AndroidSelector.XPATH, xpath)\n  return elements\n}\n    \ndef SelectPost() {    \n  // title = androidStepHandler.globalParams.getString(\"xhs_post_title_temp\")\n  title = \"我的标题\"\n  try {\n      String postXpath = androidStepHandler.globalParams.getString(\"global_xhs_mine_posts\")\n      w = GetElementsWithXpath(postXpath);\n      for (int i = 0; i < w.size(); i++) {\n        value = w[i].getText()\n        if value == title {\n           w[i].click();\n        }\n      }\n   } catch (SonicRespException e) {\n      println(e);\n   } catch (Exception e) {\n      println(e);\n   }\n}\n\nSelectPost();',46,4,'2023-09-24 18:55:18','step'),
	(668,5,'',1,'异常信息： java.lang.RuntimeException: Run script failed',46,3,'2023-09-24 18:55:18','step'),
	(669,5,'「if」步骤执行失败，跳过',1,'',46,3,'2023-09-24 18:55:18','step'),
	(670,5,'退出连接设备',1,'',46,2,'2023-09-24 18:55:19','step'),
	(671,5,'',1,'',46,1,'2023-09-24 18:55:19','status'),
	(672,6,'连接 UIAutomator2 Server 成功',1,'',47,2,'2023-09-24 19:01:30','step'),
	(673,6,'',1,'设备操作系统：Android<br>操作系统版本：6.0.1<br>设备序列号：a16d6dbc<br>设备制造商：Xiaomi<br>设备型号：MI 4LTE<br>设备分辨率：1080x1920',47,1,'2023-09-24 19:01:31','step'),
	(674,6,'开始执行「if」步骤',1,'',47,2,'2023-09-24 19:01:31','step'),
	(675,6,'打开应用',1,'App包名： com.xingin.xhs',47,2,'2023-09-24 19:01:32','step'),
	(676,6,'「if」步骤通过，开始执行子步骤',1,'',47,2,'2023-09-24 19:01:32','step'),
	(677,6,'开始执行「if」步骤',1,'',47,2,'2023-09-24 19:01:32','step'),
	(678,6,'Script result',1,'文成思宇',47,1,'2023-09-24 19:02:02','step'),
	(679,6,'Run Custom Scripts',1,'Script: <br>import org.cloud.sonic.driver.android.service.AndroidElement;\nimport org.cloud.sonic.driver.android.AndroidDriver;\nimport org.cloud.sonic.driver.android.enmus.AndroidSelector;\nimport org.cloud.sonic.driver.common.tool.SonicRespException;\nimport org.cloud.sonic.agent.bridge.android.AndroidDeviceBridgeTool;\nimport org.springframework.http.HttpEntity;\nimport org.springframework.http.HttpHeaders;\nimport org.springframework.http.MediaType;\nimport org.springframework.http.ResponseEntity;\nimport org.springframework.web.client.RestTemplate;\nimport com.alibaba.fastjson.JSON;\nimport com.alibaba.fastjson.JSONArray;\nimport com.alibaba.fastjson.JSONObject;\n\ndef GetElementTextWithXpath(String xpath) {\n  AndroidDriver androidDriver = androidStepHandler.androidDriver;\n  AndroidElement w = androidDriver.findElement(AndroidSelector.XPATH, xpath);\n  return w.getText()\n}\n\ndef GetSingleElementWithXpath(String xpath) {\n  AndroidDriver androidDriver = androidStepHandler.androidDriver;\n  AndroidElement w = androidDriver.findElement(AndroidSelector.XPATH, xpath);\n  return w\n}\n\ndef parseAccountIDFromString(String input) {\n    def pattern = /(\\d+)/\n    def matcher = (input =~ pattern)\n    \n    if (matcher.find()) {\n        return matcher[0][1]\n    } else {\n        return null\n    }\n}\n\ndef ReturnButtons = [\n  \"global_xhs_view_post_return_button\", \n  \"global_xhs_shop_goods_detail_return_button\", \n  \"global_friend_details_return_button\"\n];\n  \ndef ReturnPageWithAccountButton() {\n  for (String xpath in ReturnButtons) {\n       try {\n         String xpathAccountButton = androidStepHandler.globalParams.getString(xpath)\n         w = GetSingleElementWithXpath(xpathAccountButton)\n         w.click();\n         break;\n       } catch (SonicRespException e) {\n        continue;\n       } catch (Exception e) {\n       }\n  }\n}\n\ndef EnterAccountPage() {\n  //点击账号信息按钮\n  try {\n      String xpathAccountButton = androidStepHandler.globalParams.getString(\"global_xhs_account_button\")\n      w = GetSingleElementWithXpath(xpathAccountButton)\n      w.click();\n   } catch (SonicRespException e) {\n      //\n     ReturnPageWithAccountButton()\n   } catch (Exception e) {\n      \n   }\n}\n\nboolean downloadImage(String imageUrl) {\n   AndroidDeviceBridgeTool.pushToCamera(androidStepHandler.iDevice, imageUrl)\n}\n\n\ndef GetXHSAccountInfo() {\n  \n  EnterAccountPage()\n    \n  Thread.sleep(1000);\n  \n  String xpathAccountID = androidStepHandler.globalParams.getString(\"global_xhs_account_id\")\n  accountID = parseAccountIDFromString(GetElementTextWithXpath(xpathAccountID))\n    \n  String xpathAccountName = androidStepHandler.globalParams.getString(\"global_xhs_account_name\")\n  accountName = GetElementTextWithXpath(xpathAccountName)\n}\n\n// 获取任务内容\ndef GetTask(String apiUrl) {\n    // 创建 RestTemplate 实例\n    RestTemplate restTemplate = new RestTemplate();\n\n    // 设置请求头\n    HttpHeaders headers = new HttpHeaders();\n    headers.setContentType(MediaType.APPLICATION_JSON);\n\n    device_id = androidStepHandler.getUdId()\n\n    // 设置请求体数据\n    String requestBody = \"{\\\"SonicDeviceID\\\": \\\"\" + device_id + \"\\\"}\";\n\n    // 将请求头和请求体组合成 HttpEntity\n    HttpEntity<String> requestEntity = new HttpEntity<>(requestBody, headers);\n\n    // 发送 POST 请求\n    ResponseEntity<String> responseEntity = restTemplate.postForEntity(apiUrl, requestEntity, String.class);\n\n    // 检查响应状态码\n    if (responseEntity.getStatusCode().is2xxSuccessful()) {\n        // 获取响应数据\n        String responseBody = responseEntity.getBody();\n        JSONObject resp = JSONObject.parseObject(responseBody);\n        JSONObject data = resp.getJSONObject(\"data\");\n      \n        JSONArray extra = data.getJSONArray(\"extra_data\");\n       \n        JSONObject extraData = extra.getJSONObject(0);\n        String title = extraData.getString(\"title\");\n      \n        androidStepHandler.globalParams.put(\"xhs_post_title_temp\", title)\n        \n        String description = extraData.getString(\"description\");\n        androidStepHandler.globalParams.put(\"xhs_post_content_temp\", description)\n        \n        JSONArray images = extraData.getJSONArray(\"image_url_list\");\n        for (int i = 0; i < images.size(); i++) {\n           String imageURL = images.getString(i);\n           downloadImage(imageURL)\n        }\n        androidStepHandler.globalParams.put(\"xhs_post_images_count_temp\", images.size())\n        \n        return responseBody\n    } else {\n        return responseEntity.getStatusCode()\n    }\n}\n\ndef init() {\n   // 获取任务\n   responseBody = GetTask(\"http://192.168.1.15:9123/v1/task/get\")\n   \n   // 获取账户信息\n   GetXHSAccountInfo()\n}\n\ninit()',47,2,'2023-09-24 19:02:02','step'),
	(680,6,'「if」步骤通过，开始执行子步骤',1,'',47,2,'2023-09-24 19:02:02','step'),
	(681,6,'「if」子步骤执行完毕',1,'',47,2,'2023-09-24 19:02:02','step'),
	(682,6,'开始执行「if」步骤',1,'',47,2,'2023-09-24 19:02:02','step'),
	(683,6,'点击xhs_post_button',1,'点击xpath: //android.widget.RelativeLayout[@resource-id=\'com.xingin.xhs:id/d79\']',47,2,'2023-09-24 19:02:03','step'),
	(684,6,'「if」步骤通过，开始执行子步骤',1,'',47,2,'2023-09-24 19:02:03','step'),
	(685,6,'开始执行「if」步骤',1,'',47,2,'2023-09-24 19:02:03','step'),
	(686,6,'Run Custom Scripts',1,'Script: <br>import org.cloud.sonic.driver.android.service.AndroidElement;\nimport org.cloud.sonic.driver.android.AndroidDriver;\nimport org.cloud.sonic.driver.android.enmus.AndroidSelector;\nimport org.cloud.sonic.driver.common.tool.SonicRespException;\nimport org.cloud.sonic.agent.bridge.android.AndroidDeviceBridgeTool;\n\ndef GetElementsWithXpath(String xpath) {\n  AndroidDriver androidDriver = androidStepHandler.androidDriver;\n  elements = androidDriver.findElementList(AndroidSelector.XPATH, xpath)\n  return elements\n}\n    \ndef SelectImages() {    \n  def imageSizeStr = androidStepHandler.globalParams.getString(\"xhs_post_images_count_temp\")\n  def imageSize = imageSizeStr.toInteger()\n  try {\n      String imageButton = androidStepHandler.globalParams.getString(\"xhs_post_select_images_button\")\n      w = GetElementsWithXpath(imageButton);\n      for (int i = 0; i < imageSize; i++) {\n        w[i].click();\n      }\n   } catch (SonicRespException e) {\n      println(e);\n   } catch (Exception e) {\n      println(e);\n   }\n}\n\nSelectImages();\n',47,2,'2023-09-24 19:02:13','step'),
	(687,6,'「if」步骤通过，开始执行子步骤',1,'',47,2,'2023-09-24 19:02:13','step'),
	(688,6,'「if」子步骤执行完毕',1,'',47,2,'2023-09-24 19:02:13','step'),
	(689,6,'「if」子步骤执行完毕',1,'',47,2,'2023-09-24 19:02:13','step'),
	(690,6,'开始执行「if」步骤',1,'',47,2,'2023-09-24 19:02:13','step'),
	(691,6,'点击xhs_post_select_images_next_button',1,'点击xpath: //android.widget.TextView[@resource-id=\'com.xingin.xhs:id/a32\']',47,2,'2023-09-24 19:02:14','step'),
	(692,6,'「if」步骤通过，开始执行子步骤',1,'',47,2,'2023-09-24 19:02:14','step'),
	(693,6,'开始执行「if」步骤',1,'',47,2,'2023-09-24 19:02:14','step'),
	(694,6,'点击xhs_post_select_images_confirm_button',1,'点击xpath: //android.widget.TextView[@resource-id=\'com.xingin.xhs:id/axd\']',47,2,'2023-09-24 19:02:19','step'),
	(695,6,'「if」步骤通过，开始执行子步骤',1,'',47,2,'2023-09-24 19:02:19','step'),
	(696,6,'开始执行「if」步骤',1,'',47,2,'2023-09-24 19:02:19','step'),
	(697,6,'对xhs_post_title_input输入内容',1,'对xpath: //android.widget.EditText[@resource-id=\'com.xingin.xhs:id/bi9\'] 输入: 我的标题',47,2,'2023-09-24 19:02:23','step'),
	(698,6,'「if」步骤通过，开始执行子步骤',1,'',47,2,'2023-09-24 19:02:23','step'),
	(699,6,'开始执行「if」步骤',1,'',47,2,'2023-09-24 19:02:23','step'),
	(700,6,'对xhs_post_content_input输入内容',1,'对xpath: //android.widget.EditText[@resource-id=\'com.xingin.xhs:id/bgt\'] 输入: 这是一首简单的小情歌呀，唱给你听听啊。',47,2,'2023-09-24 19:02:25','step'),
	(701,6,'「if」步骤通过，开始执行子步骤',1,'',47,2,'2023-09-24 19:02:25','step'),
	(702,6,'「if」子步骤执行完毕',1,'',47,2,'2023-09-24 19:02:25','step'),
	(703,6,'「if」子步骤执行完毕',1,'',47,2,'2023-09-24 19:02:25','step'),
	(704,6,'「if」子步骤执行完毕',1,'',47,2,'2023-09-24 19:02:25','step'),
	(705,6,'「if」子步骤执行完毕',1,'',47,2,'2023-09-24 19:02:25','step'),
	(706,6,'开始执行「if」步骤',1,'',47,2,'2023-09-24 19:02:25','step'),
	(707,6,'点击xhs_post_publish_button',1,'点击xpath: //android.widget.Button[@resource-id=\'com.xingin.xhs:id/abj\']',47,2,'2023-09-24 19:02:25','step'),
	(708,6,'「if」步骤通过，开始执行子步骤',1,'',47,2,'2023-09-24 19:02:25','step'),
	(709,6,'开始执行「if」步骤',1,'',47,2,'2023-09-24 19:02:25','step'),
	(710,6,'点击xhs_post_mine',1,'点击xpath: //android.widget.TextView[@resource-id=\'com.xingin.xhs:id/har\']',47,2,'2023-09-24 19:02:30','step'),
	(711,6,'「if」步骤通过，开始执行子步骤',1,'',47,2,'2023-09-24 19:02:30','step'),
	(712,6,'开始执行「if」步骤',1,'',47,2,'2023-09-24 19:02:30','step'),
	(713,6,'设置全局步骤间隔',1,'间隔1000 ms',47,2,'2023-09-24 19:02:30','step'),
	(714,6,'「if」步骤通过，开始执行子步骤',1,'',47,2,'2023-09-24 19:02:30','step'),
	(715,6,'开始执行「if」步骤',1,'',47,2,'2023-09-24 19:02:30','step'),
	(716,6,'点击xhs_home_button',1,'点击xpath: //android.widget.TextView[@resource-id=\'com.xingin.xhs:id/har\']',47,2,'2023-09-24 19:02:31','step'),
	(717,6,'「if」步骤通过，开始执行子步骤',1,'',47,2,'2023-09-24 19:02:31','step'),
	(718,6,'「if」子步骤执行完毕',1,'',47,2,'2023-09-24 19:02:31','step'),
	(719,6,'「if」子步骤执行完毕',1,'',47,2,'2023-09-24 19:02:31','step'),
	(720,6,'「if」子步骤执行完毕',1,'',47,2,'2023-09-24 19:02:31','step'),
	(721,6,'「if」子步骤执行完毕',1,'',47,2,'2023-09-24 19:02:31','step'),
	(722,6,'「if」子步骤执行完毕',1,'',47,2,'2023-09-24 19:02:31','step'),
	(723,6,'退出连接设备',1,'',47,2,'2023-09-24 19:02:31','step'),
	(724,6,'',1,'',47,1,'2023-09-24 19:02:31','status'),
	(725,6,'连接 UIAutomator2 Server 成功',1,'',48,2,'2023-09-24 19:05:06','step'),
	(726,6,'',1,'设备操作系统：Android<br>操作系统版本：6.0.1<br>设备序列号：a16d6dbc<br>设备制造商：Xiaomi<br>设备型号：MI 4LTE<br>设备分辨率：1080x1920',48,1,'2023-09-24 19:05:07','step'),
	(727,6,'开始执行「if」步骤',1,'',48,2,'2023-09-24 19:05:07','step'),
	(728,6,'打开应用',1,'App包名： com.xingin.xhs',48,2,'2023-09-24 19:05:08','step'),
	(729,6,'「if」步骤通过，开始执行子步骤',1,'',48,2,'2023-09-24 19:05:08','step'),
	(730,6,'开始执行「if」步骤',1,'',48,2,'2023-09-24 19:05:08','step'),
	(731,6,'Script result',1,'文成思宇',48,1,'2023-09-24 19:05:16','step'),
	(732,6,'Run Custom Scripts',1,'Script: <br>import org.cloud.sonic.driver.android.service.AndroidElement;\nimport org.cloud.sonic.driver.android.AndroidDriver;\nimport org.cloud.sonic.driver.android.enmus.AndroidSelector;\nimport org.cloud.sonic.driver.common.tool.SonicRespException;\nimport org.cloud.sonic.agent.bridge.android.AndroidDeviceBridgeTool;\nimport org.springframework.http.HttpEntity;\nimport org.springframework.http.HttpHeaders;\nimport org.springframework.http.MediaType;\nimport org.springframework.http.ResponseEntity;\nimport org.springframework.web.client.RestTemplate;\nimport com.alibaba.fastjson.JSON;\nimport com.alibaba.fastjson.JSONArray;\nimport com.alibaba.fastjson.JSONObject;\n\ndef GetElementTextWithXpath(String xpath) {\n  AndroidDriver androidDriver = androidStepHandler.androidDriver;\n  AndroidElement w = androidDriver.findElement(AndroidSelector.XPATH, xpath);\n  return w.getText()\n}\n\ndef GetSingleElementWithXpath(String xpath) {\n  AndroidDriver androidDriver = androidStepHandler.androidDriver;\n  AndroidElement w = androidDriver.findElement(AndroidSelector.XPATH, xpath);\n  return w\n}\n\ndef parseAccountIDFromString(String input) {\n    def pattern = /(\\d+)/\n    def matcher = (input =~ pattern)\n    \n    if (matcher.find()) {\n        return matcher[0][1]\n    } else {\n        return null\n    }\n}\n\ndef ReturnButtons = [\n  \"global_xhs_view_post_return_button\", \n  \"global_xhs_shop_goods_detail_return_button\", \n  \"global_friend_details_return_button\"\n];\n  \ndef ReturnPageWithAccountButton() {\n  for (String xpath in ReturnButtons) {\n       try {\n         String xpathAccountButton = androidStepHandler.globalParams.getString(xpath)\n         w = GetSingleElementWithXpath(xpathAccountButton)\n         w.click();\n         break;\n       } catch (SonicRespException e) {\n        continue;\n       } catch (Exception e) {\n       }\n  }\n}\n\ndef EnterAccountPage() {\n  //点击账号信息按钮\n  try {\n      String xpathAccountButton = androidStepHandler.globalParams.getString(\"global_xhs_account_button\")\n      w = GetSingleElementWithXpath(xpathAccountButton)\n      w.click();\n   } catch (SonicRespException e) {\n      //\n     ReturnPageWithAccountButton()\n   } catch (Exception e) {\n      \n   }\n}\n\nboolean downloadImage(String imageUrl) {\n   AndroidDeviceBridgeTool.pushToCamera(androidStepHandler.iDevice, imageUrl)\n}\n\n\ndef GetXHSAccountInfo() {\n  \n  EnterAccountPage()\n    \n  Thread.sleep(1000);\n  \n  String xpathAccountID = androidStepHandler.globalParams.getString(\"global_xhs_account_id\")\n  accountID = parseAccountIDFromString(GetElementTextWithXpath(xpathAccountID))\n    \n  String xpathAccountName = androidStepHandler.globalParams.getString(\"global_xhs_account_name\")\n  accountName = GetElementTextWithXpath(xpathAccountName)\n}\n\n// 获取任务内容\ndef GetTask(String apiUrl) {\n    // 创建 RestTemplate 实例\n    RestTemplate restTemplate = new RestTemplate();\n\n    // 设置请求头\n    HttpHeaders headers = new HttpHeaders();\n    headers.setContentType(MediaType.APPLICATION_JSON);\n\n    device_id = androidStepHandler.getUdId()\n\n    // 设置请求体数据\n    String requestBody = \"{\\\"SonicDeviceID\\\": \\\"\" + device_id + \"\\\"}\";\n\n    // 将请求头和请求体组合成 HttpEntity\n    HttpEntity<String> requestEntity = new HttpEntity<>(requestBody, headers);\n\n    // 发送 POST 请求\n    ResponseEntity<String> responseEntity = restTemplate.postForEntity(apiUrl, requestEntity, String.class);\n\n    // 检查响应状态码\n    if (responseEntity.getStatusCode().is2xxSuccessful()) {\n        // 获取响应数据\n        String responseBody = responseEntity.getBody();\n        JSONObject resp = JSONObject.parseObject(responseBody);\n        JSONObject data = resp.getJSONObject(\"data\");\n      \n        JSONArray extra = data.getJSONArray(\"extra_data\");\n       \n        JSONObject extraData = extra.getJSONObject(0);\n        String title = extraData.getString(\"title\");\n      \n        androidStepHandler.globalParams.put(\"xhs_post_title_temp\", title)\n        \n        String description = extraData.getString(\"description\");\n        androidStepHandler.globalParams.put(\"xhs_post_content_temp\", description)\n        \n        JSONArray images = extraData.getJSONArray(\"image_url_list\");\n        for (int i = 0; i < images.size(); i++) {\n           String imageURL = images.getString(i);\n           downloadImage(imageURL)\n        }\n        androidStepHandler.globalParams.put(\"xhs_post_images_count_temp\", images.size())\n        \n        return responseBody\n    } else {\n        return responseEntity.getStatusCode()\n    }\n}\n\ndef init() {\n   // 获取任务\n   responseBody = GetTask(\"http://192.168.1.15:9123/v1/task/get\")\n   \n   // 获取账户信息\n   GetXHSAccountInfo()\n}\n\ninit()',48,2,'2023-09-24 19:05:16','step'),
	(733,6,'「if」步骤通过，开始执行子步骤',1,'',48,2,'2023-09-24 19:05:16','step'),
	(734,6,'「if」子步骤执行完毕',1,'',48,2,'2023-09-24 19:05:16','step'),
	(735,6,'开始执行「if」步骤',1,'',48,2,'2023-09-24 19:05:16','step'),
	(736,6,'点击xhs_post_button',1,'点击xpath: //android.widget.RelativeLayout[@resource-id=\'com.xingin.xhs:id/d79\']',48,2,'2023-09-24 19:05:17','step'),
	(737,6,'「if」步骤通过，开始执行子步骤',1,'',48,2,'2023-09-24 19:05:17','step'),
	(738,6,'开始执行「if」步骤',1,'',48,2,'2023-09-24 19:05:17','step'),
	(739,6,'Run Custom Scripts',1,'Script: <br>import org.cloud.sonic.driver.android.service.AndroidElement;\nimport org.cloud.sonic.driver.android.AndroidDriver;\nimport org.cloud.sonic.driver.android.enmus.AndroidSelector;\nimport org.cloud.sonic.driver.common.tool.SonicRespException;\nimport org.cloud.sonic.agent.bridge.android.AndroidDeviceBridgeTool;\n\ndef GetElementsWithXpath(String xpath) {\n  AndroidDriver androidDriver = androidStepHandler.androidDriver;\n  elements = androidDriver.findElementList(AndroidSelector.XPATH, xpath)\n  return elements\n}\n    \ndef SelectImages() {    \n  def imageSizeStr = androidStepHandler.globalParams.getString(\"xhs_post_images_count_temp\")\n  def imageSize = imageSizeStr.toInteger()\n  try {\n      String imageButton = androidStepHandler.globalParams.getString(\"xhs_post_select_images_button\")\n      w = GetElementsWithXpath(imageButton);\n      for (int i = 0; i < imageSize; i++) {\n        w[i].click();\n      }\n   } catch (SonicRespException e) {\n      println(e);\n   } catch (Exception e) {\n      println(e);\n   }\n}\n\nSelectImages();\n',48,2,'2023-09-24 19:05:22','step'),
	(740,6,'「if」步骤通过，开始执行子步骤',1,'',48,2,'2023-09-24 19:05:22','step'),
	(741,6,'「if」子步骤执行完毕',1,'',48,2,'2023-09-24 19:05:22','step'),
	(742,6,'「if」子步骤执行完毕',1,'',48,2,'2023-09-24 19:05:22','step'),
	(743,6,'开始执行「if」步骤',1,'',48,2,'2023-09-24 19:05:22','step'),
	(744,6,'点击xhs_post_select_images_next_button',1,'点击xpath: //android.widget.TextView[@resource-id=\'com.xingin.xhs:id/a32\']',48,2,'2023-09-24 19:05:23','step'),
	(745,6,'「if」步骤通过，开始执行子步骤',1,'',48,2,'2023-09-24 19:05:23','step'),
	(746,6,'开始执行「if」步骤',1,'',48,2,'2023-09-24 19:05:23','step'),
	(747,6,'点击xhs_post_select_images_confirm_button',1,'点击xpath: //android.widget.TextView[@resource-id=\'com.xingin.xhs:id/axd\']',48,2,'2023-09-24 19:05:27','step'),
	(748,6,'「if」步骤通过，开始执行子步骤',1,'',48,2,'2023-09-24 19:05:27','step'),
	(749,6,'开始执行「if」步骤',1,'',48,2,'2023-09-24 19:05:27','step'),
	(750,6,'对xhs_post_title_input输入内容',1,'对xpath: //android.widget.EditText[@resource-id=\'com.xingin.xhs:id/bi9\'] 输入: 我的标题',48,2,'2023-09-24 19:05:35','step'),
	(751,6,'「if」步骤通过，开始执行子步骤',1,'',48,2,'2023-09-24 19:05:35','step'),
	(752,6,'开始执行「if」步骤',1,'',48,2,'2023-09-24 19:05:35','step'),
	(753,6,'对xhs_post_content_input输入内容',1,'对xpath: //android.widget.EditText[@resource-id=\'com.xingin.xhs:id/bgt\'] 输入: 这是一首简单的小情歌呀，唱给你听听啊。',48,2,'2023-09-24 19:05:37','step'),
	(754,6,'「if」步骤通过，开始执行子步骤',1,'',48,2,'2023-09-24 19:05:37','step'),
	(755,6,'「if」子步骤执行完毕',1,'',48,2,'2023-09-24 19:05:37','step'),
	(756,6,'「if」子步骤执行完毕',1,'',48,2,'2023-09-24 19:05:37','step'),
	(757,6,'「if」子步骤执行完毕',1,'',48,2,'2023-09-24 19:05:37','step'),
	(758,6,'「if」子步骤执行完毕',1,'',48,2,'2023-09-24 19:05:37','step'),
	(759,6,'开始执行「if」步骤',1,'',48,2,'2023-09-24 19:05:37','step'),
	(760,6,'点击xhs_post_publish_button',1,'点击xpath: //android.widget.Button[@resource-id=\'com.xingin.xhs:id/abj\']',48,2,'2023-09-24 19:05:37','step'),
	(761,6,'「if」步骤通过，开始执行子步骤',1,'',48,2,'2023-09-24 19:05:37','step'),
	(762,6,'开始执行「if」步骤',1,'',48,2,'2023-09-24 19:05:37','step'),
	(763,6,'点击xhs_post_mine',1,'点击xpath: //android.widget.TextView[@resource-id=\'com.xingin.xhs:id/har\']',48,2,'2023-09-24 19:05:41','step'),
	(764,6,'「if」步骤通过，开始执行子步骤',1,'',48,2,'2023-09-24 19:05:41','step'),
	(765,6,'开始执行「if」步骤',1,'',48,2,'2023-09-24 19:05:41','step'),
	(766,6,'设置全局步骤间隔',1,'间隔1000 ms',48,2,'2023-09-24 19:05:41','step'),
	(767,6,'「if」步骤通过，开始执行子步骤',1,'',48,2,'2023-09-24 19:05:41','step'),
	(768,6,'开始执行「if」步骤',1,'',48,2,'2023-09-24 19:05:41','step'),
	(769,6,'点击xhs_home_button',1,'点击xpath: //android.widget.TextView[@resource-id=\'com.xingin.xhs:id/har\']',48,2,'2023-09-24 19:05:43','step'),
	(770,6,'「if」步骤通过，开始执行子步骤',1,'',48,2,'2023-09-24 19:05:43','step'),
	(771,6,'「if」子步骤执行完毕',1,'',48,2,'2023-09-24 19:05:43','step'),
	(772,6,'「if」子步骤执行完毕',1,'',48,2,'2023-09-24 19:05:43','step'),
	(773,6,'「if」子步骤执行完毕',1,'',48,2,'2023-09-24 19:05:43','step'),
	(774,6,'「if」子步骤执行完毕',1,'',48,2,'2023-09-24 19:05:43','step'),
	(775,6,'「if」子步骤执行完毕',1,'',48,2,'2023-09-24 19:05:43','step'),
	(776,6,'退出连接设备',1,'',48,2,'2023-09-24 19:05:43','step'),
	(777,6,'',1,'',48,1,'2023-09-24 19:05:43','status'),
	(803,6,'连接 UIAutomator2 Server 成功',1,'',50,2,'2023-09-24 19:08:36','step'),
	(804,6,'',1,'设备操作系统：Android<br>操作系统版本：6.0.1<br>设备序列号：a16d6dbc<br>设备制造商：Xiaomi<br>设备型号：MI 4LTE<br>设备分辨率：1080x1920',50,1,'2023-09-24 19:08:38','step'),
	(805,6,'开始执行「if」步骤',1,'',50,2,'2023-09-24 19:08:38','step'),
	(806,6,'打开应用',1,'App包名： com.xingin.xhs',50,2,'2023-09-24 19:08:39','step'),
	(807,6,'「if」步骤通过，开始执行子步骤',1,'',50,2,'2023-09-24 19:08:39','step'),
	(808,6,'开始执行「if」步骤',1,'',50,2,'2023-09-24 19:08:39','step'),
	(809,6,'Script result',1,'文成思宇',50,1,'2023-09-24 19:08:49','step'),
	(810,6,'Run Custom Scripts',1,'Script: <br>import org.cloud.sonic.driver.android.service.AndroidElement;\nimport org.cloud.sonic.driver.android.AndroidDriver;\nimport org.cloud.sonic.driver.android.enmus.AndroidSelector;\nimport org.cloud.sonic.driver.common.tool.SonicRespException;\nimport org.cloud.sonic.agent.bridge.android.AndroidDeviceBridgeTool;\nimport org.springframework.http.HttpEntity;\nimport org.springframework.http.HttpHeaders;\nimport org.springframework.http.MediaType;\nimport org.springframework.http.ResponseEntity;\nimport org.springframework.web.client.RestTemplate;\nimport com.alibaba.fastjson.JSON;\nimport com.alibaba.fastjson.JSONArray;\nimport com.alibaba.fastjson.JSONObject;\n\ndef GetElementTextWithXpath(String xpath) {\n  AndroidDriver androidDriver = androidStepHandler.androidDriver;\n  AndroidElement w = androidDriver.findElement(AndroidSelector.XPATH, xpath);\n  return w.getText()\n}\n\ndef GetSingleElementWithXpath(String xpath) {\n  AndroidDriver androidDriver = androidStepHandler.androidDriver;\n  AndroidElement w = androidDriver.findElement(AndroidSelector.XPATH, xpath);\n  return w\n}\n\ndef parseAccountIDFromString(String input) {\n    def pattern = /(\\d+)/\n    def matcher = (input =~ pattern)\n    \n    if (matcher.find()) {\n        return matcher[0][1]\n    } else {\n        return null\n    }\n}\n\ndef ReturnButtons = [\n  \"global_xhs_view_post_return_button\", \n  \"global_xhs_shop_goods_detail_return_button\", \n  \"global_friend_details_return_button\"\n];\n  \ndef ReturnPageWithAccountButton() {\n  for (String xpath in ReturnButtons) {\n       try {\n         String xpathAccountButton = androidStepHandler.globalParams.getString(xpath)\n         w = GetSingleElementWithXpath(xpathAccountButton)\n         w.click();\n         break;\n       } catch (SonicRespException e) {\n        continue;\n       } catch (Exception e) {\n       }\n  }\n}\n\ndef EnterAccountPage() {\n  //点击账号信息按钮\n  try {\n      String xpathAccountButton = androidStepHandler.globalParams.getString(\"global_xhs_account_button\")\n      w = GetSingleElementWithXpath(xpathAccountButton)\n      w.click();\n   } catch (SonicRespException e) {\n      //\n     ReturnPageWithAccountButton()\n   } catch (Exception e) {\n      \n   }\n}\n\nboolean downloadImage(String imageUrl) {\n   AndroidDeviceBridgeTool.pushToCamera(androidStepHandler.iDevice, imageUrl)\n}\n\n\ndef GetXHSAccountInfo() {\n  \n  EnterAccountPage()\n    \n  Thread.sleep(1000);\n  \n  String xpathAccountID = androidStepHandler.globalParams.getString(\"global_xhs_account_id\")\n  accountID = parseAccountIDFromString(GetElementTextWithXpath(xpathAccountID))\n    \n  String xpathAccountName = androidStepHandler.globalParams.getString(\"global_xhs_account_name\")\n  accountName = GetElementTextWithXpath(xpathAccountName)\n}\n\n// 获取任务内容\ndef GetTask(String apiUrl) {\n    // 创建 RestTemplate 实例\n    RestTemplate restTemplate = new RestTemplate();\n\n    // 设置请求头\n    HttpHeaders headers = new HttpHeaders();\n    headers.setContentType(MediaType.APPLICATION_JSON);\n\n    device_id = androidStepHandler.getUdId()\n\n    // 设置请求体数据\n    String requestBody = \"{\\\"SonicDeviceID\\\": \\\"\" + device_id + \"\\\"}\";\n\n    // 将请求头和请求体组合成 HttpEntity\n    HttpEntity<String> requestEntity = new HttpEntity<>(requestBody, headers);\n\n    // 发送 POST 请求\n    ResponseEntity<String> responseEntity = restTemplate.postForEntity(apiUrl, requestEntity, String.class);\n\n    // 检查响应状态码\n    if (responseEntity.getStatusCode().is2xxSuccessful()) {\n        // 获取响应数据\n        String responseBody = responseEntity.getBody();\n        JSONObject resp = JSONObject.parseObject(responseBody);\n        JSONObject data = resp.getJSONObject(\"data\");\n      \n        JSONArray extra = data.getJSONArray(\"extra_data\");\n       \n        JSONObject extraData = extra.getJSONObject(0);\n        String title = extraData.getString(\"title\");\n      \n        androidStepHandler.globalParams.put(\"xhs_post_title_temp\", title)\n        \n        String description = extraData.getString(\"description\");\n        androidStepHandler.globalParams.put(\"xhs_post_content_temp\", description)\n        \n        JSONArray images = extraData.getJSONArray(\"image_url_list\");\n        for (int i = 0; i < images.size(); i++) {\n           String imageURL = images.getString(i);\n           downloadImage(imageURL)\n        }\n        androidStepHandler.globalParams.put(\"xhs_post_images_count_temp\", images.size())\n        \n        return responseBody\n    } else {\n        return responseEntity.getStatusCode()\n    }\n}\n\ndef init() {\n   // 获取任务\n   responseBody = GetTask(\"http://192.168.1.15:9123/v1/task/get\")\n   \n   // 获取账户信息\n   GetXHSAccountInfo()\n}\n\ninit()',50,2,'2023-09-24 19:08:49','step'),
	(811,6,'「if」步骤通过，开始执行子步骤',1,'',50,2,'2023-09-24 19:08:49','step'),
	(812,6,'「if」子步骤执行完毕',1,'',50,2,'2023-09-24 19:08:49','step'),
	(813,6,'开始执行「if」步骤',1,'',50,2,'2023-09-24 19:08:49','step'),
	(814,6,'点击xhs_post_button',1,'点击xpath: //android.widget.RelativeLayout[@resource-id=\'com.xingin.xhs:id/d79\']',50,2,'2023-09-24 19:08:50','step'),
	(815,6,'「if」步骤通过，开始执行子步骤',1,'',50,2,'2023-09-24 19:08:50','step'),
	(816,6,'开始执行「if」步骤',1,'',50,2,'2023-09-24 19:08:50','step'),
	(817,6,'Run Custom Scripts',1,'Script: <br>import org.cloud.sonic.driver.android.service.AndroidElement;\nimport org.cloud.sonic.driver.android.AndroidDriver;\nimport org.cloud.sonic.driver.android.enmus.AndroidSelector;\nimport org.cloud.sonic.driver.common.tool.SonicRespException;\nimport org.cloud.sonic.agent.bridge.android.AndroidDeviceBridgeTool;\n\ndef GetElementsWithXpath(String xpath) {\n  AndroidDriver androidDriver = androidStepHandler.androidDriver;\n  elements = androidDriver.findElementList(AndroidSelector.XPATH, xpath)\n  return elements\n}\n    \ndef SelectImages() {    \n  def imageSizeStr = androidStepHandler.globalParams.getString(\"xhs_post_images_count_temp\")\n  def imageSize = imageSizeStr.toInteger()\n  try {\n      String imageButton = androidStepHandler.globalParams.getString(\"xhs_post_select_images_button\")\n      w = GetElementsWithXpath(imageButton);\n      for (int i = 0; i < imageSize; i++) {\n        w[i].click();\n      }\n   } catch (SonicRespException e) {\n      println(e);\n   } catch (Exception e) {\n      println(e);\n   }\n}\n\nSelectImages();\n',50,2,'2023-09-24 19:08:55','step'),
	(818,6,'「if」步骤通过，开始执行子步骤',1,'',50,2,'2023-09-24 19:08:55','step'),
	(819,6,'「if」子步骤执行完毕',1,'',50,2,'2023-09-24 19:08:55','step'),
	(820,6,'「if」子步骤执行完毕',1,'',50,2,'2023-09-24 19:08:55','step'),
	(821,6,'开始执行「if」步骤',1,'',50,2,'2023-09-24 19:08:55','step'),
	(822,6,'点击xhs_post_select_images_next_button',1,'点击xpath: //android.widget.TextView[@resource-id=\'com.xingin.xhs:id/a32\']',50,2,'2023-09-24 19:08:56','step'),
	(823,6,'「if」步骤通过，开始执行子步骤',1,'',50,2,'2023-09-24 19:08:56','step'),
	(824,6,'开始执行「if」步骤',1,'',50,2,'2023-09-24 19:08:56','step'),
	(825,6,'点击xhs_post_select_images_confirm_button',1,'点击xpath: //android.widget.TextView[@resource-id=\'com.xingin.xhs:id/axd\']',50,2,'2023-09-24 19:09:00','step'),
	(826,6,'「if」步骤通过，开始执行子步骤',1,'',50,2,'2023-09-24 19:09:00','step'),
	(827,6,'开始执行「if」步骤',1,'',50,2,'2023-09-24 19:09:00','step'),
	(828,6,'对xhs_post_title_input输入内容',1,'对xpath: //android.widget.EditText[@resource-id=\'com.xingin.xhs:id/bi9\'] 输入: 我的标题',50,2,'2023-09-24 19:09:05','step'),
	(829,6,'「if」步骤通过，开始执行子步骤',1,'',50,2,'2023-09-24 19:09:05','step'),
	(830,6,'开始执行「if」步骤',1,'',50,2,'2023-09-24 19:09:05','step'),
	(831,6,'对xhs_post_content_input输入内容',1,'对xpath: //android.widget.EditText[@resource-id=\'com.xingin.xhs:id/bgt\'] 输入: 这是一首简单的小情歌呀，唱给你听听啊。',50,2,'2023-09-24 19:09:06','step'),
	(832,6,'「if」步骤通过，开始执行子步骤',1,'',50,2,'2023-09-24 19:09:06','step'),
	(833,6,'「if」子步骤执行完毕',1,'',50,2,'2023-09-24 19:09:06','step'),
	(834,6,'「if」子步骤执行完毕',1,'',50,2,'2023-09-24 19:09:06','step'),
	(835,6,'「if」子步骤执行完毕',1,'',50,2,'2023-09-24 19:09:06','step'),
	(836,6,'「if」子步骤执行完毕',1,'',50,2,'2023-09-24 19:09:06','step'),
	(837,6,'开始执行「if」步骤',1,'',50,2,'2023-09-24 19:09:06','step'),
	(838,6,'点击xhs_post_publish_button',1,'点击xpath: //android.widget.Button[@resource-id=\'com.xingin.xhs:id/abj\']',50,2,'2023-09-24 19:09:06','step'),
	(839,6,'「if」步骤通过，开始执行子步骤',1,'',50,2,'2023-09-24 19:09:06','step'),
	(840,6,'开始执行「if」步骤',1,'',50,2,'2023-09-24 19:09:06','step'),
	(841,6,'点击xhs_post_mine',1,'点击xpath: //android.widget.TextView[@resource-id=\'com.xingin.xhs:id/har\']',50,2,'2023-09-24 19:09:10','step'),
	(842,6,'「if」步骤通过，开始执行子步骤',1,'',50,2,'2023-09-24 19:09:10','step'),
	(843,6,'开始执行「if」步骤',1,'',50,2,'2023-09-24 19:09:10','step'),
	(844,6,'设置全局步骤间隔',1,'间隔1000 ms',50,2,'2023-09-24 19:09:10','step'),
	(845,6,'「if」步骤通过，开始执行子步骤',1,'',50,2,'2023-09-24 19:09:10','step'),
	(846,6,'开始执行「if」步骤',1,'',50,2,'2023-09-24 19:09:10','step'),
	(847,6,'点击xhs_home_button',1,'点击xpath: //android.widget.TextView[@resource-id=\'com.xingin.xhs:id/har\']',50,2,'2023-09-24 19:09:17','step'),
	(848,6,'「if」步骤通过，开始执行子步骤',1,'',50,2,'2023-09-24 19:09:17','step'),
	(849,6,'「if」子步骤执行完毕',1,'',50,2,'2023-09-24 19:09:17','step'),
	(850,6,'「if」子步骤执行完毕',1,'',50,2,'2023-09-24 19:09:17','step'),
	(851,6,'「if」子步骤执行完毕',1,'',50,2,'2023-09-24 19:09:17','step'),
	(852,6,'「if」子步骤执行完毕',1,'',50,2,'2023-09-24 19:09:17','step'),
	(853,6,'「if」子步骤执行完毕',1,'',50,2,'2023-09-24 19:09:17','step'),
	(854,6,'退出连接设备',1,'',50,2,'2023-09-24 19:09:18','step'),
	(855,6,'',1,'',50,1,'2023-09-24 19:09:18','status');

/*!40000 ALTER TABLE `result_detail` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table results
# ------------------------------------------------------------

DROP TABLE IF EXISTS `results`;

CREATE TABLE `results` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL COMMENT '任务创建时间',
  `end_time` datetime DEFAULT NULL COMMENT '任务结束时间',
  `project_id` int(11) NOT NULL COMMENT '所属项目id',
  `receive_msg_count` int(11) NOT NULL COMMENT '接受消息数量',
  `send_msg_count` int(11) NOT NULL COMMENT '发送消息数量',
  `status` int(11) NOT NULL COMMENT '结果状态',
  `strike` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '触发者',
  `suite_id` int(11) NOT NULL COMMENT '测试套件id',
  `suite_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '测试套件名字',
  PRIMARY KEY (`id`),
  KEY `actable_idx_IDX_PROJECT_ID` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='测试结果表';

LOCK TABLES `results` WRITE;
/*!40000 ALTER TABLE `results` DISABLE KEYS */;

INSERT INTO `results` (`id`, `create_time`, `end_time`, `project_id`, `receive_msg_count`, `send_msg_count`, `status`, `strike`, `suite_id`, `suite_name`)
VALUES
	(46,'2023-09-24 18:55:04','2023-09-24 18:55:19',1,1,1,1,'admin',4,'测试001'),
	(47,'2023-09-24 19:01:18','2023-09-24 19:02:31',1,1,1,1,'admin',3,'red_content_publish'),
	(48,'2023-09-24 19:04:54','2023-09-24 19:05:44',1,1,1,1,'admin',3,'red_content_publish'),
	(50,'2023-09-24 19:08:24','2023-09-24 19:09:19',1,1,1,1,'admin',3,'red_content_publish');

/*!40000 ALTER TABLE `results` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table roles
# ------------------------------------------------------------

DROP TABLE IF EXISTS `roles`;

CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '描述',
  `comment` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '描述',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色表 AUTO_INCREMENT=100';



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


# Dump of table test_suites_devices
# ------------------------------------------------------------

DROP TABLE IF EXISTS `test_suites_devices`;

CREATE TABLE `test_suites_devices` (
  `test_suites_id` int(11) NOT NULL COMMENT '测试套件id',
  `devices_id` int(11) NOT NULL COMMENT '设备id',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序用',
  KEY `actable_idx_idx_test_suites_id_devices_id` (`test_suites_id`,`devices_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='测试套件 - 设备 关系映射表';

LOCK TABLES `test_suites_devices` WRITE;
/*!40000 ALTER TABLE `test_suites_devices` DISABLE KEYS */;

INSERT INTO `test_suites_devices` (`test_suites_id`, `devices_id`, `sort`)
VALUES
	(1,1,1),
	(2,1,1),
	(3,1,1),
	(4,1,1);

/*!40000 ALTER TABLE `test_suites_devices` ENABLE KEYS */;
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


# Dump of table users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码',
  `user_role` int(11) DEFAULT NULL COMMENT '角色',
  `user_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `source` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'local' COMMENT '用户来源',
  PRIMARY KEY (`id`),
  UNIQUE KEY `actable_uni_UNI_USER_NAME` (`user_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;

INSERT INTO `users` (`id`, `password`, `user_role`, `user_name`, `source`)
VALUES
	(1,'21232f297a57a5a743894a0e4a801fc3',NULL,'admin','local');

/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table versions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `versions`;

CREATE TABLE `versions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` datetime NOT NULL COMMENT '创建时间内',
  `project_id` int(11) NOT NULL COMMENT '所属项目id',
  `version_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '迭代名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='版本表';




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
