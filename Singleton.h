//
//  Singleton.h
//  TabBarTest
//
//  Created by Shebin Koshy on 11/18/16.
//  Copyright © 2016 Shebin Koshy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ActionSheetDelegate <NSObject>

/**
 @param actionSheetTag tag of an alert
 @param buttonIndex , index of the pressed button. NOTE : for cancel button it will be zero
 @param buttonTitle , title of the pressed button
 */
-(void)actionSheetWithTag:(NSInteger)actionSheetTag buttonActionWithButtonIndex:(NSInteger)buttonIndex withButtonTitle:(nonnull NSString*)buttonTitle;

@end

@protocol AlertDelegate <NSObject>
/**
@param alertTag tag of an alert
@param buttonIndex , index of the pressed button. NOTE : for cancel button it will be zero
@param buttonTitle , title of the pressed button
 */
-(void)alertWithTag:(NSInteger)alertTag buttonActionWithButtonIndex:(NSInteger)buttonIndex withButtonTitle:(nonnull NSString*)buttonTitle;

@end

@interface Singleton : NSObject

+(nonnull instancetype)sharedInstance;

-(void)showAlertWithTag:(NSInteger)tag title:(nullable NSString *)title message:(nullable NSString *)message arrayOfOtherButtonTitles:(nullable NSArray*)arrayButtonTitles cancelButtonTitle:(nonnull NSString*)cancelButtonTitle presentInViewController:(nonnull UIViewController*)viewController delegate:(nullable id)alertDelegate;

-(void)showActionSheetWithTag:(NSInteger)tag title:(nullable NSString *)title arrayOfOtherButtonTitles:(nonnull NSArray*)arrayButtonTitles cancelButtonTitle:(nullable NSString*)cancelButtonTitle presentInViewController:(nonnull UIViewController*)viewController delegate:(nullable id)alertDelegate;

@end
