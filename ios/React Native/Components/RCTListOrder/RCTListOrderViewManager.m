//
//  RCTListOrderViewManager.m
//  nativeUIModulesTest
//
//  Created by Dominic Go on 7/4/20.
//

#import <React/RCTViewManager.h>

@interface RCT_EXTERN_MODULE(RCTListOrderViewManager, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(listData  , NSArray);
RCT_EXPORT_VIEW_PROPERTY(descLabel , NSString);
RCT_EXPORT_VIEW_PROPERTY(isEditable, BOOL);

@end
