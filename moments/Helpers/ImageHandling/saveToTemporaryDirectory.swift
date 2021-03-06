import AWSS3

class SaveToTemporaryDirectory {
  func run(controller: CreateMomentController, pickedImage: UIImage, uploadRequest: AWSS3TransferManagerUploadRequest) {
    var url: NSURL
    if let img: UIImage = pickedImage {
      let path = (NSTemporaryDirectory() as NSString).stringByAppendingPathComponent("image.jpg")
      let imageData: NSData = UIImageJPEGRepresentation(img, 0.01)!
      imageData.writeToFile(path, atomically: true)
      
      url = NSURL(fileURLWithPath: path)
      UploadImage().run(url, uploadRequest: uploadRequest)
      
      controller.dismissViewControllerAnimated(true, completion: nil)
    }
  }
}