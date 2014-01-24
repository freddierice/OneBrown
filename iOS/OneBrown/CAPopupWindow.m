//
//  CAPopupWindow.m
//  CAPopupWindowExample
//
//  Created by Benjamin Murphy on 6/13/13.
//  Copyright (c) 2013 Benjamin Murphy. All rights reserved.
//

#import "CAPopupWindow.h"
#import <QuartzCore/QuartzCore.h>

@interface CAPopupWindow ()

@end

@implementation CACell

@synthesize image;
@synthesize text;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        //self.layer.borderColor = [UIColor whiteColor].CGColor;
        //self.layer.cornerRadius = 4.0f;
        //self.layer.borderWidth = 1.0f;
        
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 62, 88, 20)];
        [self.contentView addSubview:label];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:[UIFont systemFontOfSize:18]];
        self.text = label;
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 4, 88, 58)];
        [imageView setContentMode: UIViewContentModeScaleAspectFit];
        [self.contentView addSubview:imageView];
        self.image = imageView;
    }
    return self;
}

@end

@implementation CAWindowObject

+ (instancetype) windowObject:(NSString *) text image:(UIImage *) image target:(id)target action:(SEL) action {
    return [[CAWindowObject alloc] init:text image:image target:target action:action];
}

- (id) init:(NSString *) text image:(UIImage *) image target:(id)target action:(SEL) action {
    NSParameterAssert(text.length || image);
    
    self = [super init];
    if (self) {
        
        _text = text;
        _image = image;
        _target = target;
        _action = action;
    }
    return self;
}

- (void) performAction
{
    __strong id target = self.target;
    
    if (target && [target respondsToSelector:_action]) {
        
        [target performSelectorOnMainThread:_action withObject:self waitUntilDone:YES];
    }
}

@end

@implementation CAPopupWindow

@synthesize objects;
@synthesize objectCount;
@synthesize secondView;

- (id)initWithObjectList: (NSArray*)list {
    if (self = [super init]) {
                
        CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
        if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
            screenFrame.size = CGSizeMake(screenFrame.size.height, screenFrame.size.width);
        }
        
        self.objectCount = list.count;
        self.objects = list;
        
        if (self.objectCount > 12) {
            @throw [NSException exceptionWithName:@"CAObjectException" reason:@"CAPopupWindow can handle at most 12 menu options" userInfo:nil];
        }
        else if (objectCount < 1) {
            @throw [NSException exceptionWithName:@"CAObjectException" reason:@"CAPopupWindow must have at least one object" userInfo:nil];
        }
        
        CGSize dimensions;
        
        if (self.objectCount < 4) {
            dimensions = CGSizeMake(self.objectCount, 1);
        }
        else if (self.objectCount < 7) {
            dimensions = CGSizeMake(ceilf(self.objectCount/2.0f), 2);
        }
        else {
            dimensions = CGSizeMake(ceilf(self.objectCount/4.0f), 4);
            if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
                dimensions = CGSizeMake(dimensions.height, dimensions.width);
            }
        }
        
        
        
        NSInteger windowWidth = dimensions.width * 98 + 10;
        NSInteger windowHeight = dimensions.height * 98 + 10;
        
        CGRect frame = CGRectMake((screenFrame.size.width-windowWidth)/2, (screenFrame.size.height-windowHeight)/2, windowWidth, windowHeight);
    
        [self setFrame:frame];
        [self setBackgroundColor:[UIColor blackColor]];
        self.layer.opacity = 0.8f;
        self.layer.cornerRadius = 10.0f;
                
        UICollectionViewFlowLayout *aFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        [aFlowLayout setItemSize:CGSizeMake(88, 88)];
        [aFlowLayout setMinimumInteritemSpacing:10.0f];
        [aFlowLayout setMinimumLineSpacing:10.0f];
        [aFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        UICollectionView* collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 10, frame.size.width-20, frame.size.height-20) collectionViewLayout:aFlowLayout];
    
        [collectionView registerClass:[CACell class] forCellWithReuseIdentifier:@"ObjectCell"];

        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;

        [self addSubview:collectionView];
    }
    return self;
}

- (void)presentInView:(UIView *)view {
    
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        screenFrame.size = CGSizeMake(screenFrame.size.height, screenFrame.size.width);
    }
    
    UIView* opacityLayer = [[UIView alloc] initWithFrame:screenFrame];
    opacityLayer.backgroundColor = [UIColor blackColor];
    opacityLayer.layer.opacity = 0.4f;
    self.secondView = opacityLayer;

    UITapGestureRecognizer* dismissRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissFromView)];
    dismissRecognizer.numberOfTapsRequired = 1;
    dismissRecognizer.numberOfTouchesRequired = 1;
    [self.secondView addGestureRecognizer:dismissRecognizer];
    
    [view addSubview:opacityLayer];
    [view addSubview:self];
    self.alpha = 0.0f;
    opacityLayer.alpha = 0.0f;
    
    [UIView animateWithDuration:0.2
                     animations:^(void) {
                         
                         self.alpha = 1.0f;
                         opacityLayer.alpha = 0.4f;
                         
                     } completion:NULL];
    
}

- (void)dismissFromView {
    [UIView animateWithDuration:0.2
                     animations:^(void) {
                         
                         self.alpha = 0.0f;
                         self.secondView.alpha = 0.0f;
                         
                     } completion:^(BOOL completed){
                         [self.secondView removeFromSuperview];
                         [self removeFromSuperview];
                     }];
}

#pragma mark - UICollectionView Delegate and DataSource

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView cellForItemAtIndexPath:indexPath].contentView.layer.opacity = 0.5f;
    
    CAWindowObject* object = (CAWindowObject*)[self.objects objectAtIndex:indexPath.item];
    
    [object.target performSelectorOnMainThread:object.action withObject:self waitUntilDone:YES];
    
    [self dismissFromView];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView cellForItemAtIndexPath:indexPath].contentView.layer.opacity = 1.0f;

}

- (UIEdgeInsets)collectionView: (UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CACell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ObjectCell" forIndexPath:indexPath];
        
    [cell.text setText: [(CAWindowObject*)[self.objects objectAtIndex:indexPath.item] text]];
    [cell.image setImage: [(CAWindowObject*)[self.objects objectAtIndex:indexPath.item] image]];

    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.objectCount;
}

@end
