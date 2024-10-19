/*
 Navicat Premium Data Transfer

 Source Server         : localhost8
 Source Server Type    : MySQL
 Source Server Version : 80100 (8.1.0)
 Source Host           : localhost:3306
 Source Schema         : mass

 Target Server Type    : MySQL
 Target Server Version : 80100 (8.1.0)
 File Encoding         : 65001

 Date: 07/02/2024 17:18:32
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for approve_record
-- ----------------------------
DROP TABLE IF EXISTS `approve_record`;
CREATE TABLE `approve_record`  (
  `id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键ID',
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '审批类型代码，具体见枚举',
  `business_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '业务id',
  `apply_person` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '申请用户id',
  `status` int NOT NULL COMMENT '状态，具体见枚举',
  `create_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '审批记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of approve_record
-- ----------------------------
INSERT INTO `approve_record` VALUES ('1726497677591977985', 'club_apply', '1726497677457760257', '1724326247798517762', 2, '1724326247798517762', '2023-11-20 15:08:18', '1724326247798517762', '2023-11-20 15:08:34');
INSERT INTO `approve_record` VALUES ('1726623957276758017', 'club_activity_apply', '1726623957188677634', '1724327180171284481', 2, '1724327180171284481', '2023-11-20 23:30:05', '1724702704739663873', '2023-11-20 23:30:15');
INSERT INTO `approve_record` VALUES ('1736583154542096385', 'club_apply', '1736583154458210306', '1724327180171284481', 2, '1724327180171284481', '2023-12-18 11:04:23', '1724702704739663873', '2023-12-18 11:04:51');
INSERT INTO `approve_record` VALUES ('1736585197465985026', 'dissolve_club_apply', '1736583154458210306', '1724327180171284481', 0, '1724327180171284481', '2023-12-18 11:12:30', NULL, NULL);
INSERT INTO `approve_record` VALUES ('1754961295438303235', 'club_activity_apply', '1754961295383777281', '1724327180171284481', 2, '1724327180171284481', '2024-02-07 04:12:33', '1724702704739663873', '2024-02-07 04:56:44');

-- ----------------------------
-- Table structure for approve_record_detail
-- ----------------------------
DROP TABLE IF EXISTS `approve_record_detail`;
CREATE TABLE `approve_record_detail`  (
  `id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键ID',
  `approve_record_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '审批记录id',
  `approve_person` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '审批人id',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注，拒绝时必填拒绝原因',
  `status` int NOT NULL COMMENT '状态，具体见枚举',
  `create_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '审批记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of approve_record_detail
-- ----------------------------
INSERT INTO `approve_record_detail` VALUES ('1726497677717807106', '1726497677591977985', '1724326247798517762', '', 1, '1724326247798517762', '2023-11-20 15:08:18', '1724326247798517762', '2023-11-20 15:08:34');
INSERT INTO `approve_record_detail` VALUES ('1726497677717807107', '1726497677591977985', '1724702704739663873', NULL, 0, '1724326247798517762', '2023-11-20 15:08:18', NULL, NULL);
INSERT INTO `approve_record_detail` VALUES ('1726497677784915970', '1726497677591977985', '1724702790488014850', NULL, 0, '1724326247798517762', '2023-11-20 15:08:18', NULL, NULL);
INSERT INTO `approve_record_detail` VALUES ('1726623957427752961', '1726623957276758017', '1724702704739663873', '', 1, '1724327180171284481', '2023-11-20 23:30:05', '1724702704739663873', '2023-11-20 23:30:15');
INSERT INTO `approve_record_detail` VALUES ('1726623957469696001', '1726623957276758017', '1724702790488014850', NULL, 0, '1724327180171284481', '2023-11-20 23:30:05', NULL, NULL);
INSERT INTO `approve_record_detail` VALUES ('1736583154672119809', '1736583154542096385', '1724326247798517762', NULL, 0, '1724327180171284481', '2023-12-18 11:04:23', NULL, NULL);
INSERT INTO `approve_record_detail` VALUES ('1736583154672119810', '1736583154542096385', '1724702704739663873', '', 1, '1724327180171284481', '2023-12-18 11:04:23', '1724702704739663873', '2023-12-18 11:04:51');
INSERT INTO `approve_record_detail` VALUES ('1736583154672119811', '1736583154542096385', '1724702790488014850', NULL, 0, '1724327180171284481', '2023-12-18 11:04:23', NULL, NULL);
INSERT INTO `approve_record_detail` VALUES ('1736585197528899586', '1736585197465985026', '1724702704739663873', NULL, 0, '1724327180171284481', '2023-12-18 11:12:30', NULL, NULL);
INSERT INTO `approve_record_detail` VALUES ('1736984339744915458', '1736984339581337602', '1724702704739663873', NULL, 0, '1724327180171284481', '2023-12-19 13:38:33', NULL, NULL);
INSERT INTO `approve_record_detail` VALUES ('1754961295627046913', '1754961295438303235', '1724702704739663873', '', 1, '1724327180171284481', '2024-02-07 04:12:33', '1724702704739663873', '2024-02-07 04:56:44');
INSERT INTO `approve_record_detail` VALUES ('1754961295627046914', '1754961295438303235', '1724702790488014850', NULL, 0, '1724327180171284481', '2024-02-07 04:12:33', NULL, NULL);

-- ----------------------------
-- Table structure for approve_setting
-- ----------------------------
DROP TABLE IF EXISTS `approve_setting`;
CREATE TABLE `approve_setting`  (
  `id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '代码，具体见枚举',
  `method` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '审批方式，具体见枚举',
  `status` int NOT NULL COMMENT '状态，具体见枚举',
  `create_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '审批设置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of approve_setting
-- ----------------------------
INSERT INTO `approve_setting` VALUES ('1724701558436380674', '社团申请审批', 'club_apply', 'any', 0, '1724326247798517762', '2023-11-15 16:11:10', '1724326247798517762', '2023-11-20 15:01:58');
INSERT INTO `approve_setting` VALUES ('1725437875612860418', '社团活动经费申请审批', 'activity_cost_apply', 'both', 0, '1724326247798517762', '2023-11-17 16:57:01', '1724326247798517762', '2023-11-20 15:02:04');
INSERT INTO `approve_setting` VALUES ('1726506253895127041', '社团活动申请审批', 'club_activity_apply', 'any', 0, '1724326247798517762', '2023-11-20 15:42:23', NULL, NULL);
INSERT INTO `approve_setting` VALUES ('1736585145477586945', '社团解散审批', 'dissolve_club_apply', 'any', 0, '1724702704739663873', '2023-12-18 11:12:18', NULL, NULL);

-- ----------------------------
-- Table structure for approve_setting_detail
-- ----------------------------
DROP TABLE IF EXISTS `approve_setting_detail`;
CREATE TABLE `approve_setting_detail`  (
  `id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键ID',
  `approve_setting_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '审批设置id',
  `approve_person` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '审批人id',
  `sorted` tinyint NOT NULL DEFAULT 1 COMMENT '排序码',
  `status` int NOT NULL COMMENT '状态，具体见枚举',
  `create_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '审批设置明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of approve_setting_detail
-- ----------------------------
INSERT INTO `approve_setting_detail` VALUES ('1724702430880972801', '1724701558436380674', '1724326247798517762', 1, 0, '1724326247798517762', '2023-11-15 16:14:38', NULL, NULL);
INSERT INTO `approve_setting_detail` VALUES ('1724702938240761858', '1724701558436380674', '1724702704739663873', 3, 0, '1724326247798517762', '2023-11-15 16:16:39', NULL, NULL);
INSERT INTO `approve_setting_detail` VALUES ('1724703042301444098', '1724701558436380674', '1724702790488014850', 2, 0, '1724326247798517762', '2023-11-15 16:17:03', NULL, NULL);
INSERT INTO `approve_setting_detail` VALUES ('1726509508658257921', '1726506253895127041', '1724702704739663873', 2, 0, '1724326247798517762', '2023-11-20 15:55:19', '1724326247798517762', '2023-11-20 15:55:49');
INSERT INTO `approve_setting_detail` VALUES ('1726509597862715393', '1726506253895127041', '1724702790488014850', 1, 0, '1724326247798517762', '2023-11-20 15:55:40', NULL, NULL);
INSERT INTO `approve_setting_detail` VALUES ('1736585176632877057', '1736585145477586945', '1724702704739663873', 1, 0, '1724702704739663873', '2023-12-18 11:12:25', NULL, NULL);

-- ----------------------------
-- Table structure for club
-- ----------------------------
DROP TABLE IF EXISTS `club`;
CREATE TABLE `club`  (
  `id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键ID',
  `type_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '社团类型代码',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '社团名称',
  `leader_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '社长id，对应用户id',
  `logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'logo',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '描述',
  `status` int NOT NULL COMMENT '状态，具体见枚举',
  `create_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '社团表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of club
-- ----------------------------
INSERT INTO `club` VALUES ('1726497677457760257', 'music', '吉他社', '1724327180171284481', 'http://localhost:80/storage/img/2023/11/20/logo-1726497624508866560.png', '吉他社2', 0, '1724326247798517762', '2023-11-20 15:08:18', '1724327180171284481', '2024-02-06 03:17:34');
INSERT INTO `club` VALUES ('1736583154458210306', 'game', '测试解散社团', '1724327180171284481', 'http://localhost:80/storage/img/2023/12/18/logo-1736583140742836224.png', '测试', 4, '1724327180171284481', '2023-12-18 11:04:23', '1724327180171284481', '2023-12-19 13:38:33');

-- ----------------------------
-- Table structure for club_activity
-- ----------------------------
DROP TABLE IF EXISTS `club_activity`;
CREATE TABLE `club_activity`  (
  `id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键ID',
  `club_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '举办社团id',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '活动类型，具体见枚举',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '活动名称',
  `location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '活动地点',
  `start_time` datetime NOT NULL COMMENT '活动开始时间',
  `end_time` datetime NOT NULL COMMENT '活动结束时间',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '活动描述',
  `status` int NOT NULL COMMENT '状态，具体见枚举',
  `reject_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '驳回原因',
  `create_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '社团活动表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of club_activity
-- ----------------------------
INSERT INTO `club_activity` VALUES ('1726623957188677634', '1726497677457760257', 'recruitment', '2023纳新活动', '东院操场', '2023-11-20 23:29:00', '2023-11-30 23:29:00', '2023纳新活动，请社员们积极报名参加！', 5, NULL, '1724327180171284481', '2023-11-20 23:30:05', '1', '2024-02-06 04:28:00');
INSERT INTO `club_activity` VALUES ('1754961295383777281', '1726497677457760257', 'recruitment', '2024纳新活动', '东院操场', '2024-02-07 04:12:00', '2024-02-17 04:12:00', '', 4, NULL, '1724327180171284481', '2024-02-07 04:12:33', '1724702704739663873', '2024-02-07 04:56:44');

-- ----------------------------
-- Table structure for club_activity_user
-- ----------------------------
DROP TABLE IF EXISTS `club_activity_user`;
CREATE TABLE `club_activity_user`  (
  `id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键ID',
  `activity_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '活动id',
  `user_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户id',
  `signup_time` datetime NOT NULL COMMENT '报名时间',
  `sign_in_flag` tinyint NOT NULL DEFAULT 0 COMMENT '是否签到',
  `sign_in_time` datetime NULL DEFAULT NULL COMMENT '签到时间',
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '缺席原因',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '社团活动-用户报名表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of club_activity_user
-- ----------------------------
INSERT INTO `club_activity_user` VALUES ('1726623957213843457', '1726623957188677634', '1724327180171284481', '2023-11-24 15:36:01', 1, '2023-12-07 15:40:17', NULL);
INSERT INTO `club_activity_user` VALUES ('1754961295438303234', '1754961295383777281', '1724327180171284481', '2024-02-07 04:12:00', 0, NULL, NULL);

-- ----------------------------
-- Table structure for club_attachment
-- ----------------------------
DROP TABLE IF EXISTS `club_attachment`;
CREATE TABLE `club_attachment`  (
  `id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键',
  `club_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '社团id',
  `name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件名',
  `suffix` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件后缀',
  `original_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '原文件名',
  `media_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件类型',
  `file_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '存储文件名',
  `file_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件路径',
  `access_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '访问路径',
  `size` bigint NULL DEFAULT NULL COMMENT '文件大小',
  `create_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '社团附件表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of club_attachment
-- ----------------------------
INSERT INTO `club_attachment` VALUES ('1732340340018843650', '1726497677457760257', 'logo', 'png', 'logo.png', 'image/png', 'logo-1732340339977072640.png', '/club/2023/12/6/logo-1732340339977072640.png', 'http://localhost:80/storage/club/2023/12/6/logo-1732340339977072640.png', 876, '1724327180171284481', '2023-12-06 18:04:57', NULL, NULL);

-- ----------------------------
-- Table structure for club_finance
-- ----------------------------
DROP TABLE IF EXISTS `club_finance`;
CREATE TABLE `club_finance`  (
  `id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键ID',
  `club_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '社团id',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '类型，具体见枚举',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标题',
  `amount` decimal(10, 2) NOT NULL COMMENT '金额',
  `status` int NOT NULL COMMENT '状态，具体见枚举',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '备注',
  `create_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '社团财务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of club_finance
-- ----------------------------
INSERT INTO `club_finance` VALUES ('1732687769658355713', '1726497677457760257', 'income', '餐厅赞助', 10.00, 2, '', '1724327180171284481', '2023-12-07 17:05:31', NULL, NULL);

-- ----------------------------
-- Table structure for club_quit_apply
-- ----------------------------
DROP TABLE IF EXISTS `club_quit_apply`;
CREATE TABLE `club_quit_apply`  (
  `id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键ID',
  `club_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '社团id',
  `apply_person` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '申请rid',
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '申请退团原因',
  `status` int NOT NULL COMMENT '状态，具体见枚举',
  `approve_opinion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审批意见',
  `create_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '退团申请表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of club_quit_apply
-- ----------------------------
INSERT INTO `club_quit_apply` VALUES ('1755153055154298881', '1726497677457760257', '1725078980373626881', '测试', 0, NULL, '1725078980373626881', '2024-02-07 16:54:32', NULL, NULL);

-- ----------------------------
-- Table structure for club_recruitment
-- ----------------------------
DROP TABLE IF EXISTS `club_recruitment`;
CREATE TABLE `club_recruitment`  (
  `id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键ID',
  `activity_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '活动id',
  `apply_person` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '申请人id',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '自我介绍',
  `status` int NULL DEFAULT NULL COMMENT '状态，具体见枚举',
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '拒绝原因',
  `approve_person` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审批人',
  `approve_time` datetime NULL DEFAULT NULL COMMENT '审批时间',
  `create_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '社团报名表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of club_recruitment
-- ----------------------------
INSERT INTO `club_recruitment` VALUES ('1728748264262025218', '1726623957188677634', '1724690348215115777', '嗷嗷', 3, NULL, NULL, NULL, '1724690348215115777', '2023-11-26 20:11:19', '1724690348215115777', '2023-11-26 20:46:49');
INSERT INTO `club_recruitment` VALUES ('1732056350179553282', '1726623957188677634', '1724690348215115777', 'asdasd', 2, '不符号要求', '1724327180171284481', '2023-12-19 14:50:35', '1724690348215115777', '2023-12-05 23:16:29', '1724327180171284481', '2023-12-19 14:50:35');
INSERT INTO `club_recruitment` VALUES ('1754973263763169282', '1754961295383777281', '1725078980373626881', '111', 1, '', '1724327180171284481', '2024-02-07 05:13:19', '1725078980373626881', '2024-02-07 05:00:07', '1724327180171284481', '2024-02-07 05:13:19');

-- ----------------------------
-- Table structure for club_type
-- ----------------------------
DROP TABLE IF EXISTS `club_type`;
CREATE TABLE `club_type`  (
  `id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键ID',
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '代码',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '类型名称',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '描述',
  `create_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `club_type_code_unique`(`code` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '社团类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of club_type
-- ----------------------------
INSERT INTO `club_type` VALUES ('1724713504736890881', 'science', '学术', '学术性社团', '1724326247798517762', '2023-11-15 16:58:38', NULL, NULL);
INSERT INTO `club_type` VALUES ('1724713668188917761', 'music', '音乐', '音乐性社团', '1724326247798517762', '2023-11-15 16:59:17', NULL, NULL);
INSERT INTO `club_type` VALUES ('1726628450894680066', 'game', '电竞', '电子竞技', '1724702704739663873', '2023-11-20 23:47:57', '1724702704739663873', '2023-11-20 23:48:05');

-- ----------------------------
-- Table structure for club_user
-- ----------------------------
DROP TABLE IF EXISTS `club_user`;
CREATE TABLE `club_user`  (
  `id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键ID',
  `club_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '社团id',
  `user_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户id',
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户在该社团中的角色，具体见枚举',
  `join_time` datetime NOT NULL COMMENT '加入时间',
  `create_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `club_user_unique`(`club_id` ASC, `user_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '社团成员表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of club_user
-- ----------------------------
INSERT INTO `club_user` VALUES ('1726497677524869121', '1726497677457760257', '1724327180171284481', 'president', '2023-11-20 15:08:18', '1724326247798517762', '2023-11-20 15:08:18', NULL, NULL);
INSERT INTO `club_user` VALUES ('1726497677524869231', '1736583154458210306', '1724327180171284481', 'president', '2023-12-18 11:04:23', '1724327180171284481', NULL, NULL, NULL);
INSERT INTO `club_user` VALUES ('1754976588650860546', '1726497677457760257', '1725078980373626881', 'member', '2024-02-07 05:13:19', '1724327180171284481', '2024-02-07 05:13:19', '1724327180171284481', '2024-02-07 15:59:28');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键ID',
  `type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '类别，具体见枚举',
  `club_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '社团id',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '公告内容',
  `publisher` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '发布人',
  `create_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '通知表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES ('1732614359611760642', 'club', '1726497677457760257', '测试通知', '啊实打实肯德基', '1724327180171284481', '1724327180171284481', '2023-12-07 12:13:48', NULL, NULL);
INSERT INTO `sys_notice` VALUES ('1732614479254282241', 'club', '1726497677457760257', 'asdasd', 'asdasd', '1724327180171284481', '1724327180171284481', '2023-12-07 12:14:17', NULL, NULL);
INSERT INTO `sys_notice` VALUES ('1737364575959425025', 'system', '', '哈哈哈', '阿三大苏打', '1724326247798517762', '1724326247798517762', '2023-12-20 14:49:28', NULL, NULL);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主键ID',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户名',
  `nickname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '昵称',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户密码',
  `salt` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '加密盐',
  `role` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色, 具体见枚举',
  `sex` int NULL DEFAULT NULL COMMENT '性别，具体见枚举',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '用户头像地址',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '手机号码',
  `info` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '个人说明',
  `status` tinyint NULL DEFAULT 0 COMMENT '状态，具体见枚举',
  `recent_login` datetime NULL DEFAULT NULL COMMENT '最近登陆时间',
  `create_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES ('1724326247798517762', 'admin', '管理员', '4e58afd1aa91bdf872eb8d833ea57ff0', '$2a$10$x1Ak8SqGDFz5V2vKeqa.fu', 'admin', 1, NULL, '', '178157837508', NULL, 0, '2024-02-06 01:52:26', '', '2023-11-14 15:19:49', '1724326247798517762', '2024-02-06 01:52:26');
INSERT INTO `sys_user` VALUES ('1724327180171284481', 'kcaco', '顾白秋', 'b36a653686ffa0591e4b4525683a0883', '$2a$10$h7sfPjJqtwuTaD2QTc.0x.', 'student', 1, NULL, 'http://localhost:80/storage/img/2023/12/11/photo-1518435-1734166154406629376.jpeg', '178157837508', NULL, 0, '2024-02-06 21:23:22', '', '2023-11-14 15:23:31', '1724327180171284481', '2024-02-06 21:23:22');
INSERT INTO `sys_user` VALUES ('1724690348215115777', 'student2', '史莱特', 'ef24b01650507e2ef3f303cbf6534aee', '$2a$10$WA7i0SrCZQgPSRM1UhNrW.', 'student', 1, NULL, '', '178157837508', NULL, 0, '2023-12-08 14:16:11', '', '2023-11-15 15:26:37', '1724690348215115777', '2023-12-08 14:16:11');
INSERT INTO `sys_user` VALUES ('1724702704739663873', 'teacher1', '老师1', 'ce50f828e77b8e7a39208580859b06b9', '$2a$10$wr6azDIP1XnQwu81ssVyzO', 'teacher', 1, NULL, '', '178157837508', NULL, 0, '2024-02-06 02:31:56', '', '2023-11-15 16:15:43', '1724702704739663873', '2024-02-06 02:31:56');
INSERT INTO `sys_user` VALUES ('1724702790488014850', 'teacher2', '老师2', '32963e0177cff849e5baf8f2153861f4', '$2a$10$sECMD/X6/NGyb7Fxi6mpHe', 'teacher', 1, NULL, '', '178157837508', NULL, 0, NULL, '', '2023-11-15 16:16:03', '', NULL);
INSERT INTO `sys_user` VALUES ('1725078980373626881', '166', '十六啊', '647bc7fa99bb16550b63ba72247a27d6', '$2a$10$7qqnFu6CGVwBsL2GQfa9AO', 'student', 1, '', '', '1782612312', NULL, 0, '2024-02-07 03:52:49', '1724326247798517762', '2023-11-16 17:10:54', '1725078980373626881', '2024-02-07 03:52:49');

SET FOREIGN_KEY_CHECKS = 1;
