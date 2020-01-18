//
//  ToupingView.m
//

#import "ToupingView.h"

@implementation ToupingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.huanBtn addTarget:self action:@selector(huan:) forControlEvents:UIControlEventTouchUpInside];
    [self.gaoqinBtn addTarget:self action:@selector(gaoqin:) forControlEvents:UIControlEventTouchUpInside];
    [self.tuichuBtn addTarget:self action:@selector(tuichu:) forControlEvents:UIControlEventTouchUpInside];
    self.bgView.layer.cornerRadius = self.bgView.height/2;
    self.bgView.layer.masksToBounds = YES;
}

- (void)huan:(UIButton *)btn{
    [self click:3];
}

- (void)gaoqin:(UIButton *)btn{
    [self click:1];
}

- (void)tuichu:(UIButton *)btn{
    [self click:2];
}

- (void)click:(int)type{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ToupingViewClickType:)]) {
        [self.delegate ToupingViewClickType:type];
    }
}

- (void)setGaoqinStatus:(NSString *)gaoqinStatus{
    _gaoqinStatus = gaoqinStatus;
    [self.tuichuBtn setTitle:gaoqinStatus forState:UIControlStateNormal];
}

- (void)setDeviceName:(NSString *)deviceName{
    _deviceName = deviceName;
    [self.labTitle setText:[NSString stringWithFormat:@"正在投屏在%@h上",deviceName]];
}
@end
