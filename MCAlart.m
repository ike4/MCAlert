//
//  MCAlart.m
//  Tools
//
//  Created by ike on 2017/1/13.
//  Copyright © 2017年 ike. All rights reserved.
//

#import "MCAlart.h"
#import "MCSelendCell.h"

#define MCHEIGHT_K [[UIScreen mainScreen] bounds].size.height

@interface MCAlart ()<UITableViewDelegate,UITableViewDataSource>{
    __weak IBOutlet UITableView *mcTableView;
    NSArray *titles;
    __weak IBOutlet NSLayoutConstraint *mcTableView_X;
    NSString *selfTitle;
    NSArray *placeholders;
    NSMutableDictionary *dataDict;
    NSArray *btns;
    NSMutableDictionary *TFViewStyles;
    NSString *Key;
    __weak IBOutlet NSLayoutConstraint *mcTableView_H;
    BOOL btm;
    NSTextAlignment titleStyle;
}
@end

@implementation MCAlart
-(void)awakeFromNib{
    [super awakeFromNib];
    mcTableView.delegate = self;
    mcTableView.dataSource = self;
    mcTableView.scrollEnabled = NO;
    TFViewStyles = [NSMutableDictionary dictionaryWithCapacity:0];
    btm = NO;
    mcTableView_X.constant = MCHEIGHT_K;
    titleStyle = NSTextAlignmentCenter;
}
-(void)event{
    if (btm == YES){
        mcTableView_X.constant = MCHEIGHT_K- mcTableView_H.constant - 10;
    }else{
        mcTableView_X.constant = (MCHEIGHT_K- mcTableView_H.constant) / 2;
    }
    [self endEditing:YES];
}
-(MCAlart *(^)(int))mcLayoutKeyBourd{
    return ^MCAlart *(int style){
        [TFViewStyles setObject:@"0" forKey:@(style)];
        return self;
    };
}
-(MCAlart *(^)(NSArray *))mcLayoutAlertButtoms{
    return ^MCAlart *(NSArray *buttons){
        btns = [NSArray arrayWithArray:buttons];
        return self;
    };
}
+(MCAlart *)mcDefaultMCAlart{
    MCAlart *alert = [[[NSBundle mainBundle]loadNibNamed:@"MCAlart" owner:nil options:nil]objectAtIndex:0];
    UIWindow *window =  [UIApplication sharedApplication].delegate.window;
    alert.frame = [[UIScreen mainScreen] bounds];
    [window addSubview:alert];
    return alert;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(titles.count == 0 && placeholders.count == 0){
        return 0;
    }else if (titles.count != 0 && placeholders.count == 0) {
        return titles.count + 1;
    }else if (titles.count != 0 && placeholders.count != 0){
        return titles.count;
    }else{
        return placeholders.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idCell = @"Cell";
    MCAlartCell *cell = [tableView dequeueReusableCellWithIdentifier:idCell];
    if (!cell){
        if (titles.count != 0 && placeholders.count != 0) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MCAlart" owner:self options:nil]objectAtIndex:3];
        }else if (titles.count != 0 && placeholders.count == 0){
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MCAlart" owner:self options:nil]objectAtIndex:1];
        }else{
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MCAlart" owner:self options:nil]objectAtIndex:2];
        }
    }
    cell.buttomHeight = 1.0;
    [cell mcShowCellTitles:titles dataKey:Key TFViewPlaceholders:placeholders style:TFViewStyles showIndex:indexPath.row titileStyle:titleStyle];
    [cell mcTFViewReturnBeginShou:^(long index){
        if (index > 0 || btm == YES){
            mcTableView_X.constant = (MCHEIGHT_K- mcTableView_H.constant) / 2- ((index - 1) * 40);
        }else{
            if (btm == YES){
                mcTableView_X.constant = MCHEIGHT_K- mcTableView_H.constant - 10;
            }else{
                mcTableView_X.constant = (MCHEIGHT_K- mcTableView_H.constant) / 2;
            }
        }
    }];
    [cell mcReturnBtnClick:^(NSInteger btnTag, id data) {
        [dataDict setObject:data forKey:@(indexPath.row)];
    }];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (selfTitle.length != 0) {
        return 35;
    }else{
        return 0.0001;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(titles.count != 0 && placeholders.count == 0){
        return 0.0001;
    }else{
        return 35;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (selfTitle == nil){
        return nil;
    }else{
        MCAlartCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"MCAlart" owner:self options:nil]objectAtIndex:1];
        [cell mcShowCellTitles:@[selfTitle] dataKey:Key TFViewPlaceholders:nil style:nil showIndex:100 titileStyle:titleStyle];
        return cell;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (placeholders.count == 0 && titles == 0){
        return nil;
    }else{
        MCSelendCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"MCSelendCell" owner:nil options:nil]objectAtIndex:0];
        if (btns.count != 0) {
            [cell btns:btns];
        }
        if (placeholders.count == 0) {
            [cell.line removeFromSuperview];
        }
        [cell mcReturnBtnClick:^(NSInteger btnTag) {
            [self endEditing:YES];
            [self removeFromSuperview];
            if (btns.count != 0) {
                self.mcSelendIndex(btnTag,dataDict);
            }else{
                if (btnTag != 0) {
                    self.mcSelendIndex(btnTag,dataDict);
                }
            }
        }];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self endEditing:YES];
    [self removeFromSuperview];
    if (titles.count != 0 && placeholders.count == 0){
        if (indexPath.row != titles.count) {
            self.mcSelendIndex(indexPath.row,titles[indexPath.row]);
        }
    }
}
-(void)mcShowControllerAlartTitle:(NSString *)title ItmeNames:(NSArray *)names dataKey:(NSString *)dataKey ItmePlaceholders:(NSArray *)placeholder showButtomAlert:(BOOL)buttom mcAlartReturnIndex:(ReturnSelendIndex)block{
    self.mcSelendIndex = block;
    if (selfTitle.length == 0){
        dataDict = [NSMutableDictionary dictionaryWithCapacity:0];
        titles = [NSArray arrayWithArray:names];
        placeholders = [NSArray arrayWithArray:placeholder];
        btm = buttom;
        if (title != 0){
            selfTitle = title;
            mcTableView_H.constant += 35;
        }
        Key = dataKey;
        if (names.count == 0 && placeholders.count == 0){
            mcTableView_H.constant += 35;
        }else
        if (names.count != 0 && placeholders.count == 0){
            mcTableView_H.constant += (names.count + 1) * 44;
        }else if (names.count != 0 && placeholders.count != 0){
            UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event)];
            [self addGestureRecognizer:tapGesture];
            mcTableView_H.constant += 35;
            mcTableView_H.constant += names.count * 44;
        }else{
            UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event)];
            [self addGestureRecognizer:tapGesture];
            mcTableView_H.constant += 35;
            mcTableView_H.constant += placeholders.count * 44;
        }
        [self mcViewPoints:mcTableView_H.constant];
        [mcTableView reloadData];
    }
}
/**
 设置title NSTextAlignment
 */
