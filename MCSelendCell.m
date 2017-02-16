//
//  MCSelendCell.m
//  Tools
//
//  Created by ike on 2017/1/14.
//  Copyright © 2017年 ike. All rights reserved.
//

#import "MCSelendCell.h"

@interface MCSelendCell (){
    __weak IBOutlet UIButton *button1;
    __weak IBOutlet UIButton *button;
}

@end

@implementation MCSelendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)btns:(NSArray *)btns{
    [button setTitle:btns[0] forState:0];
    if (btns.count == 2) {
        [button1 setTitle:btns[1] forState:0];
    }
}
- (IBAction)buttonClick:(UIButton *)sender{
    self.btnTag(sender.tag);
}
-(void)mcReturnBtnClick:(ReturnBtnSelendClick)block{
    self.btnTag = block;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
