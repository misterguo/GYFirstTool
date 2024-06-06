//
//  DeviceTool.m
//  QXTest
//
//  Created by  on 2023/2/15.
//

#define kLocationSuccess @"kLocationSuccess"


#import "DeviceTool.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
static NSString * notReachable = @"notReachable";
#include <sys/sysctl.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "SystemServices.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>
#include <ifaddrs.h>
#import <sys/utsname.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <SystemConfiguration/CaptiveNetwork.h>

#define TL_Str_Protect(str) ((str) ? (str) : (@""))
#define UUIDKey @"GY_UUID"

@interface DeviceTool()<CLLocationManagerDelegate>

@property(nonatomic, strong)CLLocationManager * locationManager;
@property(nonatomic, strong)CLGeocoder * geocoder;

@end
@implementation DeviceTool


+ (NSMutableDictionary *)getAllData{
    NSString *noData = @"";
    NSMutableDictionary *allData = [NSMutableDictionary new];
//    allData[@"orderId"] = orderId;
    allData[@"androidId"] = noData;
    allData[@"gaid"] = noData;
    allData[@"uuid"] = [DeviceTool getUUID];
    allData[@"idfa"] = [DeviceTool getIDFA];
    allData[@"idfv"] = [DeviceTool getIDFV];
    allData[@"phoneBoard"] = noData;
    allData[@"phoneBrand"] = @"Apple";
    //
    allData[@"phoneMark"] = [DeviceTool getDeviceName];
    allData[@"phoneType"] = [DeviceTool getDeviceTypeFormatted];
    allData[@"systemVersions"] = [NSString stringWithFormat:@"%@",[DeviceTool getSystemVersion]];
    allData[@"versionCode"] = [DeviceTool getApplicationVersion];
    allData[@"versionName"] = [DeviceTool getApplicationVersion];
    allData[@"sdkVersion"] = noData;
    allData[@"productionDate"] = noData;
    allData[@"serial"] = noData;
    allData[@"screenResolution"] = [DeviceTool getScreenResolution];
    allData[@"screenWidth"] = [NSString stringWithFormat:@"%d",(int)[UIScreen mainScreen].bounds.size.width];
    allData[@"screenHeight"] = [NSString stringWithFormat:@"%d",(int)[UIScreen mainScreen].bounds.size.height];
    allData[@"cpuNum"] = [NSString stringWithFormat:@"%@",[DeviceTool cpuCount]];
    allData[@"ramCanUse"] = [NSString stringWithFormat:@"%@",[DeviceTool ramAvailableSize]];
    allData[@"ramTotal"] = [[DeviceTool ramTotalMemory] stringValue];
    allData[@"cashCanUse"] = [[DeviceTool cashAvailableSize]stringValue];
    allData[@"cashTotal"] = [[DeviceTool cashTotalSize]stringValue];
    allData[@"batteryLevel"] = [[DeviceTool batteryLevel]stringValue];
    allData[@"batteryMax"] = @"100";
    allData[@"totalBootTime"] = [NSString stringWithFormat:@"%lld",[DeviceTool getUptimeWithResting]];
    allData[@"totalBootTimeWake"] = [NSString stringWithFormat:@"%lld",[DeviceTool getUptimeWithoutResting]];
    allData[@"defaultLanguage"] = [DeviceTool getLanguage];
    allData[@"defaultTimeZone"] = [DeviceTool getTimeZone];
    //
    NSDictionary *simInfo = [DeviceTool SIMInfo];
    allData[@"telephony"] = TL_Str_Protect(simInfo[@"SIM1NetworkOperator"]);
    allData[@"network"] = [DeviceTool getNetworkType];
    NSDictionary *wifiInfo = [DeviceTool WifiInfo];
    NSString *wifiSSID = @"";
    NSString *wifiBSSID = @"";
    if (wifiInfo){
        wifiSSID = wifiInfo[@"ssid"];
        wifiBSSID = wifiInfo[@"bssid"];
    }

    allData[@"mac"] = wifiBSSID;
    allData[@"wifiName"] = wifiSSID;
    allData[@"phoneNum"] = noData;
    allData[@"phoneNum2"] = noData;
    allData[@"rooted"] = [self trueOrFalse:[DeviceTool Jailbroken]];
    allData[@"debugged"] = [self trueOrFalse:[DeviceTool debuggerAttached]];
    allData[@"simulated"] = [self trueOrFalse:[DeviceTool simulator]];
    allData[@"proxied"] = [self trueOrFalse:[DeviceTool getProxyStatus]];
    allData[@"charged"] = [self trueOrFalse:[DeviceTool charging]];
        
    // over
    [allData enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:@""]){
            allData[key] = @"null";
        }
    }];
    
    // new add
    allData[@"deviceType"] = [DeviceTool getDeviceType];
    allData[@"operatingSystem"] = @"2";

    allData[@"lastBootTime"] = [[DeviceTool getBootTime]stringValue];
    allData[@"screenBrightness"] = [NSString stringWithFormat:@"%d",(int)[DeviceTool getScreenBrightness]];
    if (simInfo[@"numberOfSlots"]){
        allData[@"slotCount"] = [simInfo[@"numberOfSlots"] stringValue];
    }
    if (simInfo[@"numberOfSIMCards"]){
        allData[@"simCount"] = [simInfo[@"numberOfSIMCards"]stringValue];
    }
    if (simInfo[@"SIM2NetworkOperator"]&& ![simInfo[@"SIM2NetworkOperator"] isEqualToString:@""]){
        allData[@"telephony2"] = simInfo[@"SIM2NetworkOperator"];
    }
    allData[@"wifiBssid"] = allData[@"mac"];
    allData[@"wifiSsid"] = allData[@"wifiName"];
    allData[@"isvpn"] = [self trueOrFalse: [DeviceTool isVPNOn]];
    
    // -99
    allData[@"videoInternal"] = @"-99";
    allData[@"imageInternal"] = @"-99";
    allData[@"albumFile"] = @"-99";
    
    return allData;
}


+ (NSString *)trueOrFalse:(BOOL)b{
    return b ? @"true" : @"false";
}

+ (NSMutableArray *)getContactBookData{
    return [NSMutableArray arrayWithArray:[self getContactBookDataWithMaxCount:NSIntegerMax]];
}
+ (NSArray *)getContactBookDataWithMaxCount:(NSInteger)maxCount
{
    return [DeviceTool getContactBookInNewConditionWithMaxNum:maxCount WithCheckPhoneNum:^BOOL(NSString *str) {
        return YES;
    }];
}
+ (NSArray *)getContactBookInNewConditionWithMaxNum:(NSInteger)maxCount WithCheckPhoneNum:(BOOL(^)(NSString*))checkPhoneNum{
    NSArray *addressBookInfoArr = [DeviceTool getAddressBookInfoWithMaxCount:maxCount];
    NSMutableArray *allContactData = [[NSMutableArray alloc]init];
    if (addressBookInfoArr.count == 0){
        return allContactData;
    }
    NSMutableArray *allPhoneArray = [NSMutableArray array];
    for(NSDictionary *dic in addressBookInfoArr){
        NSString *contactName = [[NSString stringWithFormat:@"%@ %@",dic[@"lastName"],dic[@"firstName"]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (contactName.length == 0) {
            continue;
        }
        NSArray *phoneNumArray = [NSArray arrayWithArray:dic[@"phoneArray"]];
        // second delete empty phoneNum
        for (NSString *phoneNum in phoneNumArray) {
            NSString *contactPhone = [TL_Str_Protect(phoneNum) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSDate *contactUpdateTime = dic[@"alterTime"];
            NSString *contactUpdateTimeStr = @"";
            if(contactUpdateTime){
                contactUpdateTimeStr = [NSString stringWithFormat:@"%lld",(long long int)([contactUpdateTime timeIntervalSince1970]*1000)];
            }
            if (checkPhoneNum(contactPhone) == true) {
                if ([allPhoneArray containsObject:contactPhone] == false && contactPhone.length > 0) {
                        [allPhoneArray addObject:contactPhone];
                        [allContactData addObject:@{@"contactName":contactName,@"contactPhone":contactPhone,@"contactUpdateTime":contactUpdateTimeStr,@"contactStorage":@"1",@"contactCount":@"-99",@"contactTime":@""}];
             }
          }
        }
        
    }
    return allContactData.count > maxCount ? [allContactData subarrayWithRange:NSMakeRange(0, maxCount)] : allContactData;
}

 + (CGFloat)getStatusBarHight {
    float statusBarHeight = 0;
    if (@available(iOS 13.0, *)) {
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager;
        statusBarHeight = statusBarManager.statusBarFrame.size.height;
    }
    else {
        statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    return statusBarHeight;
}

- (void)initializeLocationService {

    _locationManager = [[CLLocationManager alloc] init];
    if (@available(iOS 14.0, *)) {
        CLAuthorizationStatus status = self.locationManager.authorizationStatus;
        if (status == kCLAuthorizationStatusDenied){
            [DeviceTool goToSettingPage];
        }else if (status == kCLAuthorizationStatusNotDetermined){
            [_locationManager requestWhenInUseAuthorization];
        }
    } else {
        // Fallback on earlier versions
        if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {

            if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
                [_locationManager requestWhenInUseAuthorization];
            }
        }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {

            [DeviceTool goToSettingPage];
        }
    }

    _locationManager.delegate = self;

    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    _locationManager.distanceFilter = kCLDistanceFilterNone;

    [_locationManager startUpdatingLocation];

    _geocoder = [[CLGeocoder alloc] init];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation * location = locations.lastObject;
//    CLLocationDegrees latitude = location.coordinate.latitude;
//    CLLocationDegrees longitude = location.coordinate.longitude;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kLocationSuccess object:self];
    [manager stopUpdatingLocation];
}

- (void)requestAuthorizationForAddressBook2 {

    ABAuthorizationStatus authorizationStatus = ABAddressBookGetAuthorizationStatus();
     if (authorizationStatus == kABAuthorizationStatusNotDetermined) {
     ABAddressBookRef addressBookRef = ABAddressBookCreate();
     ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
      if (granted) {
     
      } else {

      }
     });
     }
}

+ (NSArray *)getAddressBookInfoWithMaxCount:(NSInteger)maxCount{

    NSMutableArray *infoArr = [NSMutableArray new];

    ABAuthorizationStatus authorizationStatus = ABAddressBookGetAuthorizationStatus();
    if (authorizationStatus != kABAuthorizationStatusAuthorized) {

        return infoArr;
    }


    ABAddressBookRef addressBookRef = ABAddressBookCreate();
    CFArrayRef arrayRef = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    long count = CFArrayGetCount(arrayRef);
    for (int i = 0; i < count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary new];

        ABRecordRef people = CFArrayGetValueAtIndex(arrayRef, i);


        NSString *firstName=(__bridge NSString *)(ABRecordCopyValue(people, kABPersonFirstNameProperty));


        NSString *lastName=(__bridge NSString *)(ABRecordCopyValue(people, kABPersonLastNameProperty));
//        NSLog(@"--------------------------------------------------");
//        NSLog(@"firstName=%@, lastName=%@", firstName, lastName);
        dic[@"firstName"] = firstName;
        dic[@"lastName"] = lastName;

        NSMutableArray *phoneArray = [[NSMutableArray alloc]init];
        ABMultiValueRef phones = ABRecordCopyValue(people, kABPersonPhoneProperty);
        for (NSInteger j=0; j<ABMultiValueGetCount(phones); j++) {
            NSString *phone = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(phones, j));
//            NSLog(@"phone=%@", phone);
            [phoneArray addObject:phone];
        }
        dic[@"phoneArray"] = phoneArray;

        NSDate *creatTime=(__bridge NSDate*)(ABRecordCopyValue(people, kABPersonCreationDateProperty));


        NSDate *alterTime=(__bridge NSDate*)(ABRecordCopyValue(people, kABPersonModificationDateProperty));
        dic[@"creatTime"] = creatTime;
        dic[@"alterTime"] = alterTime;



        [infoArr addObject:dic];
        
        if (infoArr.count == maxCount) {
            return infoArr;
        }
    }
    return infoArr;
}


