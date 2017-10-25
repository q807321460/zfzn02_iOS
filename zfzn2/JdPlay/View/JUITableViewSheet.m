//
//  JUITableViewSheet.m
//  智能音响
//
//  Created by henry on 15/5/29.
//  Copyright (c) 2015年 york. All rights reserved.
//

#import "JUITableViewSheet.h"
#import <JdPlaySdk/JdPlaySdk.h>
#import "JUIActionButton.h"


const NSInteger tapBGViewTag         = 4292;
const NSInteger cancelButtonTag      = 9382;
const NSInteger buttonParentsViewTag = 28453;
#define kActionButtonHeight 44.0f
#define kBGFadeDuration .2
#define UIColorFromRGB(rgbValue)  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0f green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:1.0f]

@interface JUITableViewSheet()
{
    JdShareClass * shareObj;
}
@end


@implementation JUITableViewSheet

- (id) initWithTitle:(NSString *)title withDelegate:(id<JUITableViewSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelTitle withData:(NSArray*)data
{
    if (self = [super init])
    {
        shareObj = [JdShareClass sharedInstance];
        _title              = title;
        _cancelTitle        = cancelTitle;
        _delegate           = delegate;
        cancelButtonIndex  = -1;
        _dataList = [NSMutableArray arrayWithArray:data];
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [self setAutoresizesSubviews:YES];
        
        // Create the background clear tap responder view
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissTapActionSheet:)];
        UIView* tapBGView = [[UIView alloc] initWithFrame:self.frame];
        tapBGView.tag = tapBGViewTag;
        
        [tapBGView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.3]];
        [tapBGView addGestureRecognizer:tapGesture];
        [tapBGView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [self addSubview:tapBGView];
    }
    
    return self;
}


