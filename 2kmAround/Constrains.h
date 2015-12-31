

#import <Foundation/Foundation.h>

extern const int kConversationType_OneOne;
extern const int kConversationType_Group;

extern const int kConversationVisibility_Private;
extern const int kConversationVisibility_Public;

extern NSString *kAVUserClassName;

typedef void (^CommonResultBlock)(BOOL successed);
typedef void (^ArrayResultBlock)(NSArray *objects, NSError *error);

@interface Constrains : NSObject

@end