+ (NSString *)getApplicationVersion{
    return [SystemServices sharedServices].applicationVersion;
}
+ (NSString *)getUUID
{
//    return [self getIDFV];

    //    [self deleteKeyData:KEY_USERNAME_PASSWORD];
    NSString * strUUID = (NSString *)[self load:UUIDKey];


    if ([strUUID isEqualToString:@""] || !strUUID)
    {

        //        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
//
//        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));

        strUUID = [self getIDFV];

        [self save:UUIDKey data:strUUID];

    }
    return strUUID;
}

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

+ (void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}


+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
//            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (void)deleteKeyData:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

+ (void)IDFAAuthorization{
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
        }];
    }
}
+ (NSString*)getIDFA{
    __block NSString * idfa = @"";

    if (@available(iOS 14, *)) {
         [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {

             if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
            } else {
            }}];
    }else {
        idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
    }
    return idfa;
}
+ (void)goToSettingPage{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    });
}


+ (NSString *)getSystemVersion{
    // Get the current system version
    if ([[UIDevice currentDevice] respondsToSelector:@selector(systemVersion)]) {
        // Make a string for the system version
        NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
        // Set the output to the system version
        return systemVersion;
    } else {
        // System version not found
        return @"";
    }
}


+ (NSString *)getSystem{
    return @"IOS";
}


+ (NSString *)getLanguage{
    // Get the user's language
    @try {
        // Get the list of languages
        NSArray *languageArray = [NSLocale preferredLanguages];
        // Get the user's language
        NSString *language = [languageArray objectAtIndex:0];
        // Check for validity
        if (language == nil || language.length <= 0) {
            // Error, invalid language
            return @"";
        }
//        NSLog(@"language- %@",language);
        // Completed Successfully
        return [language componentsSeparatedByString:@"-"].firstObject;
//        return language;
    }
    @catch (NSException *exception) {
        // Error
        return @"";
    }
}


+ (NSString *)getTimeZone{
    // Get the user's timezone
    @try {
        // Get the system timezone
        NSTimeZone *localTime = [NSTimeZone systemTimeZone];
        // Convert the time zone to a string
        NSString *timeZone = [localTime name];
        // Check for validity
        if (timeZone == nil || timeZone.length <= 0) {
            // Error, invalid TimeZone
            return @"";
        }
        // Completed Successfully
        return timeZone;
    }
    @catch (NSException *exception) {
        // Error
        return @"";
    }
}

+ (NSNumber *)cpuCount{
    // See if the process info responds to selector
    if ([[NSProcessInfo processInfo] respondsToSelector:@selector(processorCount)]) {
        // Get the number of processors
        NSInteger processorCount = [[NSProcessInfo processInfo] processorCount];
        // Return the number of processors
        return @(processorCount);
    } else {
        // Return -1 (not found)
        return @-1;
    }
}

+ (NSNumber *)ramAvailableSize{

    double usedMemory = [SystemServices sharedServices].usedMemoryinRaw;

    usedMemory = usedMemory / 1024.0;

    double totalMemory = [[self ramTotalMemory] doubleValue];

    double availableMemory = totalMemory - usedMemory;
    
    
    return @(availableMemory);
    
}

+ (NSNumber *)ramTotalMemory{
    // MB  1024
    double totalMemory = [SystemServices sharedServices].totalMemory;
    //  GB 1024
    totalMemory = totalMemory / 1024.0;
    return @(totalMemory);

}


+ (NSNumber *)cashTotalSize{
    NSString *diskSpace = [SystemServices sharedServices].diskSpace;
    if (diskSpace){
        double diskSpaceDouble = [[diskSpace componentsSeparatedByString:@" "].firstObject doubleValue];
        return @(diskSpaceDouble);
    }
    return @0;
}

+ (NSNumber *)cashAvailableSize{
    NSString *freeDiskSpace = [SystemServices sharedServices].freeDiskSpaceinRaw;
    if (freeDiskSpace){
        double freeDiskSpaceDouble = [[freeDiskSpace componentsSeparatedByString:@" "].firstObject doubleValue];
        return @(freeDiskSpaceDouble);
    }
    return @0;
}

+ (NSNumber *)batteryLevel{
    return @([SystemServices sharedServices].batteryLevel);
}


+ (BOOL)charging{
    return [SystemServices sharedServices].charging;
}


