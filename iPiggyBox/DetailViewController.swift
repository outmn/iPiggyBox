//
//  DetailViewController.swift
//  iPiggyBox
//
//  Created by Maxim  Grozniy on 28.12.15.
//  Copyright © 2015 Maxim  Grozniy. All rights reserved.
//

import UIKit
import CoreData
import Foundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, NSFetchedResultsControllerDelegate {
    
    let moc = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    var index: Int?
    var isEdition: Bool = false
    
    var startDate = Date()
    var endDate: Date?
    var price: Double = 0
    var ready = false
    
    let pimagePicker = UIImagePickerController()
    let blockView = UIView()
    
    @IBOutlet weak var goalImageView: UIImageView!
    
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var buttonAddPayment: UIBarButtonItem!
    
    @IBOutlet weak var goalNameTextField: UITextField!
    @IBOutlet weak var goalPriceTextField: UITextField!
    
    @IBOutlet weak var labelStartDate: UILabel!
    @IBOutlet weak var labelEndDate: UILabel!
    @IBOutlet weak var labesReadyAmount: UILabel!
    @IBOutlet weak var labelRestAmount: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    
    var blurViewFrame: UIVisualEffectView?
    var pickerView: UIView?
    var picker: UIDatePicker?
    
    var currentItem: Targets!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(DetailViewController.fillData), name: NSNotification.Name(rawValue: "updateData"), object: nil)
        
        
        
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(DetailViewController.handleSwipe(_:)))
        downSwipe.direction = .down
        view.addGestureRecognizer(downSwipe)
        
        //установка значений
        fillData()
        
        //createPicker()
        
        if index != nil {
            // переход по строке
            editButton.isHidden = ready
            if !isEdition {
                createBlockWiew()
            }
            
        } else {
            //добавление нового желания
            editButton.isHidden = true
            cancelButton.isHidden = false
            self.buttonAddPayment.isEnabled = false
            
        }
        
        pimagePicker.delegate = self
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if index == nil {
            saveAndLoadData()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "tableRefresh"), object: nil)
        }
        
        let vc = segue.destination as! AddPaymentViewController
        vc.id = index
        vc.productName = goalNameTextField.text
        
    }
    
    
    func createBlockWiew() {
        blockView.frame = CGRect(x: 0, y: 50, width: view.frame.width, height: view.frame.height - 100)
//        blockView.backgroundColor = UIColor.orangeColor().colorWithAlphaComponent(0.5)
        view.backgroundColor = UIColor(red: 1, green: 250/255, blue: 240/255, alpha: 1)
        self.view.addSubview(blockView)
    }
    
    func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        if (sender.direction == .down) {
            dismiss(animated: true, completion: nil)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Создание Picker
    
    func createPicker() {
        //установление blurFrame размера в весь экран
        blurViewFrame = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.light))
        pickerView = UIView()
        picker = UIDatePicker()
        blurViewFrame!.frame.size = UIScreen.main.bounds.size
        blurViewFrame!.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        pickerView!.frame.size = UIScreen.main.bounds.size
        blurViewFrame!.addSubview(pickerView!)
        
        picker!.frame = CGRect(x: 0, y: view.frame.height/2 - 100, width: view.frame.width, height: 200)
        
        if endDate != nil {
            picker!.setDate(endDate!, animated: true)
        }
        
        picker!.datePickerMode = .date
        
        pickerView!.addSubview(picker!)
        
        let okDateButton = UIButton(type: .system)
        okDateButton.frame = CGRect(x: 0, y: 200, width: view.frame.width, height: 30)
        okDateButton.setTitle("OK", for: UIControlState())
        okDateButton.setTitleColor(UIColor.black, for: UIControlState())
        okDateButton.addTarget(self, action: #selector(DetailViewController.saveDate(_:)), for: .touchUpInside)
        pickerView!.addSubview(okDateButton)
        view.addSubview(blurViewFrame!)
//        blurViewFrame.hidden = true
    }
    
    // MARK: - Установка начальных значений
    func fillData() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        if index == nil {
            // установление новых значений
            labelStartDate.text = dateFormatter.string(from: startDate)
            if endDate == nil {
                labelEndDate.text = "Выберите дату!"
            } else {
                labelEndDate.text = dateFormatter.string(from: endDate!)
            }
            
        } else {
            // отображение строки по которой перешли
            goalNameTextField.text = dataWish[index!].productName
            price = Double(dataWish[index!].price!)
            goalPriceTextField.text = Int(price).description
            labelStartDate.text = dateFormatter.string(from: dataWish[index!].startDate! as Date)
            labelEndDate.text = dateFormatter.string(from: dataWish[index!].endDate! as Date)
            goalImageView.image = UIImage(data: dataWish[index!].picture! as Data)
            
            startDate = dataWish[index!].startDate! as Date
            endDate = dataWish[index!].endDate! as Date
            
            ready = dataWish[index!].ready! == 1 ? true : false
            
            let amount = Support.getReadySum(index!)
            labesReadyAmount.text = "\(amount)"
            
            let restAmount = Int(dataWish[index!].price!) - amount
            labelRestAmount.text = "\(restAmount)"
            
            if restAmount == 0 {
                ready = true
                saveAndLoadData()
                NotificationCenter.default.post(name: Notification.Name(rawValue: "tableRefresh"), object: nil)
            }
            
            labelMessage.text = ""
            
            
            // найдем по индексу и изменим, иначе создадим новый
            let dataFromKey = Targets.getDataForKey(index!)
            
            if dataFromKey.count > 0 {
                currentItem = dataFromKey[0]
            }
        }
        
        isAllFieldsReady()
        
    }
    
    // MARK: - Select / Change image
    @IBAction func imgPressed(_ sender: UITapGestureRecognizer) {
        pimagePicker.allowsEditing = false
        pimagePicker.sourceType = .photoLibrary
        present(pimagePicker, animated: true, completion: nil)
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
                goalImageView.contentMode = .scaleAspectFit
                goalImageView.image = chosenImage
        
                dismiss(animated: true, completion: nil)
        
        okButton.isHidden = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
     // MARK: - Кнопки
    
    @IBAction func changeButton(_ sender: UIButton) {
        view.backgroundColor = UIColor.white        
        blockView.removeFromSuperview()
        editButton.isHidden = true
        cancelButton.isHidden = false
    }
    
    @IBAction func okButton(_ sender: UIButton) {
        view.endEditing(true)
        
        
        
        if endDate == nil {
            let allert = Support.getAlert("Повідомлення", alMessage: "Треба встановити кінцеву дату накопичення!")
            
            self.present(allert, animated: true, completion: nil)
            return
        }
        
        self.view.addSubview(blockView)
        
        //сохранение произведенных изменений в базу
        saveAndLoadData()
        //
        
        okButton.isHidden = true
        cancelButton.isHidden = true
        
        if index != nil {
            editButton.isHidden = false
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "tableRefresh"), object: nil)
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancelButton(_ sender: UIButton) {
        view.endEditing(true)
        self.view.addSubview(blockView)
        
        okButton.isHidden = true
        cancelButton.isHidden = true
        editButton.isHidden = false
        closePicker()
        createBlockWiew()
    }
    
    func saveAndLoadData() {
        let imageData: Data = UIImagePNGRepresentation(goalImageView.image!)!
        
        if (index == nil) {
            if dataWish.count > 0 {
                let id = dataWish[dataWish.count - 1].id
                index = Int(id!) + 1
            } else {
                index = 0
            }
            
            
           // Targets.createNewItem(moc, id: NSNumber(index!), productName: goalNameTextField.text! as String, price: price, endDate: endDate!, startDate: startDate, picture: imageData, ready: ready)
        } else {
            currentItem?.productName = goalNameTextField.text
            currentItem?.price = price as NSNumber?
            currentItem?.endDate = endDate!
            currentItem?.startDate = startDate
            currentItem?.picture = imageData
            currentItem?.ready = ready as NSNumber?
            
            do {
                try moc.save()
            } catch {
                print("Не сохранено изменения")
            }
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == goalPriceTextField {
            if textField.text?.characters.count > 0 {
                price = Double(goalPriceTextField.text!)!
                //okButton.hidden = false
            } else {
                return
            }
            if goalNameTextField.text?.characters.count > 0 {
                okButton.isHidden = false
            }
        }
        
        if textField == goalNameTextField {
            if textField.text?.characters.count == 0 {
                return
            }
            if goalPriceTextField.text?.characters.count > 0 {
                okButton.isHidden = false
            }
        }
        
        isAllFieldsReady()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    
    @IBAction func changeStartDate(_ sender: UIButton) {
        view.endEditing(true)
        
    }
    
    
    @IBAction func changeEndDate(_ sender: UIButton) {
        view.endEditing(true)
//        blurViewFrame.hidden = false
        createPicker()
        
    }
 
    
    func saveDate(_ sender: UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        labelEndDate.text = dateFormatter.string(from: picker!.date)
        endDate = picker!.date
        
        //blurViewFrame.hidden = true
        closePicker()
        
        isAllFieldsReady()
    }
    
    func isAllFieldsReady() {
        if goalNameTextField.text != "" && goalPriceTextField.text != "" && price != 0 && endDate != nil && !ready {
            self.buttonAddPayment.isEnabled = true
        } else {
         self.buttonAddPayment.isEnabled = false
        }
    }
    
    func closePicker() {
        blurViewFrame!.removeFromSuperview()
        picker = nil
        pickerView = nil
        blurViewFrame = nil
    }
    
    

}
