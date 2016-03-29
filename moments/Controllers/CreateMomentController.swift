import CoreLocation
import Firebase
import UIKit
import AWSCore
import AWSS3
import AWSCognito
import AssetsLibrary

class CreateMomentController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  @IBOutlet weak var pickerView: UIPickerView!
  @IBOutlet weak var textField: UITextField!
  var userCoordinate: CLLocationCoordinate2D!
  private let momentsRef = Firebase(url: "https://makersmoments.firebaseio.com/moments")
  private var userId: String!
  private var userName: String!
  private var selectedMomoji: String!
  private let characterLimit = 30
  private let imagePicker = UIImagePickerController()
  private let s3bucket = "makersmoments"
  private let uploadRequest = AWSS3TransferManagerUploadRequest()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    pickerView.delegate = self
    textField.delegate = self
    imagePicker.delegate = self
    momentsRef.observeAuthEventWithBlock { authData in
      self.userId = authData.uid
      self.userName = authData.providerData["displayName"] as? String
    }
    self.hideKeyboardWhenTappedAround()
  }
  
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return 2
  }
  
  func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
    return 40
  }
  
  func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
    var myImageView = UIImageView()
    
    switch row {
    case 0:
      myImageView = UIImageView(image: UIImage(named:"grinning_face"))
      selectedMomoji = "1F600"
    case 1:
      myImageView = UIImageView(image: UIImage(named:"joy"))
      selectedMomoji = "1F602"
    default:
      myImageView.image = nil
    }
    
    return myImageView
  }
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text else { return true }
    let newLength = text.characters.count + string.characters.count - range.length
    return newLength <= characterLimit
  }
  
  @IBAction func createMoment(sender: UIButton) {
    print(uploadRequest.key)
    let moment = ["momoji": selectedMomoji,
                  "text": textField.text!,
                  "latitude": userCoordinate.latitude,
                  "longitude": userCoordinate.longitude,
                  "userName": self.userName,
                  "userId": self.userId,
                  "imageKey": "\(self.uploadRequest.key!)"]
    let momentRef = momentsRef.childByAutoId()
    momentRef.setValue(moment)
  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    
    
    let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
    var url: NSURL
    if let img: UIImage = pickedImage as UIImage {
      let path = (NSTemporaryDirectory() as NSString).stringByAppendingPathComponent("image.jpg")
      let imageData: NSData = UIImageJPEGRepresentation(img, 0.01)!
      imageData.writeToFile(path as String, atomically: true)
      
      url = NSURL(fileURLWithPath: path as String)
      
      uploadRequest.body = url
      uploadRequest.key = NSProcessInfo.processInfo().globallyUniqueString + ".jpg"
      uploadRequest.bucket = self.s3bucket
      uploadRequest.contentType = "image/"
      let transferManager = AWSS3TransferManager.defaultS3TransferManager()
      transferManager.upload(uploadRequest).continueWithBlock { (task) -> AnyObject! in
        if let error = task.error {
          print("Upload failed (\(error))")
        }
        if let exception = task.exception {
          print("Upload failed (\(exception))")
        }
        if task.result != nil {
          let s3URL = NSURL(string: "http://s3.amazonaws.com/\(self.s3bucket)/\(self.uploadRequest.key!)")!
          print("Uploaded to:\n\(s3URL)")
        }
        else {
          print("Unexpected empty result.")
        }
        return nil
      }
      
    }
    
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
  }
  
  @IBAction func takePhoto(sender: AnyObject) {
    imagePicker.allowsEditing = false
    imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
    imagePicker.cameraCaptureMode = .Photo
    imagePicker.modalPresentationStyle =  .FullScreen
    presentViewController(imagePicker, animated: true, completion: nil)
  }
}