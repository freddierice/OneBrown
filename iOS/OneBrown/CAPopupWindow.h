//
//  CAPopupWindow.h
//  CAPopupWindowExample
//
//  Created by Benjamin Murphy on 6/13/13.
//  Copyright (c) 2013 Benjamin Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAWindowObject : NSObject

@property (readwrite, nonatomic, strong) UIImage *image;
@property (readwrite, nonatomic, strong) NSString *text;
@property (readwrite, nonatomic, weak) id target;
@property (readwrite, nonatomic) SEL action;

+ (instancetype) windowObject:(NSString *) text image:(UIImage *) image target:(id)target action:(SEL) action;

@end

@interface CACell : UICollectionViewCell {
    UILabel* text;
    UIImageView* image;
}

@property (nonatomic, retain) UILabel* text;
@property (nonatomic, retain) UIImageView* image;

@end

@interface CAPopupWindow : UIView <UICollectionViewDataSource, UICollectionViewDelegate> {
    NSArray* objects;
    CGFloat objectCount;
    UIView* secondView;
}
@property (nonatomic, retain) UIView* secondView;
@property (nonatomic, assign) CGFloat objectCount;
@property (nonatomic, retain) NSArray* objects;

- (id)initWithObjectList: (NSArray*)list;

- (void)presentInView: (UIView*)view;
- (void)dismissFromView;

@end
