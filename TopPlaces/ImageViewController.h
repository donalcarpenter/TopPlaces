//
//  ImageViewController.h
//  TopPlaces
//
//  Created by Carpenter, Donal [ICG-IT] on 3/18/13.
//  Copyright (c) 2013 Donal Carpenter. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ImageViewControllerDataSource <NSObject>

-(UIImage*) imageToDisplay;
-(NSString*) imageTitle;

@end

@interface ImageViewController : UIViewController <UIScrollViewDelegate>

@property id<ImageViewControllerDataSource> dataSource;

@property (weak, nonatomic) IBOutlet UIImageView *uiImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
