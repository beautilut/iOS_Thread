//
// Created by Beautilut on 2017/2/28.
// Copyright (c) 2017 ___Beautilut___. All rights reserved.
//

#import "BOperation.h"


@implementation BOperation {

}

-(void)run{

}


-(void)invocation {
    NSInvocationOperation * operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run) object:nil];

    [operation start];
}

-(void)block  {
    NSBlockOperation * operation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"");
    }];
    [operation start];
}

-(void)blockAdd {
    NSBlockOperation * operation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"%@",[NSThread currentThread]);
    }];

    for (NSInteger i = 0 ; i < 5; i++) {
        [operation addExecutionBlock:^{
            NSLog(@"第 %ld 次 ： %@",i,[NSThread currentThread]);
        }];
    }

    // addExecutionBlock 必须在start前执行
    [operation start];
}

-(void)OperationQueue {
    NSOperationQueue * queue = [NSOperationQueue mainQueue];

    {
        //创建一个其他队列
        NSOperationQueue * queue = [[NSOperationQueue alloc] init];

        //创建NSBlockOperation 对象
        NSBlockOperation * operation = [NSBlockOperation blockOperationWithBlock:^{

        }];

        //添加多个Block
        for (NSInteger i = 0 ; i < 5 ; i++){
            [operation addExecutionBlock:^{

            }];
        }

        [queue addOperation:operation];
    }
}

-(void)OperationDependency {
    NSBlockOperation * operation1 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1.0];
    }];

    NSBlockOperation * operation2 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1.0];
    }];

    NSBlockOperation * operation3 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1.0];
    }];

    [operation2 addDependency:operation1];
    [operation3 addDependency:operation2];

    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    [queue addOperations:@[operation3,operation2,operation1] waitUntilFinished:NO];
}

-(void)OperationOther {
    NSBlockOperation * operation = [NSBlockOperation blockOperationWithBlock:^{

    }];

    operation.executing; //是否正在执行

    operation.finished; //是否完成

    //设置完成后需要执行的操作
    [operation setCompletionBlock:^{

    }];

    [operation cancel]; //取消任务

    [operation waitUntilFinished]; //阻塞当前线程直到此任务执行完毕


    NSOperationQueue * queue = [NSOperationQueue mainQueue];

    queue.operationCount; //获取队列的任务数量

    [queue cancelAllOperations]; //取消队列中的所有任务

    [queue waitUntilAllOperationsAreFinished]; //阻塞当前线程知道此队列中的所有任务执行完毕

    [queue setSuspended:YES]; //暂停队列

    [queue setSuspended:NO]; //继续队列

    //互斥锁 保护线程
    @synchronized (self) {
    }

}



@end
