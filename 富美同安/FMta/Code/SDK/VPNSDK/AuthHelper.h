//
//  AuthDelegate.h
//  Auth
//
//  Created by Huang Shounan on 12-11-13.
//
//

#if kHasVPNWork
#if kEMMSupport
#import <Foundation/Foundation.h>
#include "sdkheader.h"

@protocol SangforSDKDelegate<NSObject>

@required

- (void) onCallBack:(const VPN_RESULT_NO)vpnErrno authType:(const int)authType;

@optional

- (void) onReloginCallback:(const int)status result:(const int)result;

- (int) onSelectIdentity:(const IdentityData*)vector count:(int)count;
/**获取到图形校验码**/
- (void) onRndCodeCallBack:(NSData*)data;

- (void) onL3VPNStatusCallback:(L3vpnStatus)status;

@end

typedef enum SdkMode {
    EasyApp,
    L3VPN
}SdkMode;

@interface AuthHelper : NSObject
{
    BOOL mInit;
}
+ (id<SangforSDKDelegate>)getGlobalDelegate;

+ (AuthHelper *)getInstance;

- (void)init:(SdkMode)mode host:(NSString *)host port:(short)port delegate:(id <SangforSDKDelegate>)delegate;

- (void)setHost:(NSString *)host port:(short)port delegate:(id <SangforSDKDelegate>)delegate;

- (id)initWithHostAndPort:(NSString *)host port:(short)port delegate:(id <SangforSDKDelegate>)delegate;

- (int) setUserNamePassword:(NSString *)userName password:(NSString *)password;

- (void) setDnsServer:(NSString *)server;

- (int) getRndCode;

- (NSString *) getSmsCountDown;

- (NSString *) getSmsPhoneNumber;

- (NSString *) getSdkVersion;

- (int) setAuthParam:(NSString *)key param:(NSString*)value;

- (NSData*) getAuthParam:(NSString *)key;

- (void) clearAuthParam:(NSString *)key;

- (void)setDelegate:(id <SangforSDKDelegate>)delegate;

- (int) loginVpn:(const int )authType;

- (int) logoutVpn;

- (int) quitLogin;

- (int) relogin;

- (int) getProxyPort;

- (VPN_STATUS) vpnQueryStatus;

- (void) queryL3VPNStatus;

- (void)forceLogoutL3vpnIfNeeded;

@end

#else //VPNSupport

#import <Foundation/Foundation.h>
#include "sdkheader.h"

@protocol SangforSDKDelegate<NSObject>

@required

- (void) onCallBack:(const VPN_RESULT_NO)vpnErrno authType:(const int)authType;

@optional

- (void) onReloginCallback:(const int)status result:(const int)result;

- (int) onSelectIdentity:(const IdentityData*)vector count:(int)count;
/**获取到图形校验码**/
- (void) onRndCodeCallBack:(NSData*)data;

@end

@interface AuthHelper : NSObject
{
    BOOL mInit;
}
+ (id<SangforSDKDelegate>)getGlobalDelegate;

+ (AuthHelper *)getInstance;

- (id)initWithHostAndPort:(NSString *)host port:(short)port delegate:(id <SangforSDKDelegate>)delegate;

- (int) setUserNamePassword:(NSString *)userName password:(NSString *)password;

- (void) setDnsServer:(NSString *)server;

- (int) getRndCode;

- (int) setAuthParam:(NSString *)key param:(NSString*)value;

- (NSData*) getAuthParam:(NSString *)key;

- (void) clearAuthParam:(NSString *)key;

- (void)setDelegate:(id <SangforSDKDelegate>)delegate;

- (int) loginVpn:(const int )authType;

- (int) logoutVpn;

- (int) quitLogin;

- (int) relogin;

- (int) getProxyPort;

- (VPN_STATUS) vpnQueryStatus;

@end
#endif //__EMMSuport
#endif //__hasVPNWork
