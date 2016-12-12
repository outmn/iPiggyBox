//
//  SettingsViewController.swift
//  iPiggyBox
//
//  Created by Maxim  Grozniy on 28.12.15.
//  Copyright © 2015 Maxim  Grozniy. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    var nowPoint: CGPoint?
    
    var cellHeight: CGFloat?
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    @IBOutlet weak var listTypeSwitch: UISwitch!
    @IBOutlet weak var nextRealisationSwitch: UISwitch!
    @IBOutlet weak var frequencySegment: UISegmentedControl!
    @IBOutlet weak var loyaltySwitch: UISwitch!
    
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBOutlet weak var choseTimeReminding: UIButton!
    let dateFormatter = DateFormatter()
    
    @IBOutlet weak var timePickerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSettingsForm()
        
        // Setting height of cell
        cellSize()
        
        dateFormatter.dateFormat = "HH:mm"
        
        
        choseTimeReminding.setTitle(dateFormatter.string(from: timeReminding as Date), for: UIControlState())
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - TabBar - hiding animation
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        nowPoint = scrollView.contentOffset
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.y < nowPoint!.y) {
            self.tabBarController?.tabBar.setTabBarVisible(self.view.frame, visible: true)
            
        } else if (scrollView.contentOffset.y > nowPoint!.y) {
            self.tabBarController?.tabBar.setTabBarVisible(self.view.frame, visible: false)
        }
    }
    
    // MARK: - Updating Settings Form
    
    func updateSettingsForm() {
        listTypeSwitch.isOn = listType
        nextRealisationSwitch.isOn = nextRealisation
        loyaltySwitch.isOn = loyalty
        frequencySegment.selectedSegmentIndex = frequency
    }
    
    func cellSize() {
        cellHeight = settingsTableView.frame.height / 3
        let screenHeight: CGFloat = UIScreen.main.bounds.height
        
        if screenHeight == CGFloat(480) {
            cellHeight = settingsTableView.frame.height / 2
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight!
    }

    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Change Settings buttons
    
    @IBAction func changeListType(_ sender: UISwitch) {
        if sender.isOn {
            listType = true
        } else {
            listType = false
        }
        
        let defaults = UserDefaults.standard
        defaults.set(listType, forKey: "listType")
        defaults.synchronize()
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "tableRefresh"), object: nil)        
    }
    
    @IBAction func changeRemindingNextRealisation(_ sender: UISwitch) {
        if sender.isOn {
            nextRealisation = true
        } else {
            nextRealisation = false
        }
        
        let defaults = UserDefaults.standard
        defaults.set(nextRealisation, forKey: "nextRealisation")
        defaults.synchronize()
    }
    
    
    @IBAction func changeRemindingTimer(_ sender: UISegmentedControl) {
        var tempFrequency = 0
        
        switch sender.selectedSegmentIndex {
            
        case 0:
            tempFrequency = 0
        case 1:
            tempFrequency = 1
        case 2:
            tempFrequency = 2
        default:
            break
        }
        
        frequency = tempFrequency;
        
        let defaults = UserDefaults.standard
        defaults.set(frequency, forKey: "frequency")
        defaults.synchronize()
    }
    
    
    @IBAction func changeLoyalty(_ sender: UISwitch) {
        if sender.isOn {
            loyalty = true
        } else {
            loyalty = false
        }
        
        let defaults = UserDefaults.standard
        defaults.set(loyalty, forKey: "loyalty")
        defaults.synchronize()
    }
    
    
    @IBAction func buttonClearData(_ sender: UIButton) {
        let clearAlert = UIAlertController(title: "Clear data", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.alert)
        
        let buttonOK = UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive) { (UIAlertAction) -> Void in
            Targets.clearData()
            Targets.fetchData()
            
            Calculation.clearData()
            Calculation.fetchData()
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "tableRefresh"), object: nil)
        }
        
        let buttonCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil)
        
        clearAlert.addAction(buttonOK)
        clearAlert.addAction(buttonCancel)
        
        self.present(clearAlert, animated: true, completion: nil)
        
        
    }
    
    
    
    @IBAction func actionChoseTime(_ sender: UIButton) {
        
        timePickerView.isHidden = false
        
        
    }
    
    
    @IBAction func actionTimePicker(_ sender: UIDatePicker) {
        
    }
    
    
    @IBAction func okTimeAction(_ sender: UIButton) {
        timeReminding = timePicker.date
        
        choseTimeReminding.setTitle(dateFormatter.string(from: timeReminding as Date), for: UIControlState())
        
        let defaults = UserDefaults.standard
        defaults.set(timeReminding, forKey: "timeReminding")
        defaults.synchronize()
        
        timePickerView.isHidden = true
    }

}
