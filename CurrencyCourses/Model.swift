//
//  Model.swift
//  CurrencyCourses
//
//  Created by Zhenya Suharevich on 12.05.2020.
//  Copyright © 2020 Zhenya Suharevich. All rights reserved.
//

import UIKit

class Currency{
    var NumCode:String?
    var CharCode:String?
    
    var Nominal:String?
    var nominalDouble: Double?
    
    var Name:String?
    
    var Value:String?
    var valueDouble: Double?
    
    class func rouble()->Currency
    {
        let r = Currency()
        r.CharCode = "RUR"
        r.Name = "Российский рубль"
        r.Nominal = "1"
        r.nominalDouble = 1
        r.Value = "1"
        r.valueDouble = 1
        return r
    }
}

class Model: NSObject, XMLParserDelegate {
    static let shared = Model()
    var currencies: [Currency] = []
    var currentDate: String = ""
    
    var fromCurrency: Currency = Currency.rouble()
    var toCurrency: Currency = Currency.rouble()
    
    func convert(amount: Double?) -> String {
        if amount == nil{
            return ""
        }
        let d = ((fromCurrency.nominalDouble! * fromCurrency.valueDouble!)/(toCurrency.nominalDouble! * toCurrency.valueDouble!))*amount!
        return String(d)
    }
    
    var pathForXML : String {
        
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]+"/data.xml"     //проверяем загружен ли файл data.xml в библиотеку
        
        if FileManager.default.fileExists(atPath: path){   // если загружен то возвращаем путь к эот файлу
            return path
        }
        // если в библиотеки нет файла data.xml то возвращаем путь к файлн data.xml загружнного нами!
        return (Bundle.main.path(forResource: "data", ofType: "xml"))!  // ! потому что мы сами загружали этот файл и уверенны в том что он сузествует
    }
    var urlForXML : URL {
        return URL(fileURLWithPath: pathForXML)
    }
    
    //загрузка xml с cbr.ru  и сохранение его в каталоге приложений
    //http://www.cbr.ru/scripts/XML_daily.asp?date_req=02/03/2002
    func loadXMLFile(data: Date?){
        //проверяем дату если дата введена то берем в отдельном потоке и скачиваем данные по XML и загружаем их в нашу библиотеку с которой берутся файлы для парса
        var strUrl = "http://www.cbr.ru/scripts/XML_daily.asp?date_req="
        
        
        if data != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            strUrl = strUrl + dateFormatter.string(from: data!)
        }
        
        let url = URL(string: strUrl)
        
        
        let task = URLSession.shared.dataTask(with: url!) { (date, responce, error) in
            var errorGlobal : String?
            if error == nil {
                
                let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]+"/data.xml"
                
                let urlForSave = URL(fileURLWithPath: path)
                
                
                do{
                    print(path)
                    try date?.write(to: urlForSave)
                    self.parseXML()
                    print("Plik był pobrany.")
                    
                }
                catch{
                    print ("Error when save data:\(error.localizedDescription)")
                    errorGlobal = error.localizedDescription
                }
                
                
            }
            else{
                print ("Error when loadXMLFile: " + error!.localizedDescription)
                errorGlobal = error?.localizedDescription
            }
            if let errorGlobal = errorGlobal {
                NotificationCenter.default.post(name: NSNotification.Name("ErrorWhenXMLloadin"), object: self, userInfo: ["ErrorName":errorGlobal])

            }
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startLoadingXML"), object: self)
        task.resume()   // функция .resume выполняет наш task
        
    }
    
    
    //распарсить XML и положить его в currencies:[Currency] , отправить уведомление в приложение о том что данные обновились
    func parseXML(){
        currencies = [Currency.rouble()]
        let parser = XMLParser(contentsOf: urlForXML)
        parser?.delegate = self
        parser?.parse()
        

        print("Dane odświżone.")
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dataRefreshed"), object: self)
        for c in currencies{
            if c.CharCode == fromCurrency.CharCode{
                fromCurrency = c
            }
            if c.CharCode == toCurrency.CharCode{
                toCurrency = c
            }

        }
    }
    
    var currentCurrency: Currency?
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]){
        
        if elementName == "ValCurs"{
        
            if let currentDateString = attributeDict["Date"]{
                currentDate = currentDateString
            }
            
        }
        
        
        
        if elementName == "Valute" {
            currentCurrency = Currency()
        }
    }
    
    var currentCharacters: String = ""
    func parser(_ parser: XMLParser, foundCharacters string: String){
        if string == "Фунт стерлингов Соединенного королевства"{
            currentCharacters = "Фунт стерлингов"
            
        }
        else{
            currentCharacters = string
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        
        if elementName == "NumCode"{
            currentCurrency?.NumCode = currentCharacters
        }
        if elementName == "CharCode"{
            currentCurrency?.CharCode = currentCharacters
        }
        if elementName == "Nominal"{
            currentCurrency?.Nominal = currentCharacters
            currentCurrency?.nominalDouble = Double(currentCharacters.replacingOccurrences(of: ",", with: "."))
        }
        if elementName == "Name"{
            currentCurrency?.Name = currentCharacters
        }
        if elementName == "Value"{
            currentCurrency?.Value = currentCharacters
            currentCurrency?.valueDouble = Double(currentCharacters.replacingOccurrences(of: ",", with: "."))
        }
        if elementName == "Valute" {
            currencies.append(currentCurrency!)
        }
    }
    
    
}
