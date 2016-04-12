//
//  Utils.h
//  Universal
//
//  Created by Vladimir Yevdokimov on 5/15/15.
//  Copyright (c) 2015 magnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (void)updateUIForNavBar:(UINavigationBar*)navBar withImage:(UIImage*)bgImage; //frequent UI customization

// Image
+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size;
+ (void)roundImage:(UIImage *)image forImageView:(UIImageView *)imageView;
+ (void)loadImageUrl:(NSString*)imageUrl toImageView:(UIImageView*)imageView;
+ (NSString *)stringBase64FromImage:(UIImage *)image;
+ (UIImage *)imageFromBase64String:(NSString *)base64String

// Date
+ (NSString*)stringFromDate:(NSDate*)date format:(NSString*)format;
+ (NSDate*)dateFromString:(NSString*)dateString format:(NSString*)format;
+ (NSString*)calculateTimeAgoForDate:(NSDate*)date;

// Storyboard
+ (void)initiateStoryboard:(NSString *)storyboard;
+ (id)initialController:(NSString *)storyboard;
+ (id)controllerFrom:(NSString *)storyboard withID:(NSString *)controllerId;

@end
