//
//  RCTListOrderViewManager.m
//  nativeUIModulesTest
//
//  Created by Dominic Go on 7/4/20.
//

#import <React/RCTViewManager.h>

@interface RCT_EXTERN_MODULE(RCTListOrderViewManager, RCTViewManager)

// --------------------------------
// MARK: Props - RN Component Props
// --------------------------------

RCT_EXPORT_VIEW_PROPERTY(listData  , NSArray);
RCT_EXPORT_VIEW_PROPERTY(descLabel , NSString);
RCT_EXPORT_VIEW_PROPERTY(isEditable, BOOL);

// ------------------------------
// MARK: Props - Callbacks/Events
// ------------------------------

RCT_EXPORT_VIEW_PROPERTY(onRequestResult  , RCTDirectEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onListItemsChange, RCTDirectEventBlock);

// ---------------------------
// MARK: View Manager Commands
// ---------------------------

RCT_EXTERN_METHOD(requestListData
            : (nonnull NSNumber *)node
  requestID : (nonnull NSNumber *)requestID
);

RCT_EXTERN_METHOD(requestSetListData
           : (nonnull NSNumber *)node
  requestID: (nonnull NSNumber *)requestID
  listItems: (nonnull NSArray  *)listItems
);

@end
