//
//  ListViewController.swift
//  iPiggyBox
//
//  Created by Maxim  Grozniy on 28.12.15.
//  Copyright © 2015 Maxim  Grozniy. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate, UIGestureRecognizerDelegate {
    
    var nowPoint: CGPoint?
    
    @IBOutlet weak var collectionBackgroundView: UIView!
    @IBOutlet weak var tableBackgroundView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Targets.clearData()
//        Calculation.clearData()
        
        Support.loadCommonSettings()
        print(listType)
        print(nextRealisation)
        print(frequency)
        print(loyalty)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ListViewController.refreshTable), name: NSNotification.Name(rawValue: "tableRefresh"), object: nil)
        
        Targets.fetchData()
        Calculation.fetchData()
        
        // Обновления
        refreshControl.backgroundColor = UIColor.white
        refreshControl.tintColor = UIColor.orange
        refreshControl.addTarget(self, action: #selector(ListViewController.refreshTable), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        choseListTipe()

    }
    
    func choseListTipe() {
        if listType {
            collectionBackgroundView.isHidden = false
            tableBackgroundView.isHidden = true
        } else {
            collectionBackgroundView.isHidden = true
            tableBackgroundView.isHidden = false
        }
    }
    
    
    func refreshTable() {
        Targets.fetchData()
        Calculation.fetchData()
        
        choseListTipe()
        
        tableView.reloadData()
        collectionView.reloadData()
        
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !listType {
            return dataWish.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
       // dispatch_async(dispatch_get_main_queue()) {
            cell.configureCell(dataWish[(indexPath as NSIndexPath).row])
        //}
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .Delete {
//            dispatch_async(dispatch_get_main_queue()) {
//                print("dataWish[indexPath.row].id! - \(dataWish[indexPath.row].id!)")
//                self.deleteCell(indexPath)
//                self.refreshTable()
//            }
//        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editButton = UITableViewRowAction(style: .default, title: "Змінити") { action, index in
            self.performSegue(withIdentifier: "editGoal", sender: tableView.cellForRow(at: indexPath))
            
            self.tableView.isEditing = false
        }
        
        editButton.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        
        let deleteButton = UITableViewRowAction(style: UITableViewRowActionStyle.default) , title: "Видалити") { action, index in
            DispatchQueue.main.async {
                print("dataWish[indexPath.row].id! - \(dataWish[(indexPath as NSIndexPath).row].id!)")
                self.deleteCell(indexPath)
                self.refreshTable()
            }
            
            self.tableView.isEditing = false
        }
        
        return [deleteButton, editButton]
    }
    
    
    // MARK: - Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if listType {
            return dataWish.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
        DispatchQueue.main.async {
            cell.configureCell(dataWish[(indexPath as NSIndexPath).row])
        }
        
        print((indexPath as NSIndexPath).row)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        if dataWish.count == 1 {
            return CGSize(width: view.frame.width - 20, height: collectionView.frame.height - 60 - 20)
        } else if dataWish.count == 2 {
            return CGSize(width: view.frame.width - 20, height: (collectionView.frame.height - 60 - 30) / 2)
        } else if dataWish.count == 3 {
            return CGSize(width: view.frame.width - 20, height: (collectionView.frame.height - 60 - 40) / 3)
        }
        
        return CGSize(width: view.frame.width/2 - 20, height: collectionView.frame.width/2 - 20)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var indexForPath: Int?
        
        if segue.identifier == "editGoal" {
            let cell = sender as! UITableViewCell
            let indexpath = tableView.indexPath(for: cell)
            indexForPath = (indexpath as NSIndexPath?)?.row
            
        } else if segue.identifier == "editGoalCollection" {
            let cell = sender as! CollectionViewCell
            let indexpath = collectionView.indexPath(for: cell)
            indexForPath = (indexpath as NSIndexPath?)?.row
        }
        
        let detailController: DetailViewController = segue.destination as! DetailViewController
        
        //передача параметров в принимающий контроллер
        detailController.index = indexForPath
        detailController.isEdition = true
    }
    
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
    
    
    @IBAction func longTapGesture(_ sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizerState.ended {
            return
        }
        
        let p = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: p)
        
        if indexPath != nil {
            // do stuff with your cell, for example print the indexPath
            let alert = UIAlertController(title: "Видалення", message: "Ви справді хочете видалити?", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Видалити", style: .destructive, handler: { (isDeleted) in
                
                DispatchQueue.main.async {
                    self.deleteCell(indexPath!)
                    self.refreshTable()
                }
            })
            let cancelAction = UIAlertAction(title: "Відмінити", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        } else {
            print("Could not find index path")
        }
        
        }
    
    
    func deleteCell(_ index: IndexPath) {
        Targets.clearItem(dataWish[(index as NSIndexPath).row].id!)
        dataWish.remove(at: (index as NSIndexPath).row)
    }

}

extension UITabBar {
    
    func setTabBarVisible(_ selfViewFrame: CGRect, visible: Bool) {
        let frame = self.frame   //.tabBar.frame
        let height = frame.size.height
        let offsetY = (visible ? -height : height)
        
        UIView.animate(withDuration: 0.8, animations: {
            self.frame = frame.offsetBy(dx: 0, dy: offsetY)
            self.frame = CGRect(x: 0, y: selfViewFrame.height + offsetY, width: frame.width, height: frame.height)
            self.setNeedsDisplay()
            self.layoutIfNeeded()
        }) 
    }

}
