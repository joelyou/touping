//
//  ToupingChooseView.h
//

#import <UIKit/UIKit.h>
#import <MRDLNA/MRDLNA.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ToupingChooseViewDelegate <NSObject>

- (void)ToupingChooseViewClickModel:(CLUPnPDevice*)model;

@end

@interface ToupingChooseView : UIView
@property(nonatomic,strong)NSArray *dataSource;

@property(nonatomic,weak)id<ToupingChooseViewDelegate>delegate;

@property(nonatomic,assign) NSString *uuid;

@end

NS_ASSUME_NONNULL_END
