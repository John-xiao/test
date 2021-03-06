//
//  menuViewController.m
//  videoDemo
//
//  Created by SHANPX on 16/4/24.
//  Copyright © 2016年 SHANPX. All rights reserved.
//

#import "menuViewController.h"
#import "RecoadListViewController.h"
#import "VideoModel.h"
#import "SMAVPlayerViewController.h"
@interface menuViewController ()
@property(nonatomic, assign) NSInteger selectIndex;
@property(nonatomic, strong) NSMutableArray *dDataSourse;

@property(nonatomic, strong) NSMutableArray *currentDatasourse;
@end
@implementation menuViewController
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                       NSUserDomainMask, YES);
  NSString *path = [paths objectAtIndex:0];
  NSString *filename = [path stringByAppendingPathComponent:@"story.plist"];
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSMutableArray *array;
  if (![fileManager fileExistsAtPath:filename]) {
    array = [[NSMutableArray alloc] init];
  } else {
    array = [[NSMutableArray alloc] initWithContentsOfFile:filename];
  }
  self.dDataSourse = [[NSMutableArray alloc] init];
  if (array.count) {
    for (NSDictionary *strname in array) {
      NSString *plistPath =
          [[NSBundle mainBundle] pathForResource:@"story" ofType:@"plist"];
      NSMutableArray *data =
          [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
      NSDictionary *dic = data[0];
      StoryModel *model = [[StoryModel alloc] init];
      model.thumb = [strname objectForKey:@"thumb"];
      model.localID = [dic objectForKey:@"id"];
      model.itemArray =
          [NSMutableArray arrayWithArray:[dic objectForKey:@"section"]];
      model.videoUrl = [strname objectForKey:@"storyName"];
      model.title = [[strname objectForKey:@"title"] stringByAppendingString:[strname objectForKey:@"storyName"]];
      model.ifDesk = YES;
        [self.dDataSourse addObject:model];
    }
  }

  [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidLoad {
  NSString *plistPath =
      [[NSBundle mainBundle] pathForResource:@"story" ofType:@"plist"];
  NSMutableArray *data =
      [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
  self.dataSource = [[NSMutableArray alloc] init];

  self.view.clipsToBounds = YES;
  self.view.layer.cornerRadius = CornerRadius;
  self.view.backgroundColor = [UIColor blackColor];
  for (NSDictionary *dic in data) {
    StoryModel *model = [[StoryModel alloc] init];
    model.thumb = [dic objectForKey:@"thumb"];
    model.localID = [dic objectForKey:@"id"];
    model.itemArray =
        [NSMutableArray arrayWithArray:[dic objectForKey:@"section"]];
    model.videoUrl = [dic objectForKey:@"video"];
    model.title = [dic objectForKey:@"title"];
    [self.dataSource addObject:model];
  }
  self.currentDatasourse = [NSMutableArray arrayWithArray:self.dataSource];
  NSArray *segmentedArray =
      [[NSArray alloc] initWithObjects:@"看戏", @"空镜", @"脚本", @"工作台", @"片酬", nil];
  //初始化UISegmentedControl
  UISegmentedControl *segmentedControl =
      [[UISegmentedControl alloc] initWithItems:segmentedArray];
  segmentedControl.frame =
      CGRectMake(0, 0, self.view.frame.size.width - 80, 30);
  // 设置默认选择项索引
  segmentedControl.selectedSegmentIndex = 0;
  _selectIndex = 0;
  segmentedControl.tintColor = [UIColor whiteColor];
  [segmentedControl addTarget:self
                       action:@selector(didClicksegmentedControlAction:)
             forControlEvents:UIControlEventValueChanged];
  [self.view addSubview:segmentedControl];
  [self.view addSubview:self.tableView];
    [self setExtraCellLineHidden:self.tableView];
  UIButton *backButton =
      [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-40, 0, 30, 30)];
  [backButton setBackgroundImage:[UIImage imageNamed:@"back_button"]
              forState:UIControlStateNormal];
  [self.view addSubview:backButton];
  [backButton addTarget:self
                 action:@selector(playButtonPressed:)
       forControlEvents:UIControlEventTouchUpInside];
}

- (void)playButtonPressed:(UIButton *)btn {
    NSMutableArray *arrVedio = [NSMutableArray array];
    for (StoryModel *model  in self.dDataSourse) {
        VideoModel *vedioModel = [[VideoModel alloc] init];
        vedioModel.strURL = model.videoUrl;
        vedioModel.vedioType = 2;
        vedioModel.strUserID = @"1";
        [arrVedio addObject:vedioModel];
    }
    VideoModel *videoModel = [[VideoModel alloc] init];
            videoModel.strURL =@"story1";
            videoModel.strTitle = @"玉髓究竟怎么玩";
                videoModel.vedioType = 1;
    videoModel.strUserID = @"1";
    [arrVedio insertObject:videoModel atIndex:0];
    _playerViewController.arrVedio = arrVedio;
    
   [self.navigationController popViewControllerAnimated:YES];
}

- (TPKeyboardAvoidingTableView *)tableView {
  if (!_tableView) {
    TPKeyboardAvoidingTableView *tableView =
        [[TPKeyboardAvoidingTableView alloc]
            initWithFrame:CGRectMake(0, 30, ScreenWidth, ScreenHeight)
                    style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    _tableView = tableView;
  }

  return _tableView;
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return self.currentDatasourse.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//提交编辑状态
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        NSArray*paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString*path=[paths  objectAtIndex:0];
        NSString *filename=[path stringByAppendingPathComponent:@"story.plist"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSMutableArray *array;
        if (![fileManager fileExistsAtPath:filename]) {
            array =[[NSMutableArray alloc]init];
        }else{
            array=[[NSMutableArray alloc]initWithContentsOfFile:filename];
        }
        
        [array removeObjectAtIndex:indexPath.row];
        [array writeToFile:filename atomically:YES];
        [self.currentDatasourse removeObjectAtIndex:indexPath.row];
        [self.dDataSourse removeObjectAtIndex:indexPath.row];
        //第一个参数为要删除的行
        //第二个参数为删除是的动画
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationMiddle];
    }
}
//返回指定行或者指定区域的编辑状态
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectIndex==3) {
        return UITableViewCellEditingStyleDelete;
    }
    else
    {
        return UITableViewCellEditingStyleNone;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  StoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"111"];
  if (cell == nil) {
    cell = [[StoryCell alloc] initWithStyle:UITableViewCellStyleDefault
                            reuseIdentifier:@"111"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.Delegate = self;
  }
  StoryModel *model = [self.currentDatasourse objectAtIndex:indexPath.row];
  [cell configCellWithModel:model];
  return cell;
}
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    StoryModel *model = [self.currentDatasourse objectAtIndex:indexPath.row];

    if (_selectIndex==3) {
        //预制视频
        SMAVPlayerViewController *playerVC = [[SMAVPlayerViewController alloc]
                                              initWithNibName:@"SMAVPlayerViewController"
                                              bundle:nil];
        NSMutableArray *arrVedio = [NSMutableArray array];
        VideoModel *vedioModel = [[VideoModel alloc] init];
        vedioModel.strURL = model.videoUrl;
        vedioModel.vedioType = 2;
        vedioModel.strUserID = @"1";
        [arrVedio addObject:vedioModel];
        playerVC.arrVedio = arrVedio;
        [self presentViewController:playerVC animated:YES completion:nil];
  
    }
}
- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 100.0f;
}