+ (id) sheetWithTitle:(NSString *)title withDelegate:(id<JUITableViewSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelTitle withData:(NSArray *)data
{
    return [[JUITableViewSheet alloc] initWithTitle:title withDelegate:delegate cancelButtonTitle:cancelTitle withData:data];
}


- (UIView*) layoutButtonsWithTitle:(BOOL) allowTitle
{
    CGFloat titleOffset                 = (_title == nil || !allowTitle) ? 0 : 44;
    CGFloat buttonHeight                = kActionButtonHeight;
    NSInteger buttonCount               = _cancelTitle ? (_dataList.count + 1) : _dataList.count;
    if (buttonCount>6)
    {
        buttonCount = 6;
    }
    CGFloat parentViewHeight            = ((buttonHeight * buttonCount) + titleOffset);
    UIView* buttonParentView            = [[UIView alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(self.bounds) - parentViewHeight), CGRectGetWidth(self.bounds), parentViewHeight)];
    CGFloat currentButtonTop            = buttonParentView.bounds.size.height - buttonHeight;
    CGFloat currentButtonTag            = 0;
    buttonParentView.backgroundColor    =  [UIColor colorWithRed:246.0/255 green:246.0/255 blue:246.0/255 alpha:1.0];
    if (_cancelTitle)
    {
        JUIActionButton* cancelButton =[[JUIActionButton alloc] initWithTitle:_cancelTitle withImage:nil isCancel:YES];
        [cancelButton setFrame:CGRectMake(0, currentButtonTop, CGRectGetWidth(buttonParentView.bounds), buttonHeight)];
        cancelButton.tag = currentButtonTag++;
        cancelButtonIndex = (int)cancelButton.tag;
        [cancelButton setBackgroundImage:[self  createImageWithColor:[UIColor whiteColor] ] forState:UIControlStateHighlighted];
        [cancelButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [buttonParentView addSubview:cancelButton];
        currentButtonTop -= buttonHeight;
        [cancelButton setDividerBackgroundColor:[UIColor colorWithRed:209.0/255 green:208.0/255 blue:208.0/255 alpha:1.0]];
    }
    
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, titleOffset, CGRectGetWidth(buttonParentView.bounds), CGRectGetHeight(buttonParentView.bounds)-titleOffset-buttonHeight) style:UITableViewStylePlain];
    tableview.separatorColor = [UIColor colorWithRed:209.0/255 green:208.0/255 blue:208.0/255 alpha:1.0];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.bounces = NO;
    tableview.tableFooterView =[[UIView alloc]init];
    [buttonParentView addSubview:tableview];
    // Handle creating the title object if there is a title provided
    if (_title.length > 0 && allowTitle)
    {
        UIView* titleContainer =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(buttonParentView.bounds), titleOffset)];
        [titleContainer setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin)];
        titleContainer.backgroundColor = [UIColor colorWithRed:246.0/255 green:246.0/255 blue:246.0/255 alpha:1.0];
        playOrder = [[UIButton alloc] initWithFrame:CGRectMake(4, 0, 44, 44)];
        playOrder.hidden = YES;
        [playOrder addTarget:self action:@selector(onclickBnt:)forControlEvents:UIControlEventTouchUpInside];
       //默认图标
        [playOrder setImage:[UIImage imageNamed:@"pop_play_mode_sort"] forState:UIControlStateNormal];
        
        if (shareObj.playOrder == 1)
        {
            [playOrder setImage:[UIImage imageNamed:@"pop_play_mode_single"] forState:UIControlStateNormal];
        }
        else if (shareObj.playOrder == 2)
        {
            [playOrder setImage:[UIImage imageNamed:@"pop_shuffle_nomal"] forState:UIControlStateNormal];
        }else if (shareObj.playOrder == 0)   //REPEAT_ALL
        {
            [playOrder setImage:[UIImage imageNamed:@"pop_play_mode_sort"] forState:UIControlStateNormal];
        }
        
        playOrder.tag=102;
        [titleContainer addSubview:playOrder];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, titleOffset-0.5, CGRectGetWidth(buttonParentView.bounds), 0.5)];
        line.backgroundColor = [UIColor colorWithRed:209.0/255 green:208.0/255 blue:208.0/255 alpha:1.0];
        [titleContainer addSubview:line];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleContainer.frame.size.width*3/4, titleOffset)];
        titleLabel.center= CGPointMake(titleContainer.frame.size.width/2, titleContainer.frame.size.height/2);
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [titleLabel setShadowOffset:CGSizeMake(0, -1.0)];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setText:_title];
        [titleContainer addSubview:titleLabel];
        [buttonParentView addSubview:titleContainer];
    }
    [buttonParentView setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth)];
    return buttonParentView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}

-(void)buttonClicked:(UIButton*)sender
{
    if (cancelButtonIndex == sender.tag)
    {
        [self dismissActionSheet:sender];
        return;
    }
    
    if ([_delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)])
        [_delegate actionSheet:self clickedButtonAtIndex:sender.tag];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identify = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identify];
    UIImageView* mark;
    UILabel* title;
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify ];
        cell.backgroundColor = [UIColor colorWithRed:246.0/255 green:246.0/255 blue:246.0/255 alpha:1.0];
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        
        title = [[UILabel alloc]initWithFrame:CGRectMake(10, 12, cell.frame.size.width - 50, 20)];
        title.tag = 101;
        title.textColor = [UIColor blackColor];
        title.font = [UIFont systemFontOfSize:14];
        title.highlightedTextColor = [UIColor colorWithRed:215/255.0 green:46/255.0 blue:33/255.0 alpha:1];
        mark = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pop_play_list_current"]];
        [mark setFrame:CGRectMake(cell.frame.size.width - 50, 0, 20, 40)];
        mark.contentMode = UIViewContentModeScaleAspectFit;
        mark.tag = 102;
        [cell.contentView addSubview:title];
        [cell.contentView addSubview:mark];
        
    }
    else
    {
        title = (UILabel*)[cell viewWithTag:101];
        mark = (UIImageView*)[cell viewWithTag:102];
    }
    
    JdSongsModel * songModel = [_dataList objectAtIndex:indexPath.row];
    title.text = [NSString stringWithFormat:@"%@",songModel.song_name];
    
    
    if([songModel.song_id isEqualToString:shareObj.currentPlaySongId])
    {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        lastCell = cell;
        mark.hidden = NO;
    }
    else
    {
        mark.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_delegate actionSheet:self tableSelectRowAtIndexPath:indexPath.row];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UIImageView* mark = (UIImageView*)[cell viewWithTag:102];
    mark.hidden = NO;
    UIImageView* lastMark = (UIImageView*)[lastCell viewWithTag:102];
    lastMark.hidden = YES;
    lastCell = cell;
}

