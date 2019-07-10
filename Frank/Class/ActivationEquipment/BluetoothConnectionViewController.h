//
//  BluetoothConnectionViewController.h
//  Frank
//
//  Created by fengjunwu on 2019/6/1.
//  Copyright © 2019 819134700@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BluetoothDelegate <NSObject>

-(void)changeCBPeripheral:(CBPeripheral *)peripheral CBCharacteristic:(CBCharacteristic *)writeCharacteristics CBCharacteristic:(CBCharacteristic *)readCharacteristics;

@end

@interface BluetoothConnectionViewController : UIViewController

@property (nonatomic,weak) id<BluetoothDelegate>delegate;

@property (nonatomic,strong)CBPeripheral *peripheral;
@property (nonatomic,strong)CBCharacteristic *writeCharacteristics;
@property (nonatomic,strong)CBCharacteristic *readCharacteristics;

@end

NS_ASSUME_NONNULL_END