- (void)videorecordButtonDidSelected:(StoryCell *)cell {
  RecoadListViewController *controller =
      [[RecoadListViewController alloc] init];
  controller.datasoure = cell.model.itemArray;
    controller.storyModel=cell.model;
  [self.navigationController pushViewController:controller animated:YES];
}

- (void)videoPreviewButtonDidSelected:(StoryCell*)cell{
    //预制视频
    SMAVPlayerViewController *playerVC = [[SMAVPlayerViewController alloc]
                                          initWithNibName:@"SMAVPlayerViewController"
                                          bundle:nil];
    NSMutableArray *arrVedio = [NSMutableArray array];
    VideoModel *vedioModel = [[VideoModel alloc] init];
    vedioModel.strURL = cell.model.videoUrl;
    if (_selectIndex==3) {

    vedioModel.vedioType = 2;
    }else{
        vedioModel.vedioType = 1;
    }
    vedioModel.strUserID = @"1";
    [arrVedio addObject:vedioModel];
    playerVC.arrVedio = arrVedio;
    [self presentViewController:playerVC animated:YES completion:nil];
}


- (void)didClicksegmentedControlAction:(UISegmentedControl *)Seg {
  NSInteger Index = Seg.selectedSegmentIndex;
  //判断rootView是有已经有页面，如果有，应为删掉该页面然后在添加新页面
  if (Index == _selectIndex) {
  } else {
      _selectIndex=Index;
    switch (Index) {
      case 0: {
          self.currentDatasourse = [NSMutableArray arrayWithArray:self.dataSource];
        [self.tableView reloadData];
      }

      break;
      case 1:

        break;
      case 2:

        break;
      case 3: {
          self.currentDatasourse = [NSMutableArray arrayWithArray:self.dDataSourse];
        [self.tableView reloadData];
      }

      break;
      default:
        break;
    }
  }
}

@end