+ (NSNumber *)getBootTime{

    long long int uptime = [self getUptimeWithResting];

    NSTimeInterval interval = (double)uptime / 1000.f;
    //
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:(0-interval)];

    long timeStamp = [date timeIntervalSince1970] * 1000;
    
    return @(timeStamp);
}



+ (NSString*)getIDFV{
    NSString * IDFV = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return IDFV;
}


+ (BOOL)isVPNOn
{
   BOOL flag = NO;
   NSString *version = [UIDevice currentDevice].systemVersion;
   // need two ways to judge this.
   if (version.doubleValue >= 9.0)
   {
       NSDictionary *dict = CFBridgingRelease(CFNetworkCopySystemProxySettings());
       NSArray *keys = [dict[@"__SCOPED__"] allKeys];
       for (NSString *key in keys) {
           if ([key rangeOfString:@"tap"].location != NSNotFound ||
               [key rangeOfString:@"tun"].location != NSNotFound ||
               [key rangeOfString:@"ipsec"].location != NSNotFound ||
               [key rangeOfString:@"ppp"].location != NSNotFound){
               flag = YES;
               break;
           }
       }
   }
   else
   {
       struct ifaddrs *interfaces = NULL;
       struct ifaddrs *temp_addr = NULL;
       int success = 0;
       
       // retrieve the current interfaces - returns 0 on success
       success = getifaddrs(&interfaces);
       if (success == 0)
       {
           // Loop through linked list of interfaces
           temp_addr = interfaces;
           while (temp_addr != NULL)
           {
               NSString *string = [NSString stringWithFormat:@"%s" , temp_addr->ifa_name];
               if ([string rangeOfString:@"tap"].location != NSNotFound ||
                   [string rangeOfString:@"tun"].location != NSNotFound ||
                   [string rangeOfString:@"ipsec"].location != NSNotFound ||
                   [string rangeOfString:@"ppp"].location != NSNotFound)
               {
                   flag = YES;
                   break;
               }
               temp_addr = temp_addr->ifa_next;
           }
       }
       
       // Free memory
       freeifaddrs(interfaces);
   }


   return flag;
}


+ (long long int)getUptimeWithoutResting{
    // Get the info about a process
    NSProcessInfo *processInfo = [NSProcessInfo processInfo];
    // Get the uptime of the system
    NSTimeInterval uptimeInterval = [processInfo systemUptime];
    return (long long int)(uptimeInterval * 1000);
}


+ (long long int)getUptimeWithResting{
    struct timeval boottime;
    int mib[2] = {CTL_KERN, KERN_BOOTTIME};
    size_t size = sizeof(boottime);
    struct timeval now;
    struct timezone tz;
    gettimeofday(&now, &tz);
    long long int uptime = -1;
    if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0) {
        uptime = ((long long int)(now.tv_sec - boottime.tv_sec)) * 1000;
        uptime += (now.tv_usec - boottime.tv_usec) / 1000;

    }
    
//        struct timespec ts;
//        if (@available(iOS 10.0, *)){
//            clock_gettime(CLOCK_MONOTONIC, &ts);
//        }else{
//
//        }
////        return ts.tv_sec;
//    NSLog(@"w-%lld\n m-%ld",uptime,ts.tv_sec*1000);
    
    return uptime;
    

}


+ (float)getScreenBrightness {
    // Get the screen brightness
    @try {
        // Brightness
        float brightness = [UIScreen mainScreen].brightness;
        // Verify validity
        if (brightness < 0.0 || brightness > 1.0) {
            // Invalid brightness
            return -1;
        }
        
        // Successful
        return (brightness * 100);
    }
    @catch (NSException *exception) {
        // Error
        return -1;
    }
}

+ (NSString *)getScreenResolution{
    CGFloat scale_screen = [UIScreen mainScreen].scale;

    CGRect rect_screen = [[UIScreen mainScreen]bounds];
    //
    CGFloat w = rect_screen.size.width * scale_screen;
    //
    CGFloat h = rect_screen.size.height * scale_screen;
    return [NSString stringWithFormat:@"%d-%d",(int)w,(int)h];
}

+ (NSString *)getNetworkType{
    NSString *networkType = [self getNetworkTypeDetail];
    if ([networkType isEqualToString:@"Unknow"]){
        return @"0";
    }else if (([networkType isEqualToString:@"WiFi"])){
        return @"1";
    }else if (([networkType isEqualToString:@"2G"])){
        return @"2";
    }else if (([networkType isEqualToString:@"3G"])){
        return @"3";
    }else if (([networkType isEqualToString:@"4G"])){
        return @"4";
    }else if (([networkType isEqualToString:@"5G"])){
        return @"5";
    }
    return @"0";
}
+ (NSString *)getNetworkTypeDetail {
    
    struct sockaddr_storage zeroAddress;
    
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.ss_len = sizeof(zeroAddress);
    zeroAddress.ss_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) {
        return notReachable;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    if (isReachable && !needsConnection) { }else{
        return notReachable;
    }
    
    
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == kSCNetworkReachabilityFlagsConnectionRequired ) {
        
        return notReachable;
        
    } else if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN) {
        
        return [self cellularType];
        
    } else {
        return @"WiFi";
    }
    
}

