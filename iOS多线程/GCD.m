//
// Created by Beautilut on 2017/2/27.
// Copyright (c) 2017 ___Beautilut___. All rights reserved.
//

#import "GCD.h"


@implementation GCD {

}


-(void)GCD_async {
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{

        //一个异步任务 ， 例如网络请求 ， 耗时文件操作。

        dispatch_async(dispatch_get_main_queue(), ^{
            //UI 刷新
        });
    });
}

-(void)GCD_after {
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), queue, ^{
        //在queue里面延迟执行的一段代码
    });
}

-(void)GCD_once {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //只执行一次的任务
    });
}

-(void)GCD_group {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();

    dispatch_group_async(group, queue, ^{
        //异步任务1
    });

    dispatch_group_async(group, queue, ^{
        //异步任务2
    });
//不建议使用 会卡住当前线程
//    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);

    dispatch_group_notify(group, queue, ^{
        //任务完成后 ， 在主队列中做一些操作

    });
}

-(void)GCD_barrier_async {
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        //任务1 在任务3前执行
    });

    dispatch_async(queue, ^{
        //任务2 在任务3前执行
    });

    dispatch_barrier_async(queue, ^{
        //任务3
    });

    dispatch_async(queue, ^{
        //任务4 在任务3后执行
    });

    dispatch_async(queue, ^{
        //任务5 在任务3后执行
    });
}

-(void)GCD_apply {

    //循环10次
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_apply(10, queue, ^(size_t index){
        NSLog(@"%zu" , index);
    });
}

-(void)GCD_control {
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_suspend(queue); //暂停队列
    dispatch_resume(queue); //恢复队列
}

-(void)dispatch_signal {
    //信号控制，如果semaphore为0 则停止等待信号。
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore1 = dispatch_semaphore_create(1);
    dispatch_semaphore_t semaphore2 = dispatch_semaphore_create(0);
    dispatch_semaphore_t semaphore3 = dispatch_semaphore_create(0);

    dispatch_async(queue, ^{
        dispatch_semaphore_wait(semaphore1, DISPATCH_TIME_FOREVER);
        NSLog(@"1");
        dispatch_semaphore_signal(semaphore2);
        dispatch_semaphore_signal(semaphore3);
    });

    dispatch_async(queue, ^{
        dispatch_semaphore_wait(semaphore2, DISPATCH_TIME_FOREVER);
        NSLog(@"2");
        dispatch_semaphore_signal(semaphore3);
        dispatch_semaphore_signal(semaphore2);
    });

    dispatch_async(queue, ^{
        dispatch_semaphore_wait(semaphore3, DISPATCH_TIME_FOREVER);
        NSLog(@"3");
        dispatch_semaphore_signal(semaphore3);
    });

    //例2 创建10个线程
    {
        dispatch_queue_t queue2 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(10);
        for (int i = 0; i < 100; i++) {
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            dispatch_async(queue, ^{

                dispatch_semaphore_signal(semaphore);
            });

        }
    }
}

-(void)GCD_other {

    //串行队列
    dispatch_queue_t queue1 = dispatch_queue_create("queue1", NULL);
    dispatch_queue_t queue2 = dispatch_queue_create("queue2", DISPATCH_QUEUE_SERIAL);
    //并行队列
    dispatch_queue_t queue3 = dispatch_queue_create("queue3", DISPATCH_QUEUE_CONCURRENT);

}

@end