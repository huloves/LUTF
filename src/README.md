# 4-Xiyou-LUG

#### 介绍
TOPIC_ID:4, TEAM_ID:1382578369, TEAM_NAME:Xiyou-LUG.

#### 项目背景

该项目是实现一个Linux用户态下抢占式任务调度框架，原生的Linux是支持多任务的，但是由于是内核统一管理，所以任务的粒度都是内核所固定的。这在一些数据处理相关联的场景下，就需要对任务支持的粒度更加细化，来更好的处理这些任务CPU密集型的任务，避免内核态下任务的频繁切换。所以提出一种Linux用户态下多任务的想法，对比目前的协程的优势和不足，我们打算设计出内嵌在OS中的负责任务调度的小OS。

#### 软件架构

##### 模拟中断模块
底层使用信号模拟中断。任务的抢占点信号使用时钟信号，时钟周期为10ms。信号处理函数的栈中保存有用户态的上下文sigcontext，并且该栈存储在用户态，我们就可以通过保存和修改该上下文中的内容来实现上下文切换。

##### 多任务调度模块
初始化每个任务时为任务指定优先级，即时间片大小。信号处理函数中检查当前任务的时间片，不为0时，将当前任务的时间片减一并返回；若为0，就去执行schedule函数，该函数中首先修改任务的状态，然后找到下一个要调度运行的任务，并进行上下文切换。修改后返回，即信号处理函数调用sigreturn系统调用返回到内核态，内核根据sigcontext的内容恢复用户态任务的上下文。

#### 安装教程

1.  git clone https://github.com/Xiyou-LUG/src.git
2.  cd src/
3.  make all

>make all后生成libtask.a库文件，编译程序时在后加上该和-I ./include/库即可。

#### 使用说明

初始化任务框架 

init();

创建任务

struct task_struct* task_start(char* name, int prio, task_func function, void* func_arg);

输出 - 未hook现有的输出函数

详见console.h

创建任务示例 - 创建100w个任务，并执行。
由于在任务创建函数中将终端屏蔽，即忽略时钟信号，以保证任务就绪链表同步，同时信号处理函数的周期为10ms，所以在创建100w个任务时会消耗较长的时间，稍微等待即可。
```c
#include "task.h"
#include "console.h"
#include "init.h"
#include <stdio.h>
#include <unistd.h>

void test1(void* args)
{
    char* str = args;
    while(1) {
        sleep(1);
        console_put_str(str);
    }
}

int main()
{
    init();
    task_start("tast1", 31, test1, "argB ");
    for(int i = 0; i < 1000000; i++) {
        task_start("abc", 31, test1, "a ");
    }
    while(1) {
        sleep(1);
        console_put_str("maiN ");
    }
    return 0;
}
```
```bash
工作目录：src/
编译链接：gcc main.c -o main -I include/ libtask.a
运行：./main
```

#### 参与贡献

1.  Fork 本仓库
2.  新建 Feat_xxx 分支
3.  提交代码
4.  新建 Pull Request
