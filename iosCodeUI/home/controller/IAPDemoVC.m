//
//  IAPDemoVC.m
//  iosCodeUI
//
//  Created by mac on 2019/11/7.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "IAPDemoVC.h"
#import <StoreKit/StoreKit.h>

@interface IAPDemoVC () <SKProductsRequestDelegate>

@property (nonatomic,strong) SKProductsRequest *productsRequest;
@property (nonatomic,strong) NSArray<SKProduct *> *products;
@property (nonatomic,strong) UIButton *paymentBtn;

@end

@implementation IAPDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self verifyPruchaseReceipt];
    
    _paymentBtn=[UIButton new];
    _paymentBtn.backgroundColor=[UIColor darkGrayColor];
    _paymentBtn.frame=CGRectMake(30, 330, 300, 45);
    [_paymentBtn.layer setCornerRadius:10.0];
    [_paymentBtn addTarget:self action:@selector(paymentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_paymentBtn];
    
    NSMutableArray *productIdentifiers = [[NSMutableArray alloc]init];
    [productIdentifiers addObject:@"com.ltxtiyu.test1"];
    //[productIdentifiers addObject:@"com.ltxtiyu.bean12"];
    [self validateProductIdentifiers:productIdentifiers];
}

- (void)validateProductIdentifiers:(NSArray *)productIdentifiers{
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc]initWithProductIdentifiers:[NSSet setWithArray:productIdentifiers]];

    // Keep a strong reference to the request.
    self.productsRequest = productsRequest;
    productsRequest.delegate = self;
    [productsRequest start];
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    self.products = response.products;

    for (NSString *invalidIdentifier in response.invalidProductIdentifiers) {
        NSLog(@"%@",invalidIdentifier);
    }
    
    for (SKProduct * skProduct in self.products){
        NSLog(@"localizedDescription:%@",skProduct.localizedDescription);
        NSLog(@"localizedTitle:%@",skProduct.localizedTitle);
        NSLog(@"contentVersion:%@",skProduct.contentVersion);
        NSLog(@"price:%@",skProduct.price);
        NSLog(@"priceLocale:%@",skProduct.priceLocale);
        if (@available(iOS 11.2, *)) {
            NSLog(@"introductoryPrice:%@",skProduct.introductoryPrice);
        }
        if (@available(iOS 12.2, *)) {
            NSLog(@"discounts:%@",skProduct.discounts);
        }
    }
    
    [self displayStoreUI];
}

#pragma mark - StoreUI
-(void)displayStoreUI{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.paymentBtn setTitle:[self.products firstObject].localizedTitle forState:UIControlStateNormal];
    });
}

-(void)paymentBtnClick{
    //Create a Payment Request
    SKProduct * product=[self.products firstObject];
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
    payment.quantity = 1;
    //Submit a Payment Request
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}
                   
-(void)verifyPruchaseReceipt{
    /* Load the receipt from the app bundle. */
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];

    if (!receipt) {
        NSLog(@"no receipt");
        /* No local receipt -- handle the error. */
    } else {
        /* Get the receipt in encoded format */
        NSString *encodedReceipt = [receipt base64EncodedStringWithOptions:0];
    }
}

@end
