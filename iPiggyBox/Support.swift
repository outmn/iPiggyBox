//
//  Support.swift
//  iPiggyBox
//
//  Created by Maxim  Grozniy on 28.12.15.
//  Copyright © 2015 Maxim  Grozniy. All rights reserved.
//

import Foundation
import UIKit

class Support {
    
    class func loadCommonSettings() {
        let defaults = UserDefaults.standard
        
        //1. установка вида списка
        if (defaults.object(forKey: "listType") != nil) {
            let listType_D = defaults.bool(forKey: "listType")
            listType = listType_D
        }
        
        //2. оповещение о следующей покупке
        if (defaults.object(forKey: "nextRealisation") != nil) {
            let nextRealisation_D = defaults.bool(forKey: "nextRealisation")
            nextRealisation = nextRealisation_D
        }
        
        //3. частота напоминаний
        if (defaults.object(forKey: "frequency") != nil) {
            let frequency_D = defaults.integer(forKey: "frequency")
            frequency = frequency_D
        }
        
        //4. установка лояльности
        if (defaults.object(forKey: "loyalty") != nil) {
            let loyalty_D = defaults.bool(forKey: "loyalty")
            loyalty = loyalty_D
        }
        
    }
    
    class func getReadySum(_ id: Int) -> Int{
        var sum: Int = 0
        
        for numb in dataCalculation where numb.id == id {
//            print(numb.amount)
            sum += Int(numb.amount!)
        }
        
        print("сумма \(sum) id \(id)")
        
        return sum
    }
    
    class func getAlert(_ alTitle: String, alMessage: String) -> UIAlertController {
        let alert = UIAlertController(title: alTitle, message: alMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
        return alert
    }
}

extension UIImage {
    
    subscript (x: Int, y: Int) -> UIColor? {
        
        if x < 0 || x > Int(size.width) || y < 0 || y > Int(size.height) {
            return nil
        }
        
        let provider = self.cgImage?.dataProvider
        let providerData = provider?.data
        let data = CFDataGetBytePtr(providerData)
        
        let numberOfComponents = 4
        let pixelData = ((Int(size.width) * y) + x) * numberOfComponents
        
        let r = CGFloat((data?[pixelData])!) / 255.0
        let g = CGFloat((data?[pixelData + 1])!) / 255.0
        let b = CGFloat((data?[pixelData + 2])!) / 255.0
        let a = CGFloat((data?[pixelData + 3])!) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
}

