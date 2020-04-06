%hook NSFileManager
- (NSArray *)contentsOfDirectoryAtPath:(NSString *)path error:(NSError **)error
{
    
   	if([path containsString:@"/Library/MobileSubstrate/DynamicLibraries/"]
    	|| [path containsString:@"/Library/Application Support/Supercharge"]
    		|| [path containsString:@"/Library/Application Support/Flex3"])
    {
        path = @"/Library/";
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

    if([path containsString:@"/Library/MobileSubstrate/DynamicLibraries/"]
    	|| [path containsString:@"/Library/Application Support/Supercharge"]
    		|| [path containsString:@"/Library/Application Support/Flex3"])
    {
        path = @"/Library/";
    }

    %log;
    return %orig;
}

%end


