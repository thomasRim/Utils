//
//  Utils.h
//  Universal
//
//  Created by Vladimir Yevdokimov on 5/15/15.
//  Copyright (c) 2015 magnet. All rights reserved.
//

#import "Utils.h"

static const float K_IMAGE_QUALITY = 0.3f;

@implementation Utils

+ (void)updateUIForNavBar:(UINavigationBar*)navBar withImage:(UIImage*)bgImage
{
    UIImage *bg = [Utils resizeImage:bgImage toSize:CGSizeMake(navBar.bounds.size.width, navBar.bounds.size.height+20)];
    [navBar setBackgroundImage:bg forBarMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[Utils resizeImage:bgImage toSize:CGSizeMake(navBar.bounds.size.width, 1)]];
}

#pragma mark - Image

+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (void)loadImageUrl:(NSString*)imageUrl toImageView:(UIImageView*)imageView
{
    if (!imageUrl || !imageUrl.length || !imageView) {
        return;
    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//        imageView.image = nil;
//    });

    NSString *imageName = imageUrl.lastPathComponent;

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *filePath = [paths[0] stringByAppendingPathComponent:imageName];

    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]
        && ([NSData dataWithContentsOfFile:filePath].length > 0)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = [UIImage imageWithContentsOfFile:filePath];
        });
    } else {
        UIActivityIndicatorView __block *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.hidesWhenStopped = YES;
        spinner.color = [UIColor lightGrayColor];
        [imageView addSubview:spinner];
        spinner.center = CGPointMake(imageView.bounds.size.width/2,
                                     imageView.bounds.size.height/2);
        [spinner startAnimating];

        // load URL request
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];

        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            //remove spinner
            [spinner removeFromSuperview];
            // apply received data
            if (!connectionError && ((NSHTTPURLResponse*)response).statusCode == 200) {
                [data writeToFile:filePath atomically:YES];
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.image = [UIImage imageWithContentsOfFile:filePath];
                });
            }
        }];
    }
}

+ (NSString *)stringBase64FromImage:(UIImage *)image {
    return [UIImageJPEGRepresentation(image, K_IMAGE_QUALITY)
            base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

+ (UIImage *)imageFromBase64String:(NSString *)base64String {
    NSData *data = [[NSData alloc]
                    initWithBase64EncodedString:base64String
                    options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

#pragma mark - Date

+ (NSString*)stringFromDate:(NSDate*)date format:(NSString*)format
{
    NSString *dateString = nil;

    if (date) {
        NSDateFormatter *dateformatter = [NSDateFormatter new];
        dateformatter.dateFormat = format;
        dateString = [dateformatter stringFromDate:date];
    }

    return dateString;
}

+ (NSDate*)dateFromString:(NSString*)dateString format:(NSString*)format
{
    NSDate *date = nil;

    if (dateString) {
        NSDateFormatter *dateformatter = [NSDateFormatter new];
        dateformatter.dateFormat = format;
        date = [dateformatter dateFromString:dateString];
    }

    return date;
}

(NSString*)calculateTimeAgoForDate:(NSDate*)date
{
    NSString *timeAgo = @"";

    long long actualDate = @([NSDate date].timeIntervalSince1970).longLongValue;
    long long estimateDate = @(date.timeIntervalSince1970).longLongValue;

    long long leftSecs = actualDate - estimateDate;

    if (leftSecs <= 0) {
        timeAgo = [Utils stringFromDate:date format:@"MMMM dd"];
    } else {

        long long days = leftSecs/(60*60*24);

        if (days > 7) {
            timeAgo = [Utils stringFromDate:date format:@"MMMM dd"];
        } else if (days>=1) {
            timeAgo = [NSString stringWithFormat:@"%@ day%@ ago",@(days),days==1?@"":@"s"];
        } else {
            long long hours = leftSecs/(60*60);
            if (hours>=1) {
                timeAgo = [NSString stringWithFormat:@"%@ hour%@ ago",@(hours),(hours==1)?@"":@"s"];
            } else {
                long long minutes = leftSecs/(60);
                if (minutes>=1) {
                    timeAgo = [NSString stringWithFormat:@"%@ minute%@ ago",@(minutes),(minutes==1)?@"":@"s"];
                } else {
                    timeAgo = [NSString stringWithFormat:@"%@ second%@ ago",@(leftSecs),(leftSecs==1)?@"":@"s"];
                }
            }
        }
    }
    return timeAgo;
}

#pragma mark - Storyboard

+ (void)initiateStoryboard:(NSString *)storyboard {
    UIViewController *controller = [UIViewController new];

    UIStoryboard *sb = [UIStoryboard storyboardWithName:storyboard bundle:nil];
    if (sb) {
        controller = [sb instantiateInitialViewController];
        UIWindow *win = [UIApplication sharedApplication].windows[0];
        win.rootViewController = controller;
        [win makeKeyAndVisible];
    }
}

+ (id)initialController:(NSString *)storyboard {
    id controller = nil; //[UIViewController new];

    UIStoryboard *sb = [UIStoryboard storyboardWithName:storyboard bundle:nil];
    if (sb) {
        controller = [sb instantiateInitialViewController];
    }
    return controller;
}

+ (id)controllerFrom:(NSString *)storyboard withID:(NSString *)controllerId {
    id controller = nil; //[UIViewController new];

    UIStoryboard *sb = [UIStoryboard storyboardWithName:storyboard bundle:nil];
    if (sb) {
        id vc = [sb instantiateViewControllerWithIdentifier:controllerId];
        if (vc) {
            controller = vc;
        }
    }
    return controller;
}

@end

