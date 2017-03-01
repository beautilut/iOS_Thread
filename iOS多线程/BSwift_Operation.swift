//
//  BSwift_Operation.swift
//  iOS多线程
//
//  Created by Beautilut on 2017/3/1.
//  Copyright © 2017年 ___Beautilut___. All rights reserved.
//

import UIKit
import Foundation

class BSwift_Operation: NSObject {
    
    func blockOperation() {
        
        let operation = BlockOperation { () -> Void in
            
        }
        
        operation.start()
        
    }

    func AddBlockOperation() {

        let operation = BlockOperation {() -> Void in

        }

        for i in 0..<5 {
            operation.addExecutionBlock { () -> Void in
            }
        }

        operation.start()
    }

    func Operation_Queue() {
        let mainQueue = OperationQueue.main

        let queue = OperationQueue()

        let operation = BlockOperation { () -> Void in

        }

        for i in 0..<5 {
            operation.addExecutionBlock { () -> Void in
            }
        }
        queue.addOperation(operation)
    }

    func OperationDepend() {
        let operation1 = BlockOperation{ () -> Void in
            Thread.sleep(forTimeInterval: 1.0)
        }

        let operation2 = BlockOperation{ () -> Void in
            Thread.sleep(forTimeInterval: 1.0)
        }

        let operation3 = BlockOperation{ () -> Void in
            Thread.sleep(forTimeInterval: 1.0)
        }

        operation2.addDependency(operation1)
        operation3.addDependency(operation2)

        let queue = OperationQueue()
        queue.addOperations([operation3,operation2,operation1], waitUntilFinished: false)

    }

    func OperationOther () {

        let operation = BlockOperation { () -> Void in

        }

        operation.isExecuting //是否在执行

        operation.isFinished //任务是否完成

        //设置完成后需要执行的操作
        operation.completionBlock = { () -> Void in
        }

        operation.cancel() //取消任务

        operation.waitUntilFinished() //阻塞当前线程知道此任务执行完成
        

        let queue = OperationQueue.main

        queue.operationCount //获取队列的任务数

        queue.isSuspended = true //暂停
        
        queue.isSuspended = false //继续

        //互斥锁
        objc_sync_enter(self)
        objc_sync_exit(self)

    }

}
