//
//  MCSelendCell.h
//  Tools
//
//  Created by ike on 2017/1/14.
//  Copyright © 2017年 ike. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReturnBtnSelendClick)(NSInteger btnTag);
@interface MCSelendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *line;
-(void)btns:(NSArray *)btns;
@property(nonatomic,copy)ReturnBtnSelendClick btnTag;
-(void)mcReturnBtnClick:(ReturnBtnSelendClick)block;
@end
