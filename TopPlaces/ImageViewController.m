//
//  ImageViewController.m
//  TopPlaces
//
//  Created by Carpenter, Donal [ICG-IT] on 3/18/13.
//  Copyright (c) 2013 Donal Carpenter. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@property (nonatomic, readonly) UIActivityIndicatorView *spinner;

@end

@implementation ImageViewController
            
@synthesize dataSource = _dataSource;
@synthesize uiImageView = _uiImageView;
@synthesize scrollView = _scrollView;
@synthesize titleLabel = _titleLabel;
@synthesize spinner = _spinner;


-(UIActivityIndicatorView*) spinner{
    if(!_spinner){
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_spinner];
    }
    
    return _spinner;
}

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

-(void) reloadImage{
    dispatch_queue_t imagedownloadQueue = dispatch_queue_create("imagedownloadQueue", NULL);
    
    [self.spinner startAnimating];
    
    self.navigationItem.title = [self.dataSource imageTitle];
    
    dispatch_async(imagedownloadQueue, ^{
        
        UIImage *image = [self.dataSource imageToDisplay];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.spinner stopAnimating];
            
            self.uiImageView.image = image;
            self.uiImageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
            self.scrollView.contentSize = self.uiImageView.image.size;
            
            [self.scrollView setNeedsLayout];
            [self.scrollView setNeedsDisplay];
            
            NSLog(@"widths: scrollView = %g, content = %g", self.scrollView.frame.size.width, self.scrollView.contentSize.width);
            
            NSLog(@"heights: scrollView = %g, content = %g", self.scrollView.frame.size.height, self.scrollView.contentSize.height);
        });
        
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.delegate = self;
    
    [self reloadImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.uiImageView.image = nil;
}

@end