-(MCAlart *(^)(NSTextAlignment))mcTitleStyle{
    return ^MCAlart *(NSTextAlignment alignment){
        titleStyle = alignment;
        return self;
    };
}
+(void)mcDefaultCancelControler:(UIViewController *)sender MCAlartTitle:(NSString *)title AlertString:(NSString *)string AlertNames:(NSArray *)names JsonKey:(NSString *)key showButtom:(BOOL)isOk isCancelStyle:(UIAlertActionStyle)style mcAlartReturnIndex:(ReturnSelendIndex)block{
    //初始化提示框；
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:string preferredStyle:UIAlertControllerStyleAlert];
    if (isOk != NO) {
        //初始化提示框；
        alert = [UIAlertController alertControllerWithTitle:title message:string preferredStyle:UIAlertControllerStyleActionSheet];
    }
    for (int i = 0; i < names.count; i ++){
        if (key == nil) {
            [alert addAction:[UIAlertAction actionWithTitle:names[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //点击按钮的响应事件；
                block(i,names[i]);
            }]];
        }else{
            [alert addAction:[UIAlertAction actionWithTitle:names[i][key] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //点击按钮的响应事件；
                block(i,names[i][key]);
            }]];
        }
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:style handler:nil]];
    //弹出提示框；
    [sender presentViewController:alert animated:true completion:nil];
}
+(void)mcDefaultControler:(UIViewController *)sender MCAlartTitle:(NSString *)title AlertString:(NSString *)string AlertNames:(NSArray *)names JsonKey:(NSString *)key showButtom:(BOOL)isOk mcAlartReturnIndex:(ReturnSelendIndex)block{
    //初始化提示框；
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:string preferredStyle:UIAlertControllerStyleAlert];
    if (isOk != NO) {
        //初始化提示框；
        alert = [UIAlertController alertControllerWithTitle:title message:string preferredStyle:UIAlertControllerStyleActionSheet];
    }
    for (int i = 0; i < names.count; i ++){
        if (key == nil) {
            [alert addAction:[UIAlertAction actionWithTitle:names[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //点击按钮的响应事件；
                block(i,names[i]);
            }]];
        }else{
            [alert addAction:[UIAlertAction actionWithTitle:names[i][key] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //点击按钮的响应事件；
                block(i,names[i][key]);
            }]];
        }
    }
    //弹出提示框；
    [sender presentViewController:alert animated:true completion:nil];
}
-(void)mcViewPoints:(CGFloat)array{
    // 动画完成后执行
    [UIView animateWithDuration:1.0 // 动画时长
                          delay:0.1 // 动画延迟
         usingSpringWithDamping:1.0 // 类似弹簧振动效果 0~1
          initialSpringVelocity:1.0 // 初始速度
                        options:UIViewAnimationOptionCurveEaseInOut // 动画过渡效果
                     animations:^{
                         // code...
                         if (btm == YES) {
                             CGPoint point = mcTableView.center;
                             point.y -= array-10;
                             [mcTableView setCenter:point];
                             mcTableView_X.constant = (MCHEIGHT_K - array) - 10;
                         }else{
                             CGPoint point = mcTableView.center;
                             point.y -= array / 2;
                             [mcTableView setCenter:point];
                             mcTableView_X.constant = (MCHEIGHT_K - array) / 2;
                         }
                     } completion:^(BOOL finished){
                     }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MCAlart *cell = (MCAlart *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
@end

@interface MCAlartCell ()<UITextFieldDelegate>{
    long indexs;
    __weak IBOutlet UILabel *name;
    __weak IBOutlet UIView *line;
    __weak IBOutlet UITextField *tfView;
}
@end

@implementation MCAlartCell
-(void)awakeFromNib{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    tfView.delegate = self;
}
-(void)mcShowCellTitles:(NSArray *)title dataKey:(NSString *)dataKey TFViewPlaceholders:(NSArray *)placeholder style:(NSDictionary *)styles showIndex:(long)index titileStyle:(NSTextAlignment)style{
    indexs = index;
    if(index == 100){
        name.text = title[0];
    }else{
        if (title.count != 0) {
            if (dataKey != nil) {
                if([title[index] isKindOfClass:[NSDictionary class]]){
                    name.text = title[index][dataKey];
                }else{
                    name.text = title[index];
                }
            }else{
                if (index == title.count){
                    name.text = @"取消";
                    name.textColor = [UIColor colorWithRed:0.0/255.0 green:111.0/255.0 blue:255.0/255.0 alpha:1.0];
                }else{
                   name.text = title[index];
                }
                
            }
        }
        if(placeholder.count != 0){
            if (placeholder.count > index) {
                tfView.placeholder = placeholder[index];
            }
        }
        [name setTextAlignment:style];
    }
    if ([[styles allKeys] containsObject:@(index)]) {
        tfView.keyboardType = UIKeyboardTypeDecimalPad;
    }
    
}
-(void)mcTFViewReturnBeginShou:(ReturnTFViewShouBegin)block{
    self.begin = block;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.begin(indexs);
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length != 0) {
        self.btnTag(0,textField.text);
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}
-(void)mcReturnBtnClick:(ReturnBtnClick)block{
    self.btnTag = block;
}
@end
