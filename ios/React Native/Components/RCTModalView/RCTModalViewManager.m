
#import <React/RCTViewManager.h>
 
@interface RCT_EXTERN_MODULE(RCTModalViewManager, RCTViewManager)

// ------------------------------
// MARK: Properties - React Props
// ------------------------------
                         
RCT_EXPORT_VIEW_PROPERTY(onModalShow    , RCTDirectEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onModalDismiss , RCTDirectEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onRequestResult, RCTDirectEventBlock);

RCT_EXPORT_VIEW_PROPERTY(onModalDidDismiss    , RCTDirectEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onModalWillDismiss   , RCTDirectEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onModalAttemptDismiss, RCTDirectEventBlock);

RCT_EXPORT_VIEW_PROPERTY(presentViaMount       , BOOL);
RCT_EXPORT_VIEW_PROPERTY(isModalInPresentation , BOOL);
RCT_EXPORT_VIEW_PROPERTY(allowModalForceDismiss, BOOL);

// --------------------------
// MARK:
// --------------------------

RCT_EXTERN_METHOD(requestModalPresentation
            : (nonnull NSNumber *)node
  requestID : (nonnull NSNumber *)requestID
  visibility: (nonnull BOOL     *)visibility
);

@end

