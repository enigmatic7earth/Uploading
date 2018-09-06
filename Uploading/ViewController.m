//
//  ViewController.m
//  Uploading
//
//  Created by NETBIZ on 29/08/18.
//  Copyright © 2018 Netbiz.in. All rights reserved.
//

#import "ViewController.h"
#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>


@interface ViewController ()

@property (nonatomic, strong) UIImage * pic;
@property (nonatomic, strong) NSString * filenm;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    arrimg =[[NSMutableArray alloc]init];
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status) {
            case PHAuthorizationStatusAuthorized:
                NSLog(@"PHAuthorizationStatusAuthorized");
                break;
            case PHAuthorizationStatusDenied:
                NSLog(@"PHAuthorizationStatusDenied");
                break;
            case PHAuthorizationStatusNotDetermined:
                NSLog(@"PHAuthorizationStatusNotDetermined");
                break;
            case PHAuthorizationStatusRestricted:
                NSLog(@"PHAuthorizationStatusRestricted");
                break;
        }
    }];
    NSLog(@"%@",NSHomeDirectory());
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)fileSelect:(id)sender {
    
    UIAlertController * actionSheet = [UIAlertController alertControllerWithTitle:nil message:@"File oprions:" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * camera = [UIAlertAction actionWithTitle:@"Take photo with camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Camera");
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        // Set source to the camera
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        
        // Delegate is self
        imagePicker.delegate = self;
        
        // Allow editing of image ?
        
        
        // Show image picker
        
        
        //[[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction * gallery = [UIAlertAction actionWithTitle:@"Choose an existing photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Gallery");
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        // Set source to the camera
        imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        
        // Delegate is self
        imagePicker.delegate = self;
        
        // Allow editing of image ?
        
        
        // Show image picker
        
        
        //[[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }];
    
    UIAlertAction * document = [UIAlertAction actionWithTitle:@"Choose a document" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Document");
        NSArray *types = @[(NSString*)kUTTypeImage,
                           (NSString*)kUTTypeSpreadsheet,
                           (NSString*)kUTTypePresentation,
                           (NSString*)kUTTypeDatabase,
                           (NSString*)kUTTypeFolder,
                           (NSString*)kUTTypeZipArchive,
                           (NSString*)kUTTypeVideo,
                           (NSString*)kUTTypePDF,
                           (NSString*)kUTTypeMovie,
                           (NSString*)kUTTypeAudio,
                           (NSString*)kUTTypeMPEG,
                           (NSString*)kUTTypeMPEG2Video,
                           (NSString*)kUTTypeMP3,
                           (NSString*)kUTTypeMPEG4,
                           (NSString*)kUTTypeMPEG4Audio,
                           (NSString*)kUTTypeJPEG,
                           (NSString*)kUTTypePNG,
                           (NSString*)kUTTypeGIF,
                           (NSString*)kUTTypeRTFD,
                           (NSString*)kUTTypeWebArchive,
                           (NSString*)kUTTypeText,
                           (NSString*)kUTTypePlainText,
                           (NSString*)kUTTypeRTF];
        //Create a object of document picker view and set the mode to Import
        UIDocumentPickerViewController *docPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:types inMode:UIDocumentPickerModeImport];
        //Set the delegate
        docPicker.delegate = self;
        //present the document picker
        [self presentViewController:docPicker animated:YES completion:nil];
    }];
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancelled");
    }];
    
    
    [actionSheet addAction:camera];
    [actionSheet addAction:gallery];
    [actionSheet addAction:document];
    [actionSheet addAction:cancel];
    
    //For iPad a PopOverViewController is needed
    UIPopoverPresentationController * popoverController = actionSheet.popoverPresentationController;
    actionSheet.modalPresentationStyle = UIModalPresentationPopover;
    popoverController.sourceView = self.view;
    popoverController.sourceRect =  CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2, 0, 0);
    popoverController.permittedArrowDirections = 0;
    popoverController.delegate = self;
    
    [self presentViewController:actionSheet animated:true completion:nil];
}
#pragma mark - Image Picker Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"Image picked");
    NSLog(@"%@",info);
    

    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
    {
//        NSData * data = UIImageJPEGRepresentation([info valueForKey:@"UIImagePickerControllerOriginalImage"], 0.5);
//
//        NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/image.JPEG"];
//        [data writeToFile:path atomically:true];
        _pic = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
        
        NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
        PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[refURL] options:nil];
        PHAsset *asset = [result firstObject];
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
//            UIImage* newImage = [UIImage imageWithData:imageData];
        }];
        _filenm = [[result firstObject] filename];
        
        
    }
    else
    {
//        UIImageWriteToSavedPhotosAlbum([info valueForKey:@"UIImagePickerControllerOriginalImage"], nil, nil, nil);
        _pic = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
        _filenm = [self getUniqueFileNameFor:@"CameraPic.JPG"];
        
    }
    
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.image = _pic;
    
    /*
     //Works in simulator, iOS 10+, iPhone
    NSURL * fileurl = [info valueForKey:@"UIImagePickerControllerImageURL"];
    NSMutableString * filepath = [NSMutableString stringWithFormat:@"%@",fileurl];
    [filepath replaceOccurrencesOfString:@"file://" withString:@"" options:0 range:NSMakeRange(0, filepath.length)];
    */
    
    
    
