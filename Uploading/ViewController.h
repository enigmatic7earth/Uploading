//
//  ViewController.h
//  Uploading
//
//  Created by NETBIZ on 29/08/18.
//  Copyright © 2018 Netbiz.in. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIImagePickerControllerDelegate,UIDocumentPickerDelegate,UIPopoverPresentationControllerDelegate>
{
    NSMutableArray *arrimg;
    
    NSString * UploadType;
    NSURL * PDFUrl;
    NSString *imageUrl;
    
}

@end

