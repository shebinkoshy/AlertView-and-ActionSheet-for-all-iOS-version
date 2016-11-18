//
//  Singleton.m
//  TabBarTest
//
//  Created by Shebin Koshy on 11/18/16.
//  Copyright © 2016 Shebin Koshy. All rights reserved.
//

#import "Singleton.h"


@interface Singleton ()<UIAlertViewDelegate,UIActionSheetDelegate>

@property(nonatomic,strong) NSMutableArray *arrayAlertDelegates, *arrayActionSheetDelegates;

@end

@implementation Singleton

+(instancetype)sharedInstance
{
    static Singleton *singletonObj;
    static dispatch_once_t token;
    _dispatch_once(&token, ^{
        singletonObj = [[Singleton alloc]init];
        singletonObj.arrayAlertDelegates = [[NSMutableArray alloc]init];
        singletonObj.arrayActionSheetDelegates = [[NSMutableArray alloc]init];
    });
    return singletonObj;
}

#pragma mark - Alert View

-(void)addAlertDelegatesToArray:(id)alertDelegate
{
    if (alertDelegate)
    {
        [_arrayAlertDelegates addObject:alertDelegate];
    }
    else
    {
        [_arrayAlertDelegates addObject:[NSNull null]];
    }
}

-(void)showAlertWithTag:(NSInteger)tag title:(NSString *)title message:(NSString *)message arrayOfOtherButtonTitles:(NSArray*)arrayButtonTitles cancelButtonTitle:(NSString*)cancelButtonTitle presentInViewController:(UIViewController*)viewController delegate:(id)alertDelegate
{
    if ([UIAlertController class])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        for (NSString *buttonTitles in arrayButtonTitles)
        {
            UIAlertAction *action = [UIAlertAction actionWithTitle:buttonTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self alertButtonActionsWithTag:tag buttonIndex:[arrayButtonTitles indexOfObject:action.title]+1 withButtonTitle:action.title alertDelegate:alertDelegate];
            }];
            [alert addAction:action];
        }
        if (cancelButtonTitle)
        {
            UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self alertButtonActionsWithTag:tag buttonIndex:0 withButtonTitle:action.title alertDelegate:alertDelegate];
            }];
            [alert addAction:actionCancel];
        }
        [viewController presentViewController:alert animated:YES completion:^{
            [self addAlertDelegatesToArray:alertDelegate];
        }];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        for (NSString *stringButtonTitle in arrayButtonTitles)
        {
            [alert addButtonWithTitle:stringButtonTitle];
        }
        
        if (cancelButtonTitle)
        {
            alert.cancelButtonIndex = [alert addButtonWithTitle:cancelButtonTitle];
        }
        
        alert.tag = tag;
        [alert show];
        [self addAlertDelegatesToArray:alertDelegate];
    }
}


-(void)alertButtonActionsWithTag:(NSInteger)tag buttonIndex:(NSInteger)buttonIndex withButtonTitle:(NSString*)buttonTitle alertDelegate:(id<AlertDelegate>)alertDelegate
{
    if (alertDelegate && [alertDelegate isKindOfClass:[NSNull class]] == NO)
    {
        [alertDelegate alertWithTag:tag buttonActionWithButtonIndex:buttonIndex withButtonTitle:buttonTitle];
    }
    [_arrayAlertDelegates removeLastObject];
}


#pragma mark - UIAlertView delegate (iOS 7.0)

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger buttonIndexToPass = buttonIndex;
    if (alertView.cancelButtonIndex == buttonIndex && alertView.cancelButtonIndex != 0)
    {
        /**
         cancel button
         */
        buttonIndexToPass = 0;
    }
    if (alertView.cancelButtonIndex != buttonIndex && alertView.cancelButtonIndex != 0)
    {
        /**
         other buttons
         */
        buttonIndexToPass++;
    }

    [self alertButtonActionsWithTag:alertView.tag buttonIndex:buttonIndexToPass withButtonTitle:[alertView buttonTitleAtIndex:buttonIndex] alertDelegate:[_arrayAlertDelegates lastObject]];
}


#pragma mark - Action sheet

-(void)addActionSheetDelegatesToArray:(id)actionSheetDelegate
{
    if (actionSheetDelegate)
    {
        [_arrayActionSheetDelegates addObject:actionSheetDelegate];
    }
    else
    {
        [_arrayActionSheetDelegates addObject:[NSNull null]];
    }
}

-(void)showActionSheetWithTag:(NSInteger)tag title:(NSString *)title arrayOfOtherButtonTitles:(NSArray*)arrayButtonTitles cancelButtonTitle:(NSString*)cancelButtonTitle presentInViewController:(UIViewController*)viewController delegate:(id)actionSheetDelegate
{
    if ([UIAlertController class])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        for (NSString *buttonTitles in arrayButtonTitles)
        {
            UIAlertAction *action = [UIAlertAction actionWithTitle:buttonTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self actionButtonActionsWithTag:tag buttonIndex:[arrayButtonTitles indexOfObject:action.title]+1 withButtonTitle:action.title actionSheetDelegate:actionSheetDelegate];
            }];
            [alertController addAction:action];
        }
        if (cancelButtonTitle)
        {
            UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self actionButtonActionsWithTag:tag buttonIndex:0 withButtonTitle:action.title actionSheetDelegate:actionSheetDelegate];
            }];
            [alertController addAction:actionCancel];
        }
        [viewController presentViewController:alertController animated:YES completion:^{
            [self addActionSheetDelegatesToArray:actionSheetDelegate];
        }];
        
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:nil];
        
        for (NSString *title in arrayButtonTitles)
        {
            [actionSheet addButtonWithTitle:title];
        }
        
        if (cancelButtonTitle)
        {
            actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:cancelButtonTitle];
        }
        actionSheet.tag = tag;
        [actionSheet showInView:viewController.view];
        [self addActionSheetDelegatesToArray:actionSheetDelegate];
    }
}


-(void)actionButtonActionsWithTag:(NSInteger)tag buttonIndex:(NSInteger)buttonIndex withButtonTitle:(NSString*)buttonTitle actionSheetDelegate:(id<ActionSheetDelegate>)actionSheetDelegate
{
    if (actionSheetDelegate && [actionSheetDelegate isKindOfClass:[NSNull class]] == NO)
    {
        [actionSheetDelegate actionSheetWithTag:tag buttonActionWithButtonIndex:buttonIndex withButtonTitle:buttonTitle];
    }
    [_arrayActionSheetDelegates removeLastObject];
}

#pragma mark - UIActionSheet delegate (iOS 7.0)

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger buttonIndexToPass = buttonIndex;
    if (actionSheet.cancelButtonIndex == buttonIndex && actionSheet.cancelButtonIndex != 0)
    {
        /**
         cancel button
         */
        buttonIndexToPass = 0;
    }
    if (actionSheet.cancelButtonIndex != buttonIndex && actionSheet.cancelButtonIndex != 0)
    {
        /**
         other buttons
         */
        buttonIndexToPass++;
    }
    [self actionButtonActionsWithTag:actionSheet.tag buttonIndex:buttonIndexToPass withButtonTitle:[actionSheet buttonTitleAtIndex:buttonIndex] actionSheetDelegate:[_arrayActionSheetDelegates lastObject]];
}


@end
