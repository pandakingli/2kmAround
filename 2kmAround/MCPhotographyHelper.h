

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^DidFinishTakeMediaCompledBlock)(UIImage *image, NSDictionary *editingInfo);
typedef void (^DidFinishTakeImageBlock)(UIImage *image);

@interface MCPhotographyHelper : NSObject

- (void)showOnPickerViewControllerSourceType:(UIImagePickerControllerSourceType)sourceType onViewController:(UIViewController *)viewController allowsEditing:(BOOL)allowsEditing compled:(DidFinishTakeMediaCompledBlock)compled;

- (void)showOnPickerViewControllerOnViewController:(UIViewController *)viewController completion:(DidFinishTakeImageBlock)completion;

@end
