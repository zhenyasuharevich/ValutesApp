//
//  CoursesController.swift
//  CurrencyCourses
//
//  Created by Zhenya Suharevich on 12.05.2020.
//  Copyright © 2020 Zhenya Suharevich. All rights reserved.
//

import UIKit

class CoursesController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "dataRefreshed"), object: nil, queue: nil) { (notification) in
            
            DispatchQueue.main.async { // добавляем чтобы не высвечивалась ошибка!! (фиолетовая)
                self.tableView.reloadData()
                self.navigationItem.title = Model.shared.currentDate
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.pushRefreshAction(_:)))
            }
            
            
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "startLoadingXML"), object: nil, queue: nil) { (notification) in
            
            DispatchQueue.main.async { // добавляем чтобы не высвечивалась ошибка!! (фиолетовая)
                let activityIndicator = UIActivityIndicatorView(style: .medium)
                activityIndicator.startAnimating()
                self.navigationItem.rightBarButtonItem?.customView = activityIndicator
            }
            
            
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "ErrorWhenXMLloadin"), object: nil, queue: nil) { (notification) in
            let errorName = notification.userInfo?["ErrorName"]
            print(errorName!)
            DispatchQueue.main.async { // добавляем чтобы не высвечивалась ошибка!! (фиолетовая)
                //let alert = UIAlertController(title: "Error whe load XML", message: errorName as? String, preferredStyle: .actionSheet)
                //let actionOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                //alert.addAction(actionOK)
                //.present(alert, animated: true, completion: nil)
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.pushRefreshAction(_:)))
            }
            
            
        }
        navigationItem.title = Model.shared.currentDate
        Model.shared.loadXMLFile(data: nil)
    }

    
    @IBAction func pushRefreshAction(_ sender: Any) {
        Model.shared.loadXMLFile(data: nil)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Model.shared.currencies.count
    }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

            let coursesForCell = Model.shared.currencies[indexPath.row]
            cell.textLabel?.text = coursesForCell.Name
            cell.detailTextLabel?.text = coursesForCell.Value
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