/*
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAsset *asset = (PHAsset *)obj;
        [asset requestContentEditingInputWithOptions:nil completionHandler:^(PHContentEditingInput * _Nullable contentEditingInput, NSDictionary * _Nonnull info) {
            NSLog(@"URL:%@",  contentEditingInput.fullSizeImageURL.absoluteString);
            //file:///var/mobile/Media/PhotoData/CPLAssets/group125/0888AEED-48C6-4E6E-93AB-CE99A6E706AF.JPG
            NSString* path = [contentEditingInput.fullSizeImageURL.absoluteString substringFromIndex:7];//screw all the crap of file://
            NSFileManager *fileManager = [NSFileManager defaultManager];
            BOOL isExist = [fileManager fileExistsAtPath:path];
            if (isExist)
                filepath = [path mutableCopy];
            
            else {
                NSLog(@"damn");
            }
        }];
    }];
     */
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"UIImagePicker"
                                          message:@"Image picked"
                                          preferredStyle:UIAlertControllerStyleAlert];
    [alertController.view addSubview:imgView];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self uploadImage:imgView.image withPath:filepath andName:filename];
//    }]];
    
    
    [self dismissViewControllerAnimated:true completion:nil];
    [self presentViewController:alertController animated:YES completion:nil];
//    NSString * filename = [fileurl lastPathComponent];
//    [self uploadImage:imgView.image withPath:filepath andName:filename];
//    [self uploadImage:imgView.image withPath:filepath andName:filename];
    [self uploadImage:_pic withPath:nil andName:_filenm];
    

    
    
}
#pragma mark Delegate-UIDocumentPickerViewController

/**
 *  This delegate method is called when user will either upload or download the file.
 *
 *  @param controller UIDocumentPickerViewController object
 *  @param url        url of the file
 */

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url
{
    
    if (controller.documentPickerMode == UIDocumentPickerModeImport)
    {
        
        // Condition called when user download the file
        //        NSData *fileData = [NSData dataWithContentsOfURL:url];
        // NSData of the content that was downloaded - Use this to upload on the server or save locally in directory
        
        //Showing alert for success
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *alertMessage = [NSString stringWithFormat:@"Successfully picked file %@", [url lastPathComponent]];
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"UIDocumentPicker"
                                                  message:alertMessage
                                                  preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
            
        });
    }else  if (controller.documentPickerMode == UIDocumentPickerModeExportToService)
    {
        // Called when user uploaded the file - Display success alert
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *alertMessage = [NSString stringWithFormat:@"Successfully uploaded file %@", [url lastPathComponent]];
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"UIDocumentPicker"
                                                  message:alertMessage
                                                  preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
            
        });
    }
    NSString * filename = [url lastPathComponent];
    NSMutableString * filepath = [NSMutableString stringWithFormat:@"%@", url];
    [filepath replaceOccurrencesOfString:@"file://" withString:@"" options:0 range:NSMakeRange(0, filepath.length)];
    
    [self uploadDocument:[NSData dataWithContentsOfURL:url] withName:filename andPath:filepath];

}

