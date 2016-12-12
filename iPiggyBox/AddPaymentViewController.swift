//
//  AddPaymentViewController.swift
//  iPiggyBox
//
//  Created by Maxim  Grozniy on 10.01.16.
//  Copyright © 2016 Maxim  Grozniy. All rights reserved.
//

import UIKit
import CoreData
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


class AddPaymentViewController: UIViewController, UITextFieldDelegate {
    let moc = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    var productName: String!
    var id: Int!
    var amount: Int = 0

    
    @IBOutlet weak var textFieldSum: UITextField!    
    @IBOutlet weak var textFieldDate: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var buttonOkDate: UIButton!
    
    var incomeDate = Date()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // установление данных
        dateFormatter.dateFormat = "dd.MM.yyyy"
        fillData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Заполнение данными
    
    func fillData() {
        textFieldDate.text = dateFormatter.string(from: incomeDate)
        
    }
    
    // MARK: работа с текстом
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        
        if textField == textFieldSum {
            if textFieldSum.text == "0" {
                textFieldSum.text = ""
            }
            datePicker.isHidden = true
            buttonOkDate.isHidden = true
            return true
        }
        datePicker.isHidden = false
        buttonOkDate.isHidden = false
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == textFieldSum {
            if !checkSum(textField) {
                self.present(Support.getAlert("Сбережения", alMessage: "Введенная сумма больше стоимости цели"),
                    animated: true, completion: nil)
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        datePicker.isHidden = true
        buttonOkDate.isHidden = true
        super.touchesBegan(touches, with: event)
    }
    
    // MARK: Кнопка возврата
    
    @IBAction func back(_ sender: UIButton) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func buttonOkDateAction(_ sender: UIButton) {
        incomeDate = datePicker.date
        textFieldDate.text = dateFormatter.string(from: incomeDate)
        datePicker.isHidden = true
        buttonOkDate.isHidden = true
    }
    
    @IBAction func buttonAddPayment(_ sender: UIButton) {
        view.endEditing(true)
        
        if amount == 0 {
            return
        }
        
        Calculation.createNewItem(moc, productName: productName, incomeDate: incomeDate, amount: amount, id: id)
        Calculation.fetchData()
        print(dataCalculation.count)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "updateData"), object: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "tableRefresh"), object: nil)
        
        dismiss(animated: true, completion: nil)
        
        
        
    }
    
    func checkSum(_ textField: UITextField) -> Bool {
        let price = Int(dataWish[id].price!)
        let readySum = Support.getReadySum(id)
        let rest = price - readySum
        
        let temp = textField.text == "" ? 0 : Int(textField.text!)
        
        if temp > rest || temp == 0 {
            textFieldSum.text = "0"
            amount == 0
            return false
        }
        
        amount = temp!
        return true
    }
}
