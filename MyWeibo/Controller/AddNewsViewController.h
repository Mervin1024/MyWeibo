//
//  AddNewsViewController.h
//  MyWeibo
//
//  Created by 马遥 on 15/7/22.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddingImageView.h"
#import "AddingTextView.h"
typedef enum {
    AddNewsTypeNone = 0,
    AddNewsTypeOfText,
    AddNEwsTypeOfImage,
    AddNewsTypeOfPhoto
}AddNewsType;

@interface AddNewsViewController : UIViewController<AddingImageViewDelegate,AddingTextViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *publishBarButton;
@property (strong, nonatomic) AddingTextView *textView;
@property (assign, nonatomic) AddNewsType addNewsType;
- (IBAction)cancel:(id)sender;
- (IBAction)publish:(id)sender;
@end
