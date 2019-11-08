//
//  MyPaymentTransactionObserver.m
//  iosCodeUI
//
//  Created by mac on 2019/11/8.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "MyPaymentTransactionObserver.h"

@implementation MyPaymentTransactionObserver

#pragma mark - SKPaymentTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(nonnull NSArray<SKPaymentTransaction *> *)transactions{
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            // Call the appropriate custom method for the transaction state.
            case SKPaymentTransactionStatePurchasing:
                //[self showTransactionAsInProgress:transaction deferred:NO];
                break;
            case SKPaymentTransactionStateDeferred:
                //[self showTransactionAsInProgress:transaction deferred:YES];
                break;
            case SKPaymentTransactionStateFailed:
                //[self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchased:
                //[self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                //[self restoreTransaction:transaction];
                break;
            default:
                // For debugging
                NSLog(@"Unexpected transaction state %@", @(transaction.transactionState));
                break;
        }
    }
}

@end
