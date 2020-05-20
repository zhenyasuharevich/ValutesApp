//
//  SettingsController.swift
//  CurrencyCourses
//
//  Created by Zhenya Suharevich on 15.05.2020.
//  Copyright © 2020 Zhenya Suharevich. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var datePicker: UIDatePicker!

    @IBAction func pushCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func pushShowCourses(_ sender: Any) {
        Model.shared.loadXMLFile(data: datePicker.date)
        dismiss(animated: true, completion: nil)
    }
    
}
