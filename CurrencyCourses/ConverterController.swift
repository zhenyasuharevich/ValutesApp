//
//  ConverterController.swift
//  CurrencyCourses
//
//  Created by Zhenya Suharevich on 16.05.2020.
//  Copyright © 2020 Zhenya Suharevich. All rights reserved.
//

import UIKit

class ConverterController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    }
    
    @IBOutlet weak var labelCoursesForDate: UILabel!
    @IBOutlet weak var buttonFrom: UIButton!
    @IBOutlet weak var buttonTo: UIButton!
    @IBOutlet weak var textFrom: UITextField!
    @IBOutlet weak var textTo: UITextField!
    
    @IBAction func pushFromAction(_ sender: Any) {
        let nc =  storyboard?.instantiateViewController(withIdentifier: "selectedCurrencyNSID") as! UINavigationController
        (nc.viewControllers[0] as! SelectCurrencyController).flagCurrency = .from
        nc.modalPresentationStyle = .fullScreen
        present(nc, animated: true, completion: nil)
    }
    
    @IBAction func pushToAction(_ sender: Any) {
        let nc =  storyboard?.instantiateViewController(withIdentifier: "selectedCurrencyNSID") as! UINavigationController
        (nc.viewControllers[0] as! SelectCurrencyController).flagCurrency = .to
        nc.modalPresentationStyle = .fullScreen
        present(nc, animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        
        refreshButtons()
        textFromEditingChange(self)
        labelCoursesForDate.text = "Courses fo the date: \(Model.shared.currentDate)"
    }
    
    @IBAction func textFromEditingChange(_ sender: Any) {
        let amount = Double(textFrom.text!)
        textTo.text = Model.shared.convert(amount: amount)
    }
    
    
    func refreshButtons(){
        buttonFrom.setTitle(Model.shared.fromCurrency.CharCode, for:.normal)
        buttonTo.setTitle(Model.shared.toCurrency.CharCode, for:.normal)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
