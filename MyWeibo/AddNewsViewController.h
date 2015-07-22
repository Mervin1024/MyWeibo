//
//  AddNewsViewController.h
//  MyWeibo
//
//  Created by 马遥 on 15/7/22.
//  Copyright (c) 2015年 NJUPT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewsModel;
@class AddNewsViewController;
typedef enum {
    AddNewsTypeNone,
    AddNewsTypeOfText,
    AddNEwsTypeOfImage,
    AddNewsTypeOfPhoto
}AddNewsType;

@protocol AddNewsViewControllerDelegate <NSObject>

//- (void)AddNewsViewControllerDidCancel:(AddNewsViewController *)controller;
- (void)AddNewsViewController:(AddNewsViewController *)controller DidFinishPublish:(NewsModel *)news;

@end


@interface AddNewsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (assign, nonatomic) AddNewsType addNewsType;
@property (weak, nonatomic) id<AddNewsViewControllerDelegate> delegate;
- (IBAction)cancel:(id)sender;
- (IBAction)publish:(id)sender;
@end
