//
//  DeviceTool.h
//  QXTest
//
//  Created by  on 2023/2/15.
//

// need：SystemServices， need pod add：pod 'SystemServices'

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceTool : NSObject

/**
 * Mobile phone data
 * You need to enable the Access WiFi Information permission to obtain the currently connected WiFi information, otherwise it is nill
 * The uuid obtained here is idfv (key chain) as a unique identifier
 * An additional orderId field is required based on the current interface design
 */
+ (NSMutableDictionary *)getAllData;

/* *
* Address book data
* Call after checking address book authorization
* If no authorization is granted or the address book is empty, an empty array is returned
* Returns all contacts in the address book
*/
+ (NSMutableArray *)getContactBookData;
/**
 * Address book data, the public function is the same, the only difference is that you can specify the maximum number of contacts to obtain
 */
+ (NSArray *)getContactBookDataWithMaxCount:(NSInteger)maxCount;

+ (NSString*)getIDFA;

+ (NSString *)getApplicationVersion;
+ (NSString *)getDeviceType2;
+ (NSString *)getDeviceTypeFormatted;
+ (NSString *)getSystemVersion;
+ (NSString *)getUUID;


@end

NS_ASSUME_NONNULL_END
