//
//  ViewController.swift
//  ExcelSoftServicesTask
//
//  Created by PASHA on 31/07/18.
//  Copyright © 2018 Pasha. All rights reserved.
//

import UIKit

import SwiftyJSON

struct Country : Codable {
    var countryName : String = ""
    var countryId : Int      = 0
    var countryCode : Int    = 0
    var countryShortName : String = ""
    var priority :Int  = 0
    
    
    init(json:JSON) {
        
        countryName = json["countryName"].stringValue
        countryId = json["countryId"].intValue
        countryCode = json["countryCode"].intValue
        countryShortName = json["countryShortName"].stringValue
        countryName = json["countryName"].stringValue
        priority = json["priority"].intValue
    }
}

struct Person {
    let name: String
    let address: String
    let age: Int
    let income: Double
    let cars: [String]
}

let peopleArray = [ Person(name:"Santosh", address: "Pune, India", age:34, income: 100000.0, cars:["i20","Swift VXI"]),
                    Person(name: "John", address:"New York, US", age: 23, income: 150000.0, cars:["Crita", "Swift VXI"]),
                    Person(name:"Amit", address:"Nagpure, India", age:17, income: 200000.0, cars:Array())]

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    
    
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var myTB: UITableView!
    
    @IBOutlet weak var stateTF: UITextField!
    
    var countries = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cars = peopleArray.map({$0.cars})
        let carsD = cars.map({$0}).reduce(["pop"],+)
        print(carsD)
        myTB.isHidden = true
        getCountryRequest()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func getCountryRequest() {
        
        guard  let url = URL(string: "https://pcapi.pyar.com/api/utils/countries") else { return }
        
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, response, error) in
            
            if let response = response
            {
                print(response)
            }
            if let data = data
            {
                
                do {
                    let json = try JSON(data: data)
                  //  print("my data is \(json)")
                     var i = 0
                    for arr in json.arrayValue{
                        self.countries.append(Country(json: arr))
                        print("countryname is : \(self.countries[i].countryName)")
                        i = i+1
                    }
                    
                }
                catch
                {
                    print(error)
                }
 
            }
            
            }.resume()
        
        
    }
    
    func getStateRequest() {
        
        guard  let url = URL(string: "https://pcapi.pyar.com/api/utils/gci/113/sid") else { return }
        
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, response, error) in
            
            if let response = response
            {
                print(response)
            }
            if let data = data
            {
                
                do {
                    let json = try JSON(data: data)
                    //  print("my data is \(json)")
                    var i = 0
                    for arr in json.arrayValue{
                        self.countries.append(Country(json: arr))
                        print("countryname is : \(self.countries[i].countryName)")
                        i = i+1
                    }
                    
                }
                catch
                {
                    print(error)
                }
                
            }
            
            }.resume()
        
        
    }
    
    @IBAction func dropdownTap(_ sender: Any) {
        DispatchQueue.main.async {
            self.myTB.isHidden = false
            self.myTB.reloadData()
        }
      
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.text = countries[indexPath.row].countryName
        
        return cell!
    }
    public func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
    }
    @IBAction func tapTF(_ sender: Any) {
    
       
        myTB.isHidden = false
        myTB.reloadData()
    
    }
    func postRequest() {
        
        guard let url = URL(string:"https://jsonplaceholder.typicode.com/posts" ) else { return }
        
        var request = URLRequest(url: url)
        
        let params = ["username":"pasha","tweet":"goods"]
        
        request.httpMethod = "POST"
        request.addValue("Application/Json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else { return }
        
        request.httpBody = httpBody
        
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            
            
            if let data = data
            {
                do{
                    
                    let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
                    print("post data is :\(jsonData)")
                }
                catch{
                    
                    print(error)
                }
                
            }
            }.resume()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

