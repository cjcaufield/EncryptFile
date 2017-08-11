#import <Foundation/Foundation.h>
#import "AQDataExtensions.h"

#define VALIDATE

int main(int argc, const char* argv[])
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init]; 
    
    if (argc != 4)
    {
        NSLog(@"Usage: EncryptFile <input-file> <output-file> <password>.\n");
        [pool release];
        return 1;
    }
    
    NSString* inputFileName  = [NSString stringWithUTF8String:argv[1]];
    NSString* outputFileName = [NSString stringWithUTF8String:argv[2]];
    NSString* password       = [NSString stringWithUTF8String:argv[3]];

    NSData* rawData = [NSData dataWithContentsOfFile:inputFileName];
    if (rawData == nil || [rawData length] == 0)
    {
        NSLog(@"Error reading from file %@.\n", inputFileName);
        [pool release];
        return 2;
    }
    
    NSData* encryptedData = [rawData dataEncryptedWithPassword:password];
    if (encryptedData == nil || [encryptedData length] == 0)
    {
        NSLog(@"Error encrypting with password %@.\n", password);
        [pool release];
        return 3;
    }
    
    BOOL writeOk = [encryptedData writeToFile:outputFileName atomically:NO];
    if (writeOk == NO)
    {
        NSLog(@"Error writing to file %@.\n", outputFileName);
        [pool release];
        return 4;
    }
    
    #ifdef VALIDATE
    
        NSData* unencryptedData = [encryptedData dataDecryptedWithPassword:password];
    
        if (unencryptedData == nil || [unencryptedData isEqualToData:rawData] == NO)
        {
            NSLog(@"Validation failed.\n");
            [pool release];
            return 5;
        }
    
    #endif
    
    [pool release];
    return 0;
}
