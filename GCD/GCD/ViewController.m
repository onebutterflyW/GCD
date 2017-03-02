//
//  ViewController.m
//  GCD
//
//  Created by 软件工程系01 on 17/3/1.
//  Copyright © 2017年 软件工程系01. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   

//dispatch_after的使用
//    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 3ull*NSEC_PER_SEC);
//    
//    dispatch_after(time, dispatch_get_main_queue(), ^{
//        NSLog(@"使用dispatch_after,3秒后追加操作");
//    });
    
 
   
    
    [self dispatchapply];
    
    
    
    
    
    
    
    
    
    
    
//    dispatch semaphore使用
//    //dispatch_queue_t queue = dispatch_queue_create("wwantong.ysu.GCD", DISPATCH_QUEUE_SERIAL);
//    dispatch_queue_t ConQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_semaphore_t semap = dispatch_semaphore_create(10);
//    
//    NSMutableArray  *arr = [[NSMutableArray alloc]init];
//    
//    for (int i = 0 ; i < 20; i ++) {
//        dispatch_semaphore_wait(semap, DISPATCH_TIME_FOREVER);
//        dispatch_async(ConQueue, ^{
//            NSLog(@"%@",[NSThread currentThread]);
//            [arr addObject:[NSNumber numberWithInt:i]];
//            dispatch_semaphore_signal(semap);
//    
//        });
//        
//    }


}