+ (NSString *)cellularType {
    
    CTTelephonyNetworkInfo * info = [[CTTelephonyNetworkInfo alloc] init];
    
    NSString *currentRadioAccessTechnology;
    if (@available(iOS 12.1, *)) {
        if (info && [info respondsToSelector:@selector(serviceCurrentRadioAccessTechnology)]) {
            NSDictionary *radioDic = [info serviceCurrentRadioAccessTechnology];
            if (radioDic.allKeys.count) {
                currentRadioAccessTechnology = [radioDic objectForKey:radioDic.allKeys[0]];
            } else {
                return notReachable;
            }
        } else {
            
            return notReachable;
        }
        
    } else {
        
        currentRadioAccessTechnology = info.currentRadioAccessTechnology;
    }
    
    if (currentRadioAccessTechnology) {
        
        if (@available(iOS 14.1, *)) {
            
            if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyNRNSA] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyNR]) {
                
                return @"5G";
                
            }
        }
        
        if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE]) {
            
            return @"4G";
            
        } else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyWCDMA] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSDPA] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSUPA] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyeHRPD]) {
            
            return @"3G";
            
        } else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMA1x]) {
            
            return @"2G";
            
        } else {
            
            return @"Unknow";
        }
        
        
    } else {
        
        return notReachable;
    }
}

+ (NSDictionary *)SIMInfo{
//    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    NSInteger numberOfSlots = 0;
    NSInteger numberOfSIMCards = 0;
    NSString *SIM1NetworkOperator = @"";
    NSString *SIM2NetworkOperator = @"";
    
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    //CTCarrier
    NSDictionary *carriers = [info serviceSubscriberCellularProviders];
    for (NSString *name in carriers ){
        numberOfSlots ++;
//        NSLog(@"name--%@",name);
        CTCarrier *carrier = carriers[name];
//        BOOL use = carrier.allowsVOIP;
        NSString *name = carrier.carrierName;
        if (!name || name.length <= 0){

        }else{
            numberOfSIMCards ++;
            if (numberOfSlots == 1){
                SIM1NetworkOperator = name;
            }else{
                SIM2NetworkOperator = name;
            }
        }

    }
    
    return @{@"numberOfSlots":@(numberOfSlots),@"numberOfSIMCards":@(numberOfSIMCards),@"SIM1NetworkOperator":SIM1NetworkOperator,@"SIM2NetworkOperator":SIM2NetworkOperator};
}


+ (NSDictionary *)WifiInfo{
    NSArray *interfaces = CFBridgingRelease(CNCopySupportedInterfaces());//Declaration of 'CNCopySupportedInterfaces' must be imported from module 'SystemConfiguration.CaptiveNetwork' before it is required
    id info = nil;
    for (NSString *interfaceName in interfaces) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((CFStringRef)interfaceName);
        if (info) {
            break;
        }
    }
    if (info){
        NSDictionary *infoDic = (NSDictionary *)info;
        NSString *ssid = [infoDic objectForKey:@"SSID"];
        NSString *bssid = [infoDic objectForKey:@"BSSID"];
        
        return @{@"ssid":ssid,@"bssid":bssid};
    }
    return nil;
}

+ (BOOL)debuggerAttached{
    return [SystemServices sharedServices].debuggerAttached;
}


+ (BOOL)Jailbroken{
    return [SystemServices sharedServices].jailbroken == NOTJAIL ? NO : YES;
}


+ (BOOL)simulator{
    NSString *deviceType = [SystemServices sharedServices].systemDeviceTypeNotFormatted;
    if ([deviceType isEqualToString:@"i386"])
        return YES;
    else if ([deviceType isEqualToString:@"x86_64"])
        return YES;
    else if ([deviceType isEqualToString:@"arm64"])
        return YES;
    
    return NO;
}

+ (BOOL)getProxyStatus {
    NSDictionary* proxySettings =  (__bridge NSDictionary*)(CFNetworkCopySystemProxySettings());
    NSArray*proxies = (__bridge NSArray*)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"http://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    NSDictionary*settings = [proxies objectAtIndex:0];
    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"]){
        
        return NO;
    }else{
        
        return YES;
    }
}

+ (NSString *)getDeviceName{
    NSString *deviceName = @"";
    UIDevice *device = [UIDevice currentDevice];
    deviceName = device.name;
    return deviceName;
}


+ (NSNumber *)getDeviceType{

    NSNumber *newDeviceType = @0;
   
    NSString *detailDeviceType = [self getDeviceTypeFormatted];
    if ([detailDeviceType hasPrefix:@"iPhone"])
        newDeviceType = @3;
    else if ([detailDeviceType hasPrefix:@"iPad"])
        newDeviceType = @2;
    else if ([detailDeviceType hasPrefix:@"iMac"] || [detailDeviceType hasPrefix:@"Mac"])
        newDeviceType = @1;

    return newDeviceType;
}

+ (NSString *)getDeviceType2{
    NSString *newDeviceType = @"unknown";
    NSString *detailDeviceType = [self getDeviceTypeFormatted];
    if ([detailDeviceType hasPrefix:@"iPhone"])
        newDeviceType = @"Mobile";
    else if ([detailDeviceType hasPrefix:@"iPad"])
        newDeviceType = @"Tablet";
    else if ([detailDeviceType hasPrefix:@"iMac"] || [detailDeviceType hasPrefix:@"Mac"])
        newDeviceType = @"pc";
    return newDeviceType;
}


