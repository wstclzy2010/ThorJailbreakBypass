# ThorJailbreakBypass
屏蔽锤子的越狱检测

---
WHAT：
* 越狱环境开启App会提示

* 然后卸载应用重新安装后试图利用liberty lite和flyjb等一众屏蔽越狱检测插件去屏蔽，发现没什么用处，反而还导致了程序直接退出，连提示都不显示了。
* 听说OC程序的强制退出常用的是exit函数，就从这里去找

* 使用 xia0LLDB以后台模式启动并砸壳
```
debugserver -x backboard 127.0.0.1:2345 /var/containers/Bundle/Application/XXXXX
lldb
process connect connect://localhost:2345
dumpdecrypted -X
```
* 拖入ida，搜索exit，拿到地址0x1002A0128


* 在c1c000+1002A0128处下断点
```
(lldb) image list -o -f
[  0] 0x0000000000c1c000 /private/var/containers/Bundle/Application/EFF4BF92-B90F-42E8-AFBA-BB3DF06BAD31/Thor.app/Thor(0x0000000100c1c000)
[  1] 0x0000000101358000 /Library/Caches/cy-QRU7f0.dylib(0x0000000101358000)
(lldb) b 0x100EBC128
Breakpoint 1: where = Thor`symbol stub for: exit + 4, address = 0x0000000100ebc128
(lldb) c
Process 3099 resuming
2020-03-24 18:16:21.175 Thor[3099:107162] Hit loading Liberty Lite into com.pixelcyber.dake.thor - (C) Ryley Angus, 2016-19. No warranty provided.
Process 3099 stopped
* thread #1, queue = 'com.apple.main-thread', stop reason = breakpoint 1.1
    frame #0: 0x0000000100ebc128 Thor`exit + 4
Thor`exit:
->  0x100ebc128 <+4>: ldr    x16, #0x65058             ; (void *)0x0000000100ebce8c
    0x100ebc12c <+8>: br     x16

Thor`fclose:
    0x100ebc130 <+0>: nop    
    0x100ebc134 <+4>: ldr    x16, #0x65054             ; (void *)0x0000000100ebce98
    0x100ebc138 <+8>: br     x16

Thor`feof:
    0x100ebc13c <+0>: nop    
    0x100ebc140 <+4>: ldr    x16, #0x65050             ; (void *)0x0000000100ebcea4
    0x100ebc144 <+8>: br     x16
Target 0: (Thor) stopped.
```
* 程序成功断住，说明断点正确，查看栈信息
```
(lldb) bt
* thread #1, queue = 'com.apple.main-thread', stop reason = breakpoint 1.1
  * frame #0: 0x0000000100ebc128 Thor`exit + 4
    frame #1: 0x0000000100c277b8 Thor`___lldb_unnamed_symbol37$$Thor + 7628
    frame #2: 0x00000001c80668e0 libdyld.dylib`start + 4
```
* 得到地址0x100c277b8，100c277b8减去c1c000=10000B7B8应该就是想要的函数所在地址
* 去ida中搜索10000B7B8

* F5看下伪代码，结果碰到 positive sp value has been found。
* 在ida-general中打开stack pointer，在0x10000B7B8处option+K，修改其difference值为0。
* 成功显示伪代码



很明显的，他是通过判断越狱所特有的文件路径、目录来检测越狱的，结合搜索引擎，大概用到了这些方法，给这些方法分别%log，查看控制台的输出内容：
```
+ (NSURL *)fileURLWithPath:(NSString *)path;

- (NSArray<NSString *> *)contentsOfDirectoryAtPath:(NSString *)path error:(NSError * _Nullable *)error;
```
```
%hook NSFileManager
- (NSArray *)contentsOfDirectoryAtPath:(NSString *)path error:(NSError **)error{
    %log;
    return %orig;
}

- (BOOL)fileExistsAtPath:(NSString *)path isDirectory:(BOOL *)isDirectory{
    %log;
    return %orig;
}

- (NSArray *)subpathsOfDirectoryAtPath:(NSString *)path error:(NSError **)error{
    %log;
    return %orig;
}

%end

%hook NSURL

+ (NSURL *)fileURLWithPath:(NSString *)path{
    %log;
    return %orig;
}

%end
```



* 根据控制台的输出，明显的，他检测了这些目录和文件：
```
/Library/MobileSubstrate/DynamicLibraries
/Library/Application Support 
/User/Library/Application Support/Flex3
/User/Library/Application Support/Supercharge
/var/mobile/Library/UserConfiguration/Profiles/PublicInfo
```
* 那就一股脑全干掉
```
%hook NSFileManager
- (NSArray *)contentsOfDirectoryAtPath:(NSString *)path error:(NSError **)error
{
    
    if([path containsString:@"/Library/MobileSubstrate/DynamicLibraries"])
    {
        path = @"/Library/";
    }
    
    if([path containsString:@"/Library/Application Support/Supercharge"] ||
       [path containsString:@"/Library/Application Support/Flex3"] )
    {
        path = @"/var/";
    }

    if([path containsString:@"/var/mobile/Library/UserConfiguration/Profiles/PublicInfo/Flex3Patches.plist"])
    {
        path = @"/var/mobile/Library/";
    }

    %log;
    return %orig;
}
%end

%hook NSURL

+ (NSURL *)fileURLWithPath:(NSString *)path
{

    if([path containsString:@"/Library/MobileSubstrate/DynamicLibraries/"])
    {
        path = @"/Library/";
    }

    if([path containsString:@"/Library/Application Support/Supercharge"] ||
       [path containsString:@"/Library/Application Support/Flex3"] )
    {
        path = @"/var";
    }

    %log;
    return %orig;
}

%end
```
* 成功进入App，收工。
