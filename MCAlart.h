//
//  MCAlart.h
//  Tools
//
//  Created by ike on 2017/1/13.
//  Copyright © 2017年 ike. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ReturnSelendIndex)(NSInteger mcItem,id mcData);

@interface MCAlart : UIView
//@property(nonatomic)MCalertStyle style;
@property(nonatomic, copy)ReturnSelendIndex mcSelendIndex;

+(MCAlart *)mcDefaultMCAlart;
/**
 根据类型来写值
 buttom 是否显示在底部 默认中间
 dataKey 数组中包含字典 解析key
 placeholder
 block 数据回调
 */
-(void)mcShowControllerAlartTitle:(NSString *)title ItmeNames:(NSArray *)names dataKey:(NSString *)dataKey ItmePlaceholders:(NSArray *)placeholder showButtomAlert:(BOOL)buttom mcAlartReturnIndex:(ReturnSelendIndex)block;
/**
 设置Buttom buttons <= count[2]
 */
-(MCAlart *(^)(NSArray *))mcLayoutAlertButtoms;
/**
 设置MCTFView keyboard风格数字 默认0
 */
-(MCAlart *(^)(int))mcLayoutKeyBourd;
/**
 不带取消按钮
 sender 控制器
 title 标题
 string 文字
 names 提示选项
 key  数据key
 */
+(void)mcDefaultControler:(UIViewController *)sender MCAlartTitle:(NSString *)title AlertString:(NSString *)string AlertNames:(NSArray *)names JsonKey:(NSString *)key showButtom:(BOOL)isOk mcAlartReturnIndex:(ReturnSelendIndex)block;
/**
 带取消按钮
 sender 控制器
 title 标题
 string 文字
 names 提示选项
 key  数据key
 Cancel 是否添加取消按钮
 style 取消按钮风格
 */
+(void)mcDefaultCancelControler:(UIViewController *)sender MCAlartTitle:(NSString *)title AlertString:(NSString *)string AlertNames:(NSArray *)names JsonKey:(NSString *)key showButtom:(BOOL)isOk isCancelStyle:(UIAlertActionStyle)style mcAlartReturnIndex:(ReturnSelendIndex)block;
#pragma mark 单个Label state
/**
 设置title NSTextAlignment
 */
-(MCAlart *(^)(NSTextAlignment))mcTitleStyle;
@end

typedef void(^ReturnBtnClick)(NSInteger btnTag,id data);
typedef void(^ReturnTFViewShouBegin)(long index);
@interface MCAlartCell : UITableViewCell
@property(nonatomic,assign)CGFloat buttomHeight;
@property(nonatomic,copy)ReturnBtnClick btnTag;
@property(nonatomic,copy)ReturnTFViewShouBegin begin;
-(void)mcReturnBtnClick:(ReturnBtnClick)block;
-(void)mcTFViewReturnBeginShou:(ReturnTFViewShouBegin)block;
-(void)mcShowCellTitles:(NSArray *)title dataKey:(NSString *)dataKey TFViewPlaceholders:(NSArray *)placeholder style:(NSDictionary *)styles showIndex:(long)index titileStyle:(NSTextAlignment)style;
@end