+ (NSString *)getDeviceTypeFormatted{
    NSString *deviceType;
    NSString *newDeviceType;
    // Set up a struct
    struct utsname dt;
    // Get the system information
    uname(&dt);
    // Set the device type to the machine type
    deviceType = [NSString stringWithFormat:@"%s", dt.machine];
    newDeviceType = deviceType;
    // Simulators
    if ([deviceType isEqualToString:@"i386"])
        newDeviceType = @"iPhone Simulator";
    else if ([deviceType isEqualToString:@"x86_64"])
        newDeviceType = @"iPhone Simulator";
    else if ([deviceType isEqualToString:@"arm64"])
        newDeviceType = @"iPhone Simulator";
    // iPhones
    else if ([deviceType isEqualToString:@"iPhone1,1"])
        newDeviceType = @"iPhone";
    else if ([deviceType isEqualToString:@"iPhone1,2"])
        newDeviceType = @"iPhone 3G";
    else if ([deviceType isEqualToString:@"iPhone2,1"])
        newDeviceType = @"iPhone 3GS";
    else if ([deviceType isEqualToString:@"iPhone3,1"])
        newDeviceType = @"iPhone 4";
    else if ([deviceType isEqualToString:@"iPhone4,1"])
        newDeviceType = @"iPhone 4S";
    else if ([deviceType isEqualToString:@"iPhone5,1"])
        newDeviceType = @"iPhone 5";
    else if ([deviceType isEqualToString:@"iPhone5,2"])
        newDeviceType = @"iPhone 5";
    else if ([deviceType isEqualToString:@"iPhone5,3"])
        newDeviceType = @"iPhone 5c";
    else if ([deviceType isEqualToString:@"iPhone5,4"])
        newDeviceType = @"iPhone 5c";
    else if ([deviceType isEqualToString:@"iPhone6,1"])
        newDeviceType = @"iPhone 5s";
    else if ([deviceType isEqualToString:@"iPhone6,2"])
        newDeviceType = @"iPhone 5s";
    else if ([deviceType isEqualToString:@"iPhone7,1"])
        newDeviceType = @"iPhone 6 Plus";
    else if ([deviceType isEqualToString:@"iPhone7,2"])
        newDeviceType = @"iPhone 6";
    else if ([deviceType isEqualToString:@"iPhone8,1"])
        newDeviceType = @"iPhone 6s";
    else if ([deviceType isEqualToString:@"iPhone8,2"])
        newDeviceType = @"iPhone 6s Plus";
    else if ([deviceType isEqualToString:@"iPhone8,4"])
        newDeviceType = @"iPhone SE";
    else if ([deviceType isEqualToString:@"iPhone9,1"])
        newDeviceType = @"iPhone 7";
    else if ([deviceType isEqualToString:@"iPhone9,3"])
        newDeviceType = @"iPhone 7";
    else if ([deviceType isEqualToString:@"iPhone9,2"])
        newDeviceType = @"iPhone 7 Plus";
    else if ([deviceType isEqualToString:@"iPhone9,4"])
        newDeviceType = @"iPhone 7 Plus";
    else if ([deviceType isEqualToString:@"iPhone10,1"])
        newDeviceType = @"iPhone 8";
    else if ([deviceType isEqualToString:@"iPhone10,4"])
        newDeviceType = @"iPhone 8";
    else if ([deviceType isEqualToString:@"iPhone10,2"])
        newDeviceType = @"iPhone 8 Plus";
    else if ([deviceType isEqualToString:@"iPhone10,5"])
        newDeviceType = @"iPhone 8 Plus";
    else if ([deviceType isEqualToString:@"iPhone10,3"])
        newDeviceType = @"iPhone X";
    else if ([deviceType isEqualToString:@"iPhone10,6"])
        newDeviceType = @"iPhone X";
    else if ([deviceType isEqualToString:@"iPhone11,8"])
        newDeviceType = @"iPhone XR";
    else if ([deviceType isEqualToString:@"iPhone11,2"])
        newDeviceType = @"iPhone XS";
    else if ([deviceType isEqualToString:@"iPhone11,6"])
        newDeviceType = @"iPhone XS Max";
    else if ([deviceType isEqualToString:@"iPhone12,1"])
        newDeviceType = @"iPhone 11";
    else if ([deviceType isEqualToString:@"iPhone12,3"])
        newDeviceType = @"iPhone 11 Pro";
    else if ([deviceType isEqualToString:@"iPhone12,5"])
        newDeviceType = @"iPhone 11 Pro Max";
    else if ([deviceType isEqualToString:@"iPhone12,8"])
        newDeviceType = @"iPhone SE 2";
    else if ([deviceType isEqualToString:@"iPhone13,1"])
        newDeviceType = @"iPhone 12 mini";
    else if ([deviceType isEqualToString:@"iPhone13,2"])
        newDeviceType = @"iPhone 12";
    else if ([deviceType isEqualToString:@"iPhone13,3"])
        newDeviceType = @"iPhone 12 Pro";
    else if ([deviceType isEqualToString:@"iPhone13,4"])
        newDeviceType = @"iPhone 12 Pro Max";
    else if ([deviceType isEqualToString:@"iPhone14,4"])
        newDeviceType = @"iPhone 13 mini";
    else if ([deviceType isEqualToString:@"iPhone14,5"])
        newDeviceType = @"iPhone 13";
    else if ([deviceType isEqualToString:@"iPhone14,2"])
        newDeviceType = @"iPhone 13 Pro";
    else if ([deviceType isEqualToString:@"iPhone14,3"])
        newDeviceType = @"iPhone 13 Pro Max";
    else if ([deviceType isEqualToString:@"iPhone14,6"])
        newDeviceType = @"iPhone SE 3";
    else if ([deviceType isEqualToString:@"iPhone14,7"])
        newDeviceType = @"iPhone 14";
    else if ([deviceType isEqualToString:@"iPhone14,8"])
        newDeviceType = @"iPhone 14 Plus";
    else if ([deviceType isEqualToString:@"iPhone15,2"])
        newDeviceType = @"iPhone 14 Pro";
    else if ([deviceType isEqualToString:@"iPhone15,3"])
        newDeviceType = @"iPhone 14 Pro Max";
    else if ([deviceType isEqualToString:@"iPhone15,4"])
            newDeviceType = @"iPhone 15";
    else if ([deviceType isEqualToString:@"iPhone15,5"])
        newDeviceType = @"iPhone 15 Plus";
    else if ([deviceType isEqualToString:@"iPhone16,1"])
        newDeviceType = @"iPhone 15 Pro";
    else if ([deviceType isEqualToString:@"iPhone16,2"])
        newDeviceType = @"iPhone 15 Pro Max";
    // iPods
    else if ([deviceType isEqualToString:@"iPod1,1"])
        newDeviceType = @"iPod Touch 1G";
    else if ([deviceType isEqualToString:@"iPod2,1"])
        newDeviceType = @"iPod Touch 2G";
    else if ([deviceType isEqualToString:@"iPod3,1"])
        newDeviceType = @"iPod Touch 3G";
    else if ([deviceType isEqualToString:@"iPod4,1"])
        newDeviceType = @"iPod Touch 4G";
    else if ([deviceType isEqualToString:@"iPod5,1"])
        newDeviceType = @"iPod Touch 5G";
    else if ([deviceType isEqualToString:@"iPod7,1"])
        newDeviceType = @"iPod Touch 6G";
    else if ([deviceType isEqualToString:@"iPod9,1"])
        newDeviceType = @"iPod Touch 7G";
    // iPads
    else if ([deviceType isEqualToString:@"iPad1,1"])
        newDeviceType = @"iPad";
    else if ([deviceType isEqualToString:@"iPad2,1"])
        newDeviceType = @"iPad 2";
    else if ([deviceType isEqualToString:@"iPad2,2"])
        newDeviceType = @"iPad 2";
    else if ([deviceType isEqualToString:@"iPad2,3"])
        newDeviceType = @"iPad 2";
    else if ([deviceType isEqualToString:@"iPad2,4"])
        newDeviceType = @"iPad 2";
    else if ([deviceType isEqualToString:@"iPad2,5"])
        newDeviceType = @"iPad mini";
    else if ([deviceType isEqualToString:@"iPad2,6"])
        newDeviceType = @"iPad mini";
    else if ([deviceType isEqualToString:@"iPad2,7"])
        newDeviceType = @"iPad mini";
    else if ([deviceType isEqualToString:@"iPad3,1"])
        newDeviceType = @"iPad 3";
    else if ([deviceType isEqualToString:@"iPad3,2"])
        newDeviceType = @"iPad 3";
    else if ([deviceType isEqualToString:@"iPad3,3"])
        newDeviceType = @"iPad 3";
    else if ([deviceType isEqualToString:@"iPad3,4"])
        newDeviceType = @"iPad 4";
    else if ([deviceType isEqualToString:@"iPad3,5"])
        newDeviceType = @"iPad 4";
    else if ([deviceType isEqualToString:@"iPad3,6"])
        newDeviceType = @"iPad 4";
    else if ([deviceType isEqualToString:@"iPad4,1"])
        newDeviceType = @"iPad Air";
    else if ([deviceType isEqualToString:@"iPad4,2"])
        newDeviceType = @"iPad Air";
    else if ([deviceType isEqualToString:@"iPad4,3"])
        newDeviceType = @"iPad Air";
    else if ([deviceType isEqualToString:@"iPad4,4"])
        newDeviceType = @"iPad mini 2";
    else if ([deviceType isEqualToString:@"iPad4,5"])
        newDeviceType = @"iPad mini 2";
    else if ([deviceType isEqualToString:@"iPad4,6"])
        newDeviceType = @"iPad mini 2";
    else if ([deviceType isEqualToString:@"iPad4,7"])
        newDeviceType = @"iPad mini 3";
    else if ([deviceType isEqualToString:@"iPad4,8"])
        newDeviceType = @"iPad mini 3";
    else if ([deviceType isEqualToString:@"iPad4,9"])
        newDeviceType = @"iPad mini 3";
    else if ([deviceType isEqualToString:@"iPad5,1"])
        newDeviceType = @"iPad mini 4";
    else if ([deviceType isEqualToString:@"iPad5,2"])
        newDeviceType = @"iPad mini 4";
    //
    else if ([deviceType isEqualToString:@"iPad11,1"])
        newDeviceType = @"iPad mini 5";
    else if ([deviceType isEqualToString:@"iPad11,2"])
        newDeviceType = @"iPad mini 5";
    //
    else if ([deviceType isEqualToString:@"iPad14,1"])
        newDeviceType = @"iPad mini 6";
    else if ([deviceType isEqualToString:@"iPad14,2"])
        newDeviceType = @"iPad mini 6";
    //
    else if ([deviceType isEqualToString:@"iPad5,3"])
        newDeviceType = @"iPad Air 2";
    else if ([deviceType isEqualToString:@"iPad5,4"])
        newDeviceType = @"iPad Air 2";
    else if ([deviceType isEqualToString:@"iPad6,3"])
        newDeviceType = @"iPad Pro (9.7-inch)";
    else if ([deviceType isEqualToString:@"iPad6,4"])
        newDeviceType = @"iPad Pro (9.7-inch)";
    else if ([deviceType isEqualToString:@"iPad6,7"])
        newDeviceType = @"iPad Pro (12.9-inch)";
    else if ([deviceType isEqualToString:@"iPad6,8"])
        newDeviceType = @"iPad Pro (12.9-inch)";
    else if ([deviceType isEqualToString:@"iPad6,11"])
        newDeviceType = @"iPad 5";
    else if ([deviceType isEqualToString:@"iPad6,12"])
        newDeviceType = @"iPad 5";
    else if ([deviceType isEqualToString:@"iPad7,1"])
        newDeviceType = @"iPad Pro 2 (12.9-inch)";
    else if ([deviceType isEqualToString:@"iPad7,2"])
        newDeviceType = @"iPad Pro 2 (12.9-inch)";
    else if ([deviceType isEqualToString:@"iPad7,3"])
        newDeviceType = @"iPad Pro (10.5-inch)";
    else if ([deviceType isEqualToString:@"iPad7,4"])
        newDeviceType = @"iPad Pro (10.5-inch)";
    else if ([deviceType isEqualToString:@"iPad7,5"])
        newDeviceType = @"iPad 6";
    else if ([deviceType isEqualToString:@"iPad7,6"])
        newDeviceType = @"iPad 6";
    else if ([deviceType isEqualToString:@"iPad7,11"])
        newDeviceType = @"iPad 7";
    else if ([deviceType isEqualToString:@"iPad7,12"])
        newDeviceType = @"iPad 7";
    else if ([deviceType isEqualToString:@"iPad11,6"])
        newDeviceType = @"iPad 8";
    else if ([deviceType isEqualToString:@"iPad11,7"])
        newDeviceType = @"iPad 8";
    else if ([deviceType isEqualToString:@"iPad12,1"])
        newDeviceType = @"iPad 9";
    else if ([deviceType isEqualToString:@"iPad12,2"])
        newDeviceType = @"iPad 9";
    else if ([deviceType isEqualToString:@"iPad11,3"])
        newDeviceType = @"iPad Air 3";
    else if ([deviceType isEqualToString:@"iPad11,4"])
        newDeviceType = @"iPad Air 3";
    else if ([deviceType isEqualToString:@"iPad13,1"])
        newDeviceType = @"iPad Air 4";
    else if ([deviceType isEqualToString:@"iPad13,2"])
        newDeviceType = @"iPad Air 4";
    else if ([deviceType isEqualToString:@"iPad13,16"])
        newDeviceType = @"iPad Air 5";
    else if ([deviceType isEqualToString:@"iPad13,17"])
        newDeviceType = @"iPad Air 5";
    else if ([deviceType isEqualToString:@"iPad8,1"])
        newDeviceType = @"iPad Pro (11-inch)";
    else if ([deviceType isEqualToString:@"iPad8,2"])
        newDeviceType = @"iPad Pro (11-inch)";
    else if ([deviceType isEqualToString:@"iPad8,3"])
        newDeviceType = @"iPad Pro (11-inch)";
    else if ([deviceType isEqualToString:@"iPad8,4"])
        newDeviceType = @"iPad Pro (11-inch)";
    else if ([deviceType isEqualToString:@"iPad8,5"])
        newDeviceType = @"iPad Pro 3 (12.9-inch)";
    else if ([deviceType isEqualToString:@"iPad8,6"])
        newDeviceType = @"iPad Pro 3 (12.9-inch)";
    else if ([deviceType isEqualToString:@"iPad8,7"])
        newDeviceType = @"iPad Pro 3 (12.9-inch)";
    else if ([deviceType isEqualToString:@"iPad8,8"])
        newDeviceType = @"iPad Pro 3 (12.9-inch)";
    else if ([deviceType isEqualToString:@"iPad8,9"])
        newDeviceType = @"iPad Pro 2 (11-inch)";
    else if ([deviceType isEqualToString:@"iPad8,10"])
        newDeviceType = @"iPad Pro 2 (11-inch)";
    else if ([deviceType isEqualToString:@"iPad8,11"])
        newDeviceType = @"iPad Pro 4 (12.9-inch)";
    else if ([deviceType isEqualToString:@"iPad8,12"])
        newDeviceType = @"iPad Pro 4 (12.9-inch)";
    //
    else if ([deviceType isEqualToString:@"iPad13,4"])
        newDeviceType = @"iPad Pro 3 (11-inch)";
    else if ([deviceType isEqualToString:@"iPad13,5"])
        newDeviceType = @"iPad Pro 3 (11-inch)";
    else if ([deviceType isEqualToString:@"iPad13,6"])
        newDeviceType = @"iPad Pro 3 (11-inch)";
    else if ([deviceType isEqualToString:@"iPad13,7"])
        newDeviceType = @"iPad Pro 3 (11-inch)";
    //
    else if ([deviceType isEqualToString:@"iPad13,8"])
        newDeviceType = @"iPad Pro 5 (12.9-inch)";
    else if ([deviceType isEqualToString:@"iPad13,8"])
        newDeviceType = @"iPad Pro 5 (12.9-inch)";
    else if ([deviceType isEqualToString:@"iPad13,10"])
        newDeviceType = @"iPad Pro 5 (12.9-inch)";
    else if ([deviceType isEqualToString:@"iPad13,11"])
        newDeviceType = @"iPad Pro 5 (12.9-inch)";
    // Catch All iPad
    else if ([deviceType hasPrefix:@"iPad"])
        newDeviceType = @"iPad";
    // Apple TV
    else if ([deviceType isEqualToString:@"AppleTV2,1"])
        newDeviceType = @"Apple TV 2";
    else if ([deviceType isEqualToString:@"AppleTV3,1"])
        newDeviceType = @"Apple TV 3";
    else if ([deviceType isEqualToString:@"AppleTV3,2"])
        newDeviceType = @"Apple TV 3 (2013)";

    // Return the new device type
    return newDeviceType;
}
@end
