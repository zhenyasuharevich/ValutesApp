//
//  ViewController.swift
//  WeatherApp
//
//  Created by Zhenya Suharevich on 17.05.2020.
//  Copyright © 2020 Zhenya Suharevich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }


}
extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        searchBar.resignFirstResponder()
        
        print("Search pushed!")
        
        let urlString = "http://api.weatherstack.com/current?access_key=9466d3dc8e378b2427739d870cb816e8&query=\(searchBar.text!)"
        
        let url = URL(string: urlString)
        
        var locationName: String?
        var temp: Double?
        
        let task = URLSession.shared.dataTask(with: url!) { (data, responce, error) in
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                
                if let location = json["location"] {
                    locationName = location["name"] as? String
                    print(locationName!)
                    
                }
                
                if let current = json["current"]{
                    temp = current["temperature"] as? Double
                    print(temp!)
                    
                }
                DispatchQueue.main.async {
                    self.cityLabel.text = locationName!
                    self.temperatureLabel.text = String(temp!)
                }
                
            }
            catch let jsonError{
                print(jsonError)
            }
        }
        
        
        task.resume()
        
    }
    
}

