//
//  ToupingView.h
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ToupingViewDelegate <NSObject>

- (void)ToupingViewClickType:(int)type;

@end

@interface ToupingView : UIView

@property (weak, nonatomic) IBOutlet UIButton *gaoqinBtn;
@property (weak, nonatomic) IBOutlet UIButton *tuichuBtn;
@property (weak, nonatomic) IBOutlet UIButton *huanBtn;
@property(nonatomic,weak)id<ToupingViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;

@property(nonatomic,strong)NSString *deviceName;
@property(nonatomic,strong)NSString *gaoqinStatus;

@end

NS_ASSUME_NONNULL_END
