

#import "MCPhotographyHelper.h"
#import "XHMacro.h"

@interface MCPhotographyHelper () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, copy) DidFinishTakeMediaCompledBlock didFinishTakeMediaCompled;

@end

@implementation MCPhotographyHelper

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    self.didFinishTakeMediaCompled = nil;
}

- (void)showOnPickerViewControllerSourceType:(UIImagePickerControllerSourceType)sourceType onViewController:(UIViewController *)viewController allowsEditing:(BOOL)allowsEditing compled:(DidFinishTakeMediaCompledBlock)compled {
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        compled(nil, nil);
        return;
    }
    self.didFinishTakeMediaCompled = [compled copy];
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.navigationBar.barStyle = UIBarStyleBlack;
    imagePickerController.editing = YES;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = allowsEditing;
    imagePickerController.sourceType = sourceType;
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        imagePickerController.mediaTypes =  [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    [viewController presentViewController:imagePickerController animated:YES completion:NULL];
}

- (void)showOnPickerViewControllerOnViewController:(UIViewController *)viewController completion:(DidFinishTakeImageBlock)completion {
    NSLog(@"图片2");
    
    
    [self showOnPickerViewControllerSourceType:UIImagePickerControllerSourceTypePhotoLibrary onViewController:viewController allowsEditing:YES compled: ^(UIImage *image, NSDictionary *editingInfo) {
        UIImage *edited = editingInfo[UIImagePickerControllerEditedImage];
        UIImage *origin = editingInfo[UIImagePickerControllerOriginalImage];
        UIImage *finalImage = edited ? edited : (origin ? origin : image);
        if (completion) {
            completion(finalImage);
        }
    }];
}

- (void)dismissPickerViewController:(UIImagePickerController *)picker {
    WEAKSELF
    [picker dismissViewControllerAnimated : YES completion : ^{
        weakSelf.didFinishTakeMediaCompled = nil;
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    if (self.didFinishTakeMediaCompled) {
        self.didFinishTakeMediaCompled(image, editingInfo);
    }
    [self dismissPickerViewController:picker];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if (self.didFinishTakeMediaCompled) {
        self.didFinishTakeMediaCompled(nil, info);
    }
    [self dismissPickerViewController:picker];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissPickerViewController:picker];
}

@end
