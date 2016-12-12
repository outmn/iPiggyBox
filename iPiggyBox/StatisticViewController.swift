//
//  StatisticViewController.swift
//  iPiggyBox
//
//  Created by Maxim  Grozniy on 28.12.15.
//  Copyright © 2015 Maxim  Grozniy. All rights reserved.
//

import UIKit

class StatisticViewController: UIViewController {
    
    var nowPoint: CGPoint?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TabBar - Анимация скрытия
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        nowPoint = scrollView.contentOffset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.y < nowPoint!.y) {
            self.tabBarController?.tabBar.setTabBarVisible(self.view.frame, visible: true)
            
        } else if (scrollView.contentOffset.y > nowPoint!.y) {
            self.tabBarController?.tabBar.setTabBarVisible(self.view.frame, visible: false)
        }
    }


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    

}
