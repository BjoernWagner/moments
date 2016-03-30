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
  let s3bucket = "makersmoments"
  let uploadRequest = AWSS3TransferManagerUploadRequest()
  private let momentsRef = Firebase(url: "https://makersmoments.firebaseio.com/moments")
  private var userId: String!
  private var userName: String!
  private var selectedMomoji: String!
  private let characterLimit = 30
  private let imagePicker = UIImagePickerController()
  
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
    var imageKey: String
    if self.uploadRequest.key == nil {
      imageKey = "no image"
    } else {
      imageKey = self.uploadRequest.key!
    }
    let moment = ["momoji": selectedMomoji,
                  "text": textField.text!,
                  "latitude": userCoordinate.latitude,
                  "longitude": userCoordinate.longitude,
                  "userName": self.userName,
                  "userId": self.userId,
                  "imageKey": imageKey]
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
      uploadImage(url)
      
      dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    }
  }
  
  @IBAction func takePhoto(sender: AnyObject) {
    imagePicker.allowsEditing = false
    imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
    imagePicker.cameraCaptureMode = .Photo
    imagePicker.modalPresentationStyle =  .FullScreen
    presentViewController(imagePicker, animated: true, completion: nil)
  }
}