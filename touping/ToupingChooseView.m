//
//  ToupingChooseView.m
//

#import "ToupingChooseView.h"
#import "ToupingCell.h"
#import "SVProgressHUD.h"

@interface ToupingChooseView()<UITableViewDelegate,UITableViewDataSource,DLNADelegate>
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong) MRDLNA *dlnaManager;

@property(nonatomic,strong)UIWebView *webView;

@property(nonatomic,assign)CGFloat webRowHeight;
@end

@implementation ToupingChooseView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        [self addSubview:headView];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, headView.height - 1, ScreenWidth, 1)];
        line.backgroundColor = UIColorFromRGB(0xF2F5F5);
        [headView addSubview:line];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, headView.height)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = UIColorFromRGB(0x383838);
        lab.text = @"选择投屏设备";
        lab.font = FontBold(17);
        [headView addSubview:lab];
        
        CGFloat imgW = 18;
        CGFloat imgH = 21;
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - imgW - 13, (headView.height - imgH)/2, imgW, imgH)];
        imgV.image = [UIImage imageNamed:@"shuaxin"];
        [headView addSubview:imgV];
        
        UIButton *btnRefesh = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 50, 0, 50, headView.height)];
        [btnRefesh addTarget:self action:@selector(refreshBtn:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:btnRefesh];
        
        self.dataSource = [NSMutableArray array];
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, headView.height, ScreenWidth, self.height - headView.height) style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.showsVerticalScrollIndicator = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (IOS_Version >= 11) {
            tableView.estimatedRowHeight = 0;
            tableView.estimatedSectionHeaderHeight = 0;
            tableView.estimatedSectionFooterHeight = 0;
        }
        tableView.separatorColor = UIColorFromRGB(0xf5f5f5);
        
        [tableView registerNib:[UINib nibWithNibName:@"ToupingCell" bundle:nil] forCellReuseIdentifier:@"ToupingCell"];
        [self addSubview:tableView];
        self.tableView = tableView;
        
        self.dlnaManager = [MRDLNA sharedMRDLNAManager];
        self.dlnaManager.delegate = self;
        [self.dlnaManager startSearch];
//        [SVProgressHUD show];

        self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];

        NSString *mainBundlePath = [[NSBundle mainBundle] bundlePath];//文件根路径
        NSString *basePath = [NSString stringWithFormat:@"%@/html",mainBundlePath];//获取目标html文件夹路径
        NSURL *baseUrl = [NSURL fileURLWithPath:basePath isDirectory:YES];//转换成url
        NSString *htmlPath = [NSString stringWithFormat:@"%@/index.html",basePath];//目标 文件路径
        NSString *htmlString = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];//把html文件转换成string类型
        self.webView.scalesPageToFit = YES;
        [self.webView loadHTMLString:htmlString baseURL:baseUrl];//加载


    }
    return self;
}

- (void)refreshBtn:(UIButton *)btn{
//    [SVProgressHUD show];
    [self.dlnaManager startSearch];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.dataSource.count == 0 ? 1 : self.dataSource.count;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.dataSource.count == 0) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.backgroundView.backgroundColor = [UIColor whiteColor];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell1"];
                UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
                [cell addSubview:activityIndicator];
                //设置小菊花的frame
                activityIndicator.frame= CGRectMake(0, 0, ScreenWidth, 47);
                //设置小菊花颜色
                activityIndicator.color = [UIColor lightGrayColor];
                [activityIndicator startAnimating];
            }
            return cell;
        }else{
            ToupingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToupingCell"];
            CLUPnPDevice *model = [self.dataSource objectAtIndex:indexPath.row];
            cell.deviceName.text = model.modelName;
            if ([self.uuid isEqualToString:model.uuid]) {
                cell.labStatus.text = @"投屏中";
            }else{
                cell.labStatus.text = @"";
            }
            return cell;
        }
    }else if (indexPath.section == 1){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            self.webView.height = self.webRowHeight;
            [cell addSubview:self.webView];
        }
        return cell;
    }
  
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ToupingChooseViewClickModel:)]) {
        CLUPnPDevice *model = [self.dataSource objectAtIndex:indexPath.row];
        [self.delegate ToupingChooseViewClickModel:model];
        self.uuid = model.uuid;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 0 ? 47 : self.webRowHeight;
}

- (void)setDataSource:(NSMutableArray *)dataSource{
    _dataSource = dataSource;
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 40 : 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenHeight, 10)];
    if (section == 0) {
        view.backgroundColor = [UIColor whiteColor];
        view.height = 40;
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 64, 40)];
        lab.textColor = UIColorFromRGB(0x383838);
        lab.font = FontRegular(16);
        lab.text = @"收米直播";
        [view addSubview:lab];
        
        lab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lab.frame) + 5, 14, 40, 16)];
        lab.textColor = UIColorFromRGB(0xFF6600);
        lab.font = FontRegular(12);
        lab.textAlignment = NSTextAlignmentCenter;
        lab.layer.cornerRadius = 4;
        lab.layer.masksToBounds = YES;
        lab.layer.borderWidth = 1;
        lab.layer.borderColor = UIColorFromRGB(0xFF6600).CGColor;
        lab.text = @"超清";
        [view addSubview:lab];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 39, ScreenWidth, 1)];
        line.backgroundColor = UIColorFromRGB(0xf5f5f5);
        [view addSubview:line];
        
    }else{
        view.backgroundColor = UIColorFromRGB(0xf5f5f5);

    }
    return view;
}


- (void)searchDLNAResult:(NSArray *)devicesArray{
    NSLog(@"发现设备");
//    [SVProgressHUD dismiss];
    self.dataSource =[NSArray arrayWithArray:devicesArray];
    [self.tableView reloadData];
    NSLog(@"searchDLNAResult=%@",devicesArray);
}

- (void)dlnaStartPlay{
    NSLog(@"投屏成功 开始播放");
}

- (void)searchDLNAEnd:(NSArray *)devicesArray{
    NSLog(@"--------------搜索结束");
    NSLog(@"searchDLNAEnd=%@",devicesArray);
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"contentSize"]) {
        //通过JS代码获取webview的内容高度
        CGFloat height= self.webView.scrollView.contentSize.height;
        
        if (height != self.webRowHeight) {
            self.webRowHeight = height;
            [self.tableView reloadData];
        }
    }
}

- (void)dealloc{
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}


@end
