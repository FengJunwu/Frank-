//
//  DrawerViewController.h
//  Frank
//
//  Created by fengjunwu on 2019/6/1.
//  Copyright © 2019 819134700@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DrawerViewController : UIViewController

@property (nonatomic,strong)CBPeripheral *peripheral;
@property (nonatomic,strong)CBCharacteristic *writeCharacteristics;
@property (nonatomic,strong)CBCharacteristic *readCharacteristics;

@end

NS_ASSUME_NONNULL_END