/**
 *  Delegate called when user cancel the document picker
 *
 *  @param controller - document picker object
 */
- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
    
}
#pragma mark UIPopoverPresentationControllerDelegate
-(BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{
    return YES;
}

-(void) uploadImage:(UIImage *)image withPath:(NSString *)pathToFile andName:(NSString *)fileName{
    // Dictionary that holds post parameters. You can set your post parameters that your server accepts or programmed to accept.
    //https://stackoverflow.com/questions/8564833/ios-upload-image-and-text-using-http-post
    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    [_params setObject:fileName forKey:@"name"];
    //[_params setObject:pathToFile forKey:@"pdf"];

    
    // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
    NSString *BoundaryConstant = @"----------V2ymHFg03ehbqgZCaKO6jy";
    
    // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
    NSString* FileParamConstant = @"pdf";
    
    // the server url to which the image (or the media) is uploaded. Use your server url here
    NSURL* requestURL = [NSURL URLWithString:@"http://192.168.0.198/upload_pdf_cptest/file_upload.php"];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in _params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    NSString * fileType = [self getFileContentType:fileName]; //@"Content-Type: application/pdf\r\n\r\n";
    NSString * uniqueFileName = [self getUniqueFileNameFor:fileName];
    
    // add image data
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        NSMutableString * temp = [[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; ", FileParamConstant] mutableCopy];
        temp = [[[[temp stringByAppendingString:@"filename=\""] stringByAppendingString:uniqueFileName] stringByAppendingString:@"\"\r\n"] mutableCopy];
        [body appendData:[temp dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[fileType dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    [request setURL:requestURL];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    // NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
//    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil];
//    NSLog(@"%@",dict);
}

-(void) uploadDocument:(NSData *)fileData withName:(NSString *)fileName andPath:(NSString *)pathToFile{
    // Dictionary that holds post parameters. You can set your post parameters that your server accepts or programmed to accept.
    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    [_params setObject:fileName forKey:@"name"];
    //[_params setObject:pathToFile forKey:@"pdf"];
    
    
    // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
    NSString *BoundaryConstant = @"----------V2ymHFg03ehbqgZCaKO6jy";
    
    // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
    NSString* FileParamConstant = @"pdf";
    
    // the server url to which the image (or the media) is uploaded. Use your server url here
    NSURL* requestURL = [NSURL URLWithString:@"http://192.168.0.198/upload_pdf_cptest/file_upload.php"];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in _params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    NSString * fileType = [self getFileContentType:fileName]; //@"Content-Type: application/pdf\r\n\r\n";
    NSString * uniqueFileName = [self getUniqueFileNameFor:fileName];
    // add image data
    
    NSData *docData = fileData;
    if (docData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        NSMutableString * temp = [[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; ", FileParamConstant] mutableCopy];
        temp = [[[[temp stringByAppendingString:@"filename=\""] stringByAppendingString:uniqueFileName] stringByAppendingString:@"\"\r\n"] mutableCopy];
        [body appendData:[temp dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[fileType dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:docData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    [request setURL:requestURL];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    // NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dict);
}
-(NSString *)getFileContentType:(NSString *)filename{
    NSString * extension = [filename pathExtension];
    NSString * fileContentType;
    //Common documents
    if ([extension caseInsensitiveCompare:@"pdf"] == NSOrderedSame) {
        fileContentType = @"Content-Type: application/pdf\r\n\r\n";
    }
    else if ([extension caseInsensitiveCompare:@"doc"] == NSOrderedSame ||[extension caseInsensitiveCompare:@"docx"] == NSOrderedSame){
        fileContentType = @"Content-Type: application/msword\r\n\r\n";
    }
    else if ([extension caseInsensitiveCompare:@"txt"] == NSOrderedSame){
        fileContentType = @"Content-Type: text/plain\r\n\r\n";
    }
    else if ([extension caseInsensitiveCompare:@"ppt"] == NSOrderedSame||[extension caseInsensitiveCompare:@"pptx"] == NSOrderedSame){
        fileContentType = @"Content-Type: application/vnd.ms-powerpoint\r\n\r\n";
    }
    //Compressed files
    else if ([extension caseInsensitiveCompare:@"zip"] == NSOrderedSame){
        fileContentType = @"Content-Type: application/zip\r\n\r\n";
    }
    else if ([extension caseInsensitiveCompare:@"rar"] == NSOrderedSame){
        fileContentType = @"Content-Type: application/x-rar-compressed\r\n\r\n";
    }
    //Video
    else if ([extension caseInsensitiveCompare:@"mp4"] == NSOrderedSame){
        fileContentType = @"Content-Type: video/mp4\r\n\r\n";
    }
    //Audio
    else if ([extension caseInsensitiveCompare:@"mp3"] == NSOrderedSame){
        fileContentType = @"Content-Type: audio/mp4\r\n\r\n";
    }
    //Images
    else if ([extension caseInsensitiveCompare:@"jpg"] == NSOrderedSame||[extension caseInsensitiveCompare:@"jpeg"] == NSOrderedSame){
        fileContentType = @"Content-Type: image/jpeg\r\n\r\n";
    }
    else if ([extension caseInsensitiveCompare:@"png"] == NSOrderedSame){
        fileContentType = @"Content-Type: image/png\r\n\r\n";
    }
    else if ([extension caseInsensitiveCompare:@"gif"] == NSOrderedSame){
        fileContentType = @"Content-Type: image/gif\r\n\r\n";
    }
    else{
        fileContentType = @"Content-Type: application/*\r\n\r\n";
    }
    
    
    return fileContentType;

}
-(NSString *) getFileInitialsFor:(NSString *)filename{
    NSString * extension = [filename pathExtension];
    NSString * initials = nil;
    
    //Common documents
    if ([extension caseInsensitiveCompare:@"pdf"] == NSOrderedSame) {
        initials = @"PDF";
    }
    else if ([extension caseInsensitiveCompare:@"doc"] == NSOrderedSame ||[extension caseInsensitiveCompare:@"docx"] == NSOrderedSame){
        initials = @"DOC";
    }
    else if ([extension caseInsensitiveCompare:@"txt"] == NSOrderedSame){
        initials = @"TXT";
    }
    else if ([extension caseInsensitiveCompare:@"ppt"] == NSOrderedSame||[extension caseInsensitiveCompare:@"pptx"] == NSOrderedSame){
        initials = @"PPT";
    }
    //Compressed files
    else if ([extension caseInsensitiveCompare:@"zip"] == NSOrderedSame||[extension caseInsensitiveCompare:@"rar"] == NSOrderedSame){
        initials = @"ARC";
    }
    
    //Video
    else if ([extension caseInsensitiveCompare:@"mp4"] == NSOrderedSame){
        initials = @"VID";
    }
    //Audio
    else if ([extension caseInsensitiveCompare:@"mp3"] == NSOrderedSame){
        initials = @"AUD";
    }
    //Images
    else if ([extension caseInsensitiveCompare:@"jpg"] == NSOrderedSame||[extension caseInsensitiveCompare:@"jpeg"] == NSOrderedSame||[extension caseInsensitiveCompare:@"png"] == NSOrderedSame||[extension caseInsensitiveCompare:@"gif"] == NSOrderedSame){
        initials = @"IMG";
    }
    else{
        initials = @"FILE";
    }
    
    return initials;
    
}
-(NSString *) getUniqueFileNameFor:(NSString *)filename{
    //function to generate a unique filename
    NSString * uniqueFileName = nil;
    
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-ddHH:MM:SS"];
    NSString* str = [formatter stringFromDate:date];
    NSLog(@"User's current time in their preference format:%@",str);
    NSString *str11 = [str stringByReplacingOccurrencesOfString:@"-"
                                                     withString:@""];
    NSString *str12 = [str11 stringByReplacingOccurrencesOfString:@":"
                                                       withString:@""];
    
    NSString * fileInitials = [ self getFileInitialsFor:filename];
    
    uniqueFileName = [NSString stringWithFormat:@"%@_%@.%@", fileInitials, str12,[filename pathExtension]];
    
    
    return uniqueFileName;
}
@end
