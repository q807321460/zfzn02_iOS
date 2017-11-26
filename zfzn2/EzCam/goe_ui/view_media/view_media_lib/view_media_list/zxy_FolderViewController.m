//
//  zxy_FolderViewController.m
//  P2PONVIF_PRO
//
//  Created by zxy on 14-5-10.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "zxy_FolderViewController.h"
#import "foler_item.h"
@interface zxy_FolderViewController ()

@end

@implementation zxy_FolderViewController
@synthesize view_main;

@synthesize view_pic;
@synthesize mode_pic_tool;
@synthesize mode_pic_button_edit;
@synthesize mode_pic_button_delete;
@synthesize mode_pic_label;
@synthesize m_tableview_pic;

@synthesize view_video;
@synthesize mode_video_tool;
@synthesize mode_video_label;
@synthesize mode_video_button_edit;
@synthesize mode_video_button_delete;
@synthesize m_tableview_video;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    m_folder_cur_mode=0;
    m_file_cur_mode=0;
    MyShareData=[zxy_share_data getInstance];
    m_strings=[vv_strings getInstance];
    f_shared= [FGalleryShared getInstance];
    
    m_width=MyShareData.screen_width;
    m_height=MyShareData.screen_height-MyShareData.status_bar_height-MyShareData.screen_y_offset;
    m_y_offset=MyShareData.screen_y_offset;
    view_main.frame=CGRectMake(0, m_y_offset, m_width, m_height);
    
    view_folder.frame=CGRectMake(0, 0, m_width, m_height);
    mode_folder_tool.frame=CGRectMake(0, 0, m_width, 44);
    _m_tableview.frame=CGRectMake(0, 44, m_width, m_height-44);
    [mode_folder_tool setBackgroundColor:UIColorFromRGB(m_strings.top_gray)];
    [mode_folder_label setTextColor:UIColorFromRGB(m_strings.text_gray)];
    
    [mode_folder_button_edit setBackgroundColor:UIColorFromRGB(m_strings.background_blue)];
    mode_folder_button_edit.showsTouchWhenHighlighted = YES;
    [mode_folder_button_delete setBackgroundColor:UIColorFromRGB(m_strings.orange)];
    mode_folder_button_delete.showsTouchWhenHighlighted = YES;
    mode_folder_button_delete.adjustsImageWhenDisabled=NO;
    [mode_folder_button_delete.layer setMasksToBounds:YES];
    [mode_folder_button_delete.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    [mode_folder_button_delete.layer setBorderWidth:1.0]; //边框宽度
    [mode_folder_button_edit.layer setMasksToBounds:YES];
    [mode_folder_button_edit.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    [mode_folder_button_edit.layer setBorderWidth:1.0]; //边框宽度
    
    view_file.frame=CGRectMake(0, 0, m_width, m_height);
    mode_file_tool.frame=CGRectMake(0, 0, m_width, 44);
    m_file_tableview.frame=CGRectMake(0, 44, m_width, m_height-44);
    [mode_file_tool setBackgroundColor:UIColorFromRGB(m_strings.top_gray)];
    [mode_file_label setTextColor:UIColorFromRGB(m_strings.text_gray)];
    
    
    [mode_file_button_edit setBackgroundColor:UIColorFromRGB(m_strings.background_blue)];
    mode_file_button_edit.showsTouchWhenHighlighted = YES;
    [mode_file_button_delete setBackgroundColor:UIColorFromRGB(m_strings.orange)];
    mode_file_button_delete.showsTouchWhenHighlighted = YES;
    mode_file_button_delete.adjustsImageWhenDisabled=YES;
    mode_file_button_edit.showsTouchWhenHighlighted = YES;
    mode_file_button_delete.showsTouchWhenHighlighted = YES;
    mode_file_button_delete.adjustsImageWhenDisabled=YES;
    
    [mode_file_button_edit.layer setMasksToBounds:YES];
    [mode_file_button_edit.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    [mode_file_button_edit.layer setBorderWidth:1.0]; //边框宽度
    [mode_file_button_delete.layer setMasksToBounds:YES];
    [mode_file_button_delete.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    [mode_file_button_delete.layer setBorderWidth:1.0]; //边框宽度
    //[mode_folder_button_delete setBackgroundImage:[UIImage imageNamed:@"png_left_gray.png"] forState:UIControlStateHighlighted];
    
    mode_folder_label.text=MYLocalizedString(@"m_folder", @"");
    [mode_folder_button_edit setTitle:MYLocalizedString(@"m_edit", @"") forState:UIControlStateNormal];
    [mode_folder_button_delete setTitle:MYLocalizedString(@"m_delete", @"") forState:UIControlStateNormal];
    mode_file_label.text=MYLocalizedString(@"m_pic_file", @"");
    [mode_file_button_edit setTitle:MYLocalizedString(@"m_edit", @"") forState:UIControlStateNormal];
    [mode_file_button_delete setTitle:MYLocalizedString(@"m_delete", @"") forState:UIControlStateNormal];
    
    m_file_manager=[pic_file_manager getInstance];
    [m_file_manager init_file_path];
    
    m_folder_array=[NSMutableArray new];
    m_file_array=[NSMutableArray new];
    m_folder_delete_array=[NSMutableArray new];
    m_file_delete_array=[NSMutableArray new];
   // m_localCaptions=[NSMutableArray new];
   // m_localImages=[NSMutableArray new];
    
    my_path= [m_file_manager get_file_path];
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    NSArray* tempArray = [fileMgr subpathsOfDirectoryAtPath:my_path error:nil];
    BOOL isfolder=false;
    for (NSString* fileName in tempArray)
    {
        //NSLog(@"fileName=%@",fileName);
        NSString* full_filename=[my_path stringByAppendingPathComponent:fileName];
        if ([fileMgr fileExistsAtPath:full_filename isDirectory:&isfolder]) {
            if (isfolder==true) {
                //NSLog(@"pathname=%@",fileName);
                foler_item* cur_item=[foler_item new];
                cur_item.m_absolute_name=fileName;
                cur_item.m_full_name=full_filename;
                [m_folder_array addObject:cur_item];
            }
        }
       
    }
}
-(void) viewWillAppear:(BOOL)animated
{
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
}
-(void)load_folder_imgs:(NSString*)fold_path
{
    if (fold_path==nil) {
        return;
    }
    [m_file_array removeAllObjects];
    //[m_localCaptions removeAllObjects];
    //[m_localImages removeAllObjects];
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    //NSLog(@"load_folder_imgs, fold_path=%@",fold_path);
    //NSArray* tempArray = [fileMgr contentsOfDirectoryAtPath:fold_path error:nil];
    NSArray *tempArray = [fileMgr subpathsOfDirectoryAtPath: fold_path error:nil];
    //NSArray* tempArray = [fileMgr subpathsAtPath:fold_path];
    
    //(NSArray *)subpathsOfDirectoryAtPath:(NSString *)path error:(NSError **)error
    //(- (NSArray *)subpathsAtPath:(NSString *)path)
    //- (NSArray *)contentsOfDirectoryAtPath:(NSString *)path error:(NSError **)error
    //(- (NSArray *)directoryContentsAtPath:(NSString *)path)
    
    BOOL isfolder=false;
    for (NSString* fileName in tempArray)
    {
        //NSLog(@"load_folder_imgs, fileName=%@",fileName);
        
        NSString* full_filename=[fold_path stringByAppendingPathComponent:fileName];
        if ([fileMgr fileExistsAtPath:full_filename isDirectory:&isfolder]) {
            if (isfolder==false) {
                //NSLog(@"load_folder_imgs, fileName=%@",fileName);
                /*
                [m_localCaptions addObject:fileName];
                [m_localImages addObject:full_filename];
                 */
                foler_item* cur_item=[foler_item new];
                cur_item.m_absolute_name=fileName;
                cur_item.m_full_name=full_filename;
                [m_file_array addObject:cur_item];
            }
        }
        
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat) gridView:(UIGridView *)grid widthForColumnAt:(int)columnIndex
{
	return 320/3;
}

- (CGFloat) gridView:(UIGridView *)grid heightForRowAt:(int)rowIndex
{
     if (grid==_m_tableview)
         return 100;
     else
         return 80;
}

- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid
{
	return 3;
}


- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid
{
    if (grid==_m_tableview) {
        return [m_folder_array count];
    }
    else
        return [m_file_array count];
	
}
- (UIImage *)thumbnailWithImage:(UIImage *)image with_size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        UIGraphicsBeginImageContext(asize);
        [image drawInRect:CGRectMake(0, 0, asize.width, asize.height)];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
    
}
- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{
    if (grid==_m_tableview) {
        int pos=rowIndex*3+columnIndex;
        foler_item* cur_item= [m_folder_array objectAtIndex:pos];
        
        item_folder_cell *cell = (item_folder_cell *)[grid dequeueReusableCell];
        
        if (cell == nil) {
            cell = [[item_folder_cell alloc]init:320/3 with_heigth:100];
        }
        
        //cell.cell_title.text = [NSString stringWithFormat:@"(%d,%d)", rowIndex, columnIndex];
        cell.cell_title.text = cur_item.m_absolute_name;
        if (m_folder_cur_mode==0) {
            cell.cell_img_ok.hidden=true;
        }
        else if(m_folder_cur_mode==1){
            if (cur_item.b_selected==true) {
                cell.cell_img_ok.hidden=false;
            }
        }
        return cell;
    }
    else{
        int pos=rowIndex*3+columnIndex;
       
        foler_item* cur_item= [m_file_array objectAtIndex:pos];
        item_file_cell *cell = (item_file_cell *)[grid dequeueReusableCell];
        
        if (cell == nil) {
            cell = [[item_file_cell alloc]init:320/3 with_heigth:80];
        }
        
        //cell.cell_title.text = [NSString stringWithFormat:@"(%d,%d)", rowIndex, columnIndex];
        UIImage* src_img=[UIImage imageWithContentsOfFile:cur_item.m_full_name];
        UIImage* new_img=[self thumbnailWithImage:src_img with_size:CGSizeMake(80, 60)];
        src_img=nil;
        [cell.cell_img setImage:new_img];
        if (m_file_cur_mode==0) {
            cell.cell_img_ok.hidden=true;
        }
        else if(m_file_cur_mode==1){
            if (cur_item.b_selected==true) {
                cell.cell_img_ok.hidden=false;
            }
        }
        return cell;
    }
}

//- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)colIndex
- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)colIndex with_cell:(UIGridViewCell*)cell
{
	//NSLog(@"%d, %d clicked", rowIndex, colIndex);
    int pos=rowIndex*3+colIndex;
    if (grid==_m_tableview) {
        foler_item* cur_item=[m_folder_array objectAtIndex:pos];
        if (cur_item==nil) {
            return;
        }
        if (m_folder_cur_mode==0){
            [self load_folder_imgs:cur_item.m_full_name];
            if (m_file_array.count<=0) {
                return;
            }
            [m_file_tableview reloadData];
            [view_main bringSubviewToFront:view_file];
        }
        else if (m_folder_cur_mode==1){
            cur_item.b_selected=!cur_item.b_selected;
            item_folder_cell* my_cell=(item_folder_cell*)cell;
            if (cur_item.b_selected==true) {
                my_cell.cell_img_ok.hidden=false;
                [m_folder_delete_array addObject:cur_item];
            }
            else{
                my_cell.cell_img_ok.hidden=true;
                [m_folder_delete_array removeObject:cur_item];
            }
            if ([m_folder_delete_array count]<=0) {
                mode_folder_button_delete.enabled=NO;
                //[mode_folder_button_delete setEnabled:false];
            }
            else{
                mode_folder_button_delete.enabled=YES;
                //[mode_folder_button_delete setEnabled:true];
            }
           // NSString* title=[NSString stringWithFormat:@"%@(%d)",@"已选择",m_folder_delete_array.count];
            [mode_folder_label setText:[NSString stringWithFormat:@"%@(%d)",@"已选择",m_folder_delete_array.count]];
            
        }
    }
    else
    {
        if (m_file_cur_mode==0){
            m_localGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
            f_shared.nDefaultIndex=pos;
            [self.navigationController pushViewController:m_localGallery animated:YES];
        }
        else if (m_file_cur_mode==1){
            foler_item* cur_item=[m_file_array objectAtIndex:pos];
            if (cur_item==nil) {
                return;
            }
            cur_item.b_selected=!cur_item.b_selected;
            item_file_cell* my_cell=(item_file_cell*)cell;
            if (cur_item.b_selected==true) {
                my_cell.cell_img_ok.hidden=false;
                [m_file_delete_array addObject:cur_item];
            }
            else{
                my_cell.cell_img_ok.hidden=true;
                [m_file_delete_array removeObject:cur_item];
            }
            if ([m_file_delete_array count]<=0) {
                [mode_file_button_delete setEnabled:false];
            }
            else{
                [mode_file_button_delete setEnabled:true];
            }
            [mode_file_label setText:[NSString stringWithFormat:@"%@(%d)",@"已选择",m_file_delete_array.count]];
        }
    }
    
}
////////////////////////////
#pragma mark - FGalleryViewControllerDelegate Methods


- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    int num=[m_file_array count];
	return num;
}


- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
	return FGalleryPhotoSourceTypeLocal;
}