-(void)onclickBnt:(UIButton*)sender
{
    switch (sender.tag) {
        case 102:
        {
            int nextMode;
            if (shareObj.playOrder == 1) {
                nextMode = 2; //随机
                [playOrder setImage:[UIImage imageNamed:@"pop_shuffle_nomal"] forState:UIControlStateNormal];
            }else if (shareObj.playOrder == 2){
                nextMode = 0;
                [playOrder setImage:[UIImage imageNamed:@"pop_play_mode_sort"] forState:UIControlStateNormal];
            }else{ //REPEAT_ALL
                nextMode = 1;
                [playOrder setImage:[UIImage imageNamed:@"pop_play_mode_single"] forState:UIControlStateNormal];
            }
            [self buttonClicked:sender];
            [self changeTitle:nextMode];
            
            break;
        }
            
    }
    
}

-(void)changeTitle:(int)order
{
    NSString *title;
    switch (order) {
        case 0:
            title = @"顺序播放队列(共%d首)";
            break;
        case 1:
            title = @"单曲播放队列(共%d首)";
            break;
        case 2:
            title = @"随机播放队列(共%d首)";
            break;
        default:
            break;
    }

    NSString* sheetTitle = [NSString stringWithFormat:title,_dataList.count];
    titleLabel.text = sheetTitle;
}

- (UIImage *)createImageWithColor:(UIColor *)color
{
    
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return theImage;
}

-(void)flashUI:(NSMutableArray*)data
{
    NSLog(@"=========flashUI");
    _dataList = data;
    [self changeTitle:shareObj.playOrder];
    [tableview reloadData];
}

- (void) showInView:(UIView *)parentView
{
    //UIView* viewToAddTo = [UIApplication sharedApplication].keyWindow.subviews[0];
    //[self setFrame:viewToAddTo.bounds];
    [self setFrame:parentView.bounds];

    
    // Create the parent UIView that houses the JLActionButtons
    UIView* buttonsParentView   = [self layoutButtonsWithTitle:YES];
    buttonsParentView.tag       = buttonParentsViewTag;
    CGPoint originalCenter      = buttonsParentView.center;
    [buttonsParentView setCenter:CGPointMake(buttonsParentView.center.x, (CGRectGetHeight(self.bounds) + (CGRectGetHeight(buttonsParentView.bounds) / 2)))];
    [self addSubview:buttonsParentView];
    
    [self setAlpha:0.0f];
    //[viewToAddTo addSubview:self];
    [parentView addSubview:self];

    [UIView animateWithDuration:kBGFadeDuration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self setAlpha:1.0f];
        [buttonsParentView setCenter:originalCenter];
    }completion:nil];
}

-(void)dismissTapActionSheet:(UITapGestureRecognizer*)recognizer
{
    [self dismissActionSheet:recognizer.view];
}

- (void) dismissActionSheet:(UIView*) sender
{
    UIView* buttonsParentView = [self viewWithTag:buttonParentsViewTag];
    [UIView animateWithDuration:(kBGFadeDuration + .05) delay:0.175 options:UIViewAnimationOptionCurveLinear animations:^{
        [[self viewWithTag:tapBGViewTag] setAlpha:0.0f];
        [buttonsParentView setCenter:CGPointMake(buttonsParentView.center.x, (CGRectGetHeight(self.bounds) + (CGRectGetHeight(buttonsParentView.bounds) / 2)))];
    }completion:^(BOOL finished)
     {
         [self removeFromSuperview];
     }];
}

- (void) showOnViewController:(UIViewController *)parentViewController
{
    [self showInView:parentViewController.view];
}


@end
