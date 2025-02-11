//
//  SceneDelegate.m
//  shuwen-ios
//
//  Created by shuwen on 2024/11/15.
//

#import "SceneDelegate.h"

@interface SceneDelegate ()
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    if ([scene isKindOfClass:[UIWindowScene class]]) {
            UIWindowScene *windowScene = (UIWindowScene *)scene;
            self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
            self.window.frame = windowScene.coordinateSpace.bounds;

            // 创建一个 UILabel 用于显示 "Hello"
            UILabel *helloLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
            helloLabel.text = @"shuwen";
            helloLabel.textAlignment = NSTextAlignmentCenter;
            helloLabel.center = self.window.center;

            // 设置视图控制器和窗口的根视图
            UIViewController *rootViewController = [[UIViewController alloc] init];
            [rootViewController.view addSubview:helloLabel];
            rootViewController.view.backgroundColor = [UIColor whiteColor];
            self.window.rootViewController = rootViewController;
            
            [self.window makeKeyAndVisible];
            
            [self loadAndPlayVideo];
        }
}

- (void)loadAndPlayVideo {
    NSString *baseURL = @"http://39.107.59.4:8080"; // 替换为你的服务器地址
    NSString *urlString = [NSString stringWithFormat:@"%@/getVideo", baseURL];
    NSURL *videoURL = [NSURL URLWithString:urlString];

    if (!videoURL) {
           NSLog(@"无效的视频 URL: %@", urlString);
           return;
    }
    
    self.player = [AVPlayer playerWithURL:videoURL];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = CGRectMake(0, 100, self.window.frame.size.width, 300); // 设置视频播放区域

    UIViewController *rootViewController = self.window.rootViewController;
    [rootViewController.view.layer addSublayer:self.playerLayer];

    [self.player play];
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}

// Method to fetch user from /getUser
- (void)fetchUserWithCompletion:(void (^)(NSString *userName, NSError *error))completion {
    NSString *baseURL = @"http://39.107.59.4:8080"; // Replace with your server address
    NSString *urlString = [NSString stringWithFormat:@"%@/getUser", baseURL];
    NSURL *url = [NSURL URLWithString:urlString];

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        if (data) {
            NSError *jsonError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (jsonError) {
                completion(nil, jsonError);
                return;
            }
            NSString *userName = json[@"name"]; // Adjust based on the API's response structure
            completion(userName, nil);
        } else {
            completion(nil, [NSError errorWithDomain:@"ServerError" code:500 userInfo:@{NSLocalizedDescriptionKey: @"No data returned"}]);
        }
    }];
    [task resume];
}


@end