-(void)blockIntroduced
{
    //队列一般就是系统的主队列和全局队列还有自己手动创建的串行队列和并行队列
    dispatch_queue_t chuanxingduilie = dispatch_queue_create("chuanxingduilie", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t bingxingduilie = dispatch_queue_create("bingxingduilie", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    
    //方法有两个  dispatch_sync 和 dispatch_async  dispatch_async方法是立刻返回的，也就是说把block内容加到相应队列里后会立马返回，而dispatch_sync要等到加到队列里执行完之后才会返回。
    //这时候总共有2*4 = 8种组合，接下来我们来说一下这八种组合
    
    
    //一：
    for(int i=0;i<3;i++){
        dispatch_sync(chuanxingduilie, ^{
            NSLog(@"dispatch_sync-chuanxingduilie-%d\n mainThread:%@",i,[NSThread currentThread]);
        });
    }
    /*
     2016-02-05 21:07:12.622 GcdTest[7229:164997] dispatch_sync-chuanxingduilie-0
     mainThread:<NSThread: 0x7fad93407dd0>{number = 1, name = main}
     2016-02-05 21:07:12.623 GcdTest[7229:164997] dispatch_sync-chuanxingduilie-1
     mainThread:<NSThread: 0x7fad93407dd0>{number = 1, name = main}
     2016-02-05 21:07:12.623 GcdTest[7229:164997] dispatch_sync-chuanxingduilie-2
     mainThread:<NSThread: 0x7fad93407dd0>{number = 1, name = main}
     
     */
    //第一种方式可见，串行队列是在主线程里完成的，因为是串行队列，所以打印%d是有顺序的。
    
    //二：
    for(int i=0;i<3;i++){
        dispatch_sync(bingxingduilie, ^{
            
            NSLog(@"dispatch_sync-bingxingduilie-%d\n mainThread:%@",i,[NSThread currentThread]);
            
        });
    }
    /*
     2016-02-05 21:09:26.422 GcdTest[7241:165846] dispatch_sync-bingxingduilie-0
     mainThread:<NSThread: 0x7face9d01d20>{number = 1, name = main}
     2016-02-05 21:09:26.422 GcdTest[7241:165846] dispatch_sync-bingxingduilie-1
     mainThread:<NSThread: 0x7face9d01d20>{number = 1, name = main}
     2016-02-05 21:09:26.422 GcdTest[7241:165846] dispatch_sync-bingxingduilie-2
     mainThread:<NSThread: 0x7face9d01d20>{number = 1, name = main}
     
     */
    //第二种方式可以发现同样还是在主线程里执行并行队列，(虽然是并行队列，但这时候依然在同一个线程里执行)
    
    //三：
    /*
     for(int i=0;i<3;i++){
     NSLog(@"dispatch_sync-mainQueue");
     dispatch_sync(mainQueue, ^{
     
     NSLog(@"dispatch_sync-mainQueue-%d\n mainThread:%@",i,[NSThread currentThread]);
     
     });
     }
     //打印结果：dispatch_sync-mainQueue，发现主线程被堵塞。原因在堵塞中分析。此种方式暂时先屏蔽掉
     */
    
    //四：
    for(int i=0;i<3;i++){
        dispatch_sync(globalQueue, ^{
            
            NSLog(@"dispatch_sync-globalQueue-%d\n mainThread:%@",i,[NSThread currentThread]);
            
        });
    }
    /*
     2016-02-05 21:22:41.107 GcdTest[7338:172870] dispatch_sync-globalQueue-0
     mainThread:<NSThread: 0x7feadad050b0>{number = 1, name = main}
     2016-02-05 21:22:41.107 GcdTest[7338:172870] dispatch_sync-globalQueue-1
     mainThread:<NSThread: 0x7feadad050b0>{number = 1, name = main}
     2016-02-05 21:22:41.107 GcdTest[7338:172870] dispatch_sync-globalQueue-2
     mainThread:<NSThread: 0x7feadad050b0>{number = 1, name = main}
     */
    //打印结果可以看出依然是主线程。
    
    //五：
    for (int i=0; i<3; i++) {
        dispatch_async(chuanxingduilie, ^{
            if (i==1) {
                sleep(2);
            }
            NSLog(@"dispatch_async-chuanxingduilie-%d\n Thread:%@",i,[NSThread currentThread]);
        });
    }
    /*
     2016-02-05 22:32:14.957 GcdTest[7499:191789] dispatch_async-chuanxingduilie-0
     Thread:<NSThread: 0x7fd7eaf10c70>{number = 3, name = (null)}
     2016-02-05 22:32:16.962 GcdTest[7499:191789] dispatch_async-chuanxingduilie-1
     Thread:<NSThread: 0x7fd7eaf10c70>{number = 3, name = (null)}
     2016-02-05 22:32:16.963 GcdTest[7499:191789] dispatch_async-chuanxingduilie-2
     Thread:<NSThread: 0x7fd7eaf10c70>{number = 3, name = (null)}
     */
    //可以看出创建了一个线程， 在串行队列里串行执行的
    
    
    //六：
    for (int i=0; i<3; i++) {
        dispatch_async(bingxingduilie, ^{
            if (i==1) {
                sleep(3);
            }
            NSLog(@"dispatch_async-bingxingduilie-%d\n Thread:%@",i,[NSThread currentThread]);
        });
    }
    /*
     2016-02-05 22:10:07.083 GcdTest[7425:184003] dispatch_async-bingxingduilie-2
     Thread:<NSThread: 0x7fcda24bcd00>{number = 4, name = (null)}
     2016-02-05 22:10:07.083 GcdTest[7425:183982] dispatch_async-bingxingduilie-0
     Thread:<NSThread: 0x7fcda2502310>{number = 3, name = (null)}
     2016-02-05 22:10:10.083 GcdTest[7425:184002] dispatch_async-bingxingduilie-1
     Thread:<NSThread: 0x7fcda2436180>{number = 5, name = (null)}
     */
    //分析可以看出创建了多个线程，任务执行顺序不一定（时间差不多的话）
    
    
    //七：
    for (int i=0; i<3; i++) {
        dispatch_async(mainQueue, ^{
            if (i==1) {
                sleep(3);
            }
            NSLog(@"dispatch_async-mainQueue-%d\n Thread:%@",i,[NSThread currentThread]);
        });
    }
    /*
     Thread:<NSThread: 0x7fbb28704510>{number = 5, name = (null)}
     2016-02-05 22:15:03.709 GcdTest[7460:186485] dispatch_async-mainQueue-0
     Thread:<NSThread: 0x7fbb28703fb0>{number = 1, name = main}
     2016-02-05 22:15:06.710 GcdTest[7460:186485] dispatch_async-mainQueue-1
     Thread:<NSThread: 0x7fbb28703fb0>{number = 1, name = main}
     2016-02-05 22:15:06.710 GcdTest[7460:186485] dispatch_async-mainQueue-2
     Thread:<NSThread: 0x7fbb28703fb0>{number = 1, name = main}
     */
    
    //可以看出这种情况还是在当前线程环境中执行，并不创建线程，因为是在主队列里，顺序执行
    
    //八：
    for (int i=0; i<3; i++) {
        dispatch_async(globalQueue, ^{
            
            NSLog(@"dispatch_async-globalQueue-%d\n Thread:%@",i,[NSThread currentThread]);
        });
    }
    /*
     2016-02-05 22:17:58.306 GcdTest[7482:188067] dispatch_async-globalQueue-1
     Thread:<NSThread: 0x7fa281e24580>{number = 4, name = (null)}
     2016-02-05 22:17:58.306 GcdTest[7482:188099] dispatch_async-globalQueue-2
     Thread:<NSThread: 0x7fa281e321c0>{number = 5, name = (null)}
     2016-02-05 22:17:58.307 GcdTest[7482:188069] dispatch_async-globalQueue-0
     Thread:<NSThread: 0x7fa281e262b0>{number = 3, name = (null)}
     */
    //可以看出创建了多个线程，执行顺序并不一定
    
}

-(void)changePriority{


      dispatch_queue_t myConcurrenthigh = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
      dispatch_queue_t myConcurrentlow= dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    
    dispatch_async(myConcurrenthigh, ^{
        
        NSLog(@"线程：%@",[NSThread currentThread]);
        NSLog(@"交换前myConcurrenthigh的输出");
    });
    dispatch_async(myConcurrentlow, ^{
        NSLog(@"交换前线程：%@",[NSThread currentThread]);
        NSLog(@"交换前myConcurrentlow的输出");
    });
    
    
    dispatch_set_target_queue(myConcurrenthigh, myConcurrentlow);
    
    
    
    dispatch_async(myConcurrenthigh, ^{
        NSLog(@"线程：%@",[NSThread currentThread]);
        NSLog(@"交换后myConcurrenthigh的输出");
    });
    
    dispatch_async(myConcurrentlow, ^{
        NSLog(@"线程：%@",[NSThread currentThread]);
        NSLog(@"交换后myConcurrentlow的输出");
    });
   


}


-(void)serialChangeChuan{

    dispatch_queue_t targetQueue = dispatch_queue_create("test.target.queue", NULL);
    
    
    dispatch_queue_t queue1 = dispatch_queue_create("test1", NULL);
    dispatch_queue_t queue2 = dispatch_queue_create("test2", NULL);
    dispatch_queue_t queue3 = dispatch_queue_create("test3", NULL);
    
    
    dispatch_set_target_queue(queue1, targetQueue);
    dispatch_set_target_queue(queue2, targetQueue);
    dispatch_set_target_queue(queue3, targetQueue);
    
    

    dispatch_async(queue1, ^{
        NSLog(@"queue1 in");
        sleep(1);
        NSLog(@"queue1 out");
    });
    
    dispatch_async(queue2, ^{
        NSLog(@"queue2 in");
        sleep(1);
        NSLog(@"queue2 out");
    });
    
    dispatch_async(queue3, ^{
        NSLog(@"queue3 in");
        sleep(1);
        NSLog(@"queue3 out");
    });


}

-(void)barrierasync{


     //dispatch_barrier_async
     dispatch_queue_t concurrentQueue = dispatch_queue_create("com.GCD.www", DISPATCH_QUEUE_CONCURRENT);
     dispatch_async(concurrentQueue, ^(){
     NSLog(@"dispatch-1");
     });
     dispatch_async(concurrentQueue, ^(){
     NSLog(@"dispatch-2");
     });
     dispatch_barrier_async(concurrentQueue, ^(){
     NSLog(@"dispatch-barrier");
     });
     dispatch_async(concurrentQueue, ^(){
     NSLog(@"dispatch-3");
     });
     dispatch_async(concurrentQueue, ^(){
     NSLog(@"dispatch-4");
     });
     dispatch_async(concurrentQueue, ^(){
     NSLog(@"dispatch-5");
     });
 

}


-(void)dipatchgroup{

    /*dispatch_group_notify
     dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
     dispatch_group_t group = dispatch_group_create();
     
     dispatch_group_async(group, queue, ^{NSLog(@"blk0");});
     dispatch_group_async(group, queue, ^{NSLog(@"blk1");});
     dispatch_group_async(group, queue, ^{NSLog(@"blk2");});
     
     
     dispatch_group_notify(group, queue, ^{
     NSLog(@"done");
     });
     */
    
    
    //dispatch_group_wait
     dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
     dispatch_group_t group = dispatch_group_create();
     
     dispatch_group_async(group, queue, ^{NSLog(@"blk0");});
     dispatch_group_async(group, queue, ^{
     for (int i = 0; i < 400; i ++) {
     
     NSLog(@"blk1");
     }
     });
     dispatch_group_async(group, queue, ^{NSLog(@"blk2");});
     
     dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1ull*NSEC_PER_SEC);
     long result  = dispatch_group_wait(group, time);
     
     
     if (result == 0) {
     
     NSLog(@" dispatch_group_wait==0:%@",[NSThread currentThread]);
     
     }else{
     
     NSLog(@" dispatch_group_wait!=0:%@",[NSThread currentThread]);
     
     }


}


-(void)dispatchapply{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_apply(10, queue, ^(size_t index) {
        NSLog(@"%zu",index);
    });
    NSLog(@"done");
    
    
    
    
    
/*dispatch group实现dispatch_apply
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_t group = dispatch_group_create();
    
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"1");
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"2");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"3");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"4");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"5");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"6");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"7");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"8");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"9");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"10");
    });
    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"done");
    });
/*
 输出
 2017-03-02 13:25:53.679 GCD[1108:817573] 3
 2017-03-02 13:25:53.679 GCD[1108:817580] 1
 2017-03-02 13:25:53.679 GCD[1108:817586] 2
 2017-03-02 13:25:53.679 GCD[1108:817608] 4
 2017-03-02 13:25:53.679 GCD[1108:817609] 5
 2017-03-02 13:25:53.679 GCD[1108:817573] 6
 2017-03-02 13:25:53.680 GCD[1108:817580] 7
 2017-03-02 13:25:53.680 GCD[1108:817586] 8
 2017-03-02 13:25:53.680 GCD[1108:817608] 9
 2017-03-02 13:25:53.680 GCD[1108:817609] 10
 2017-03-02 13:25:53.682 GCD[1108:816657] done
 */

}


@end