- (NSString*)photoGallery:(FGalleryViewController *)gallery captionForPhotoAtIndex:(NSUInteger)index
{
    foler_item* cur_item= [m_file_array objectAtIndex:index];
    NSString *caption= cur_item.m_absolute_name;
	return caption;
}


- (NSString*)photoGallery:(FGalleryViewController*)gallery filePathForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    //return [localImages objectAtIndex:index];
     foler_item* cur_item= [m_file_array objectAtIndex:index];
    return cur_item.m_full_name;
}



- (void)handleTrashButtonTouch:(id)sender {
    // here we could remove images from our local array storage and tell the gallery to remove that image
    // ex:
    //[localGallery removeImageAtIndex:[localGallery currentIndex]];
}


- (void)handleEditCaptionButtonTouch:(id)sender {
    // here we could implement some code to change the caption for a stored image
}
- (IBAction)mode_file_button_return_click:(id)sender {
    [view_main bringSubviewToFront:view_folder];
}

- (IBAction)mode_folder_button_return_click:(id)sender {
    [m_folder_array removeAllObjects];
    [m_file_array removeAllObjects];
    [[self navigationController] popViewControllerAnimated:YES];
    
    
}

- (IBAction)mode_folder_button_edit_click:(id)sender {
    for (foler_item* item in m_folder_array)
    {
        item.b_selected=false;
    }
    [m_folder_delete_array removeAllObjects];
    if (m_folder_cur_mode==0) {
        
        m_folder_cur_mode=1;
        mode_folder_button_delete.hidden=false;
        mode_folder_button_delete.enabled=NO;
        [mode_folder_button_edit setTitle:MYLocalizedString(@"m_cancel", @"") forState:UIControlStateNormal];
        [mode_folder_label setText:MYLocalizedString(@"m_select_folder", @"")];
    }
    else{
        m_folder_cur_mode=0;
        mode_folder_button_delete.hidden=true;
        [mode_folder_button_edit setTitle:MYLocalizedString(@"m_edit", @"") forState:UIControlStateNormal];
        [mode_folder_label setText:MYLocalizedString(@"m_view_folder", @"")];
        [_m_tableview reloadData];
    }
}
- (IBAction)mode_folder_button_delete:(id)sender {
    for (foler_item* item in m_folder_delete_array)
    {
        if (item.b_selected==true) {
            NSString* curpath=item.m_full_name;
            [m_file_manager delete_folder:curpath];
        }
        
    }
    [m_folder_array removeObjectsInArray:m_folder_delete_array];
    m_folder_cur_mode=0;
    mode_folder_button_delete.hidden=true;
    [mode_folder_button_edit setTitle:MYLocalizedString(@"m_edit", @"") forState:UIControlStateNormal];
    [_m_tableview reloadData];
}
- (IBAction)mode_file_button_edit_click:(id)sender {
    for (foler_item* item in m_file_array)
    {
        item.b_selected=false;
    }
    [m_file_delete_array removeAllObjects];
    if (m_file_cur_mode==0) {
        
        m_file_cur_mode=1;
        mode_file_button_delete.hidden=false;
        mode_file_button_delete.enabled=false;
        [mode_file_button_edit setTitle:MYLocalizedString(@"m_cancel", @"") forState:UIControlStateNormal];
        [mode_file_label setText:MYLocalizedString(@"m_select_picture", @"")];
    }
    else{
        m_file_cur_mode=0;
        mode_file_button_delete.hidden=true;
        [mode_file_button_edit setTitle:MYLocalizedString(@"m_edit", @"") forState:UIControlStateNormal];
        [m_file_tableview reloadData];
        [mode_file_label setText:MYLocalizedString(@"m_view_picture", @"")];
    }
}

- (IBAction)mode_file_button_delete_click:(id)sender {
    for (foler_item* item in m_file_delete_array)
    {
        if (item.b_selected==true) {
            NSString* curpath=item.m_full_name;
            [m_file_manager delete_folder:curpath];
        }
        
    }
    [m_file_array removeObjectsInArray:m_file_delete_array];
    m_file_cur_mode=0;
    mode_file_button_delete.hidden=true;
    [mode_file_button_edit setTitle:MYLocalizedString(@"m_edit", @"") forState:UIControlStateNormal];
    [m_file_tableview reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation==UIInterfaceOrientationPortrait || interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown);
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait);
}
@end
