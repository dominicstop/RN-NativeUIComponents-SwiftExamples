
#import <React/RCTViewManager.h>
 
@interface RCT_EXTERN_MODULE(RCTModalViewManager, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(onModalShow   , RCTDirectEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onModalDismiss, RCTDirectEventBlock);

@end

