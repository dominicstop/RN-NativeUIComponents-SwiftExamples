

#import <React/RCTViewManager.h>

@interface RCT_EXTERN_MODULE(RCTUIButtonManager, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(dummyBool , BOOL);
RCT_EXPORT_VIEW_PROPERTY(dummyBool2, BOOL);

RCT_EXPORT_VIEW_PROPERTY(labelValue , NSString);
RCT_EXPORT_VIEW_PROPERTY(labelValue2, NSString);

RCT_EXPORT_VIEW_PROPERTY(count, NSNumber);
RCT_EXPORT_VIEW_PROPERTY(config, NSDictionary *);

RCT_EXPORT_VIEW_PROPERTY(onClick, RCTBubblingEventBlock);
@end



