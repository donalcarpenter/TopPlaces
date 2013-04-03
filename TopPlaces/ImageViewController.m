//
//  ImageViewController.m
//  TopPlaces
//
//  Created by Carpenter, Donal [ICG-IT] on 3/18/13.
//  Copyright (c) 2013 Donal Carpenter. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

@synthesize dataSource = _dataSource;
@synthesize uiImageView = _uiImageView;
@synthesize scrollView = _scrollView;
@synthesize titleLabel = _titleLabel;

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.uiImageView;
}

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
    
    self.scrollView.delegate = self;
    
    UIImage *image = [self.dataSource imageToDisplay];
    
    self.navigationItem.title = [self.dataSource imageTitle];
    
    self.uiImageView.image = image;
    self.uiImageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    self.scrollView.contentSize = self.uiImageView.image.size;
    
    NSLog(@"widths: scrollView = %g, content = %g", self.scrollView.frame.size.width, self.scrollView.contentSize.width);

    NSLog(@"heights: scrollView = %g, content = %g", self.scrollView.frame.size.height, self.scrollView.contentSize.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.uiImageView.image = nil;
}

@end
