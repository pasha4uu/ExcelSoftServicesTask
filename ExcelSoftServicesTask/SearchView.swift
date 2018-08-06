//
//  SearchView.swift
//  ExcelSoftServicesTask
//
//  Created by PASHA on 01/08/18.
//  Copyright © 2018 Pasha. All rights reserved.
//

import UIKit
import SwiftyJSON

struct CountryA : Codable {
    var countryName : String = ""
    var countryId : Int      = 0
    var countryCode : Int    = 0
    var countryShortName : String = ""
    var priority :Int  = 0
    
    
    init(countryJson:JSON) {
        countryName = countryJson["countryName"].stringValue
        countryId = countryJson["countryId"].intValue
        countryCode = countryJson["countryCode"].intValue
        countryShortName = countryJson["countryShortName"].stringValue
        countryName = countryJson["countryName"].stringValue
        priority = countryJson["priority"].intValue
    }
}
struct StateA : Codable {
    var cityId : Int
    var countryId :Int
    var countryName : String
    var countryShortName : String
    var stateId : Int
    var stateName : String
    var stateShortName : String
//    var cityName : String
//    var zipCode : Int
//    var lat : Double
//    var long : Double
    
    
    init(stateJson:JSON) {
        
        cityId = stateJson["cityId"].intValue
        countryId = stateJson["countryId"].intValue
        countryName = stateJson["countryName"].stringValue
        countryShortName = stateJson["countryShortName"].stringValue
        stateId = stateJson["stateId"].intValue
        stateName = stateJson["stateName"].stringValue
        stateShortName = stateJson["stateShortName"].stringValue
        
       
    }
}


class SearchView:
UIViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var SSearchBar: UISearchBar!
    
    @IBOutlet weak var STB: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var myTB: UITableView!
   var countries = [CountryA]()
    var searchCountry = [String]()
    var searching = false
    
    var states = [StateA]()
     var searchStates = [String]()
    var SSearching = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
       
        myTB.isHidden = true
        STB.isHidden = true
         getRequest()
//         myTB.reloadData()
      
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func getRequest() {
        
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
                    let result = try JSON(data: data)
                    //  print("my data is \(result[0])")
                    var i = 0
                    for arr in result.arrayValue{
                      //  let cna = result[i]["countryName"]
                       self.countries.append(CountryA(countryJson: arr))
                        print("\( self.countries[i].countryName)")
                        i = i+1
                    }
                    
                }
                catch
                {
                    print(error)
                }
                
                DispatchQueue.main.async {
                    
                    self.myTB.reloadData()
                }
                
            }
            
            }.resume()
     
    }
    
    func getStateRequest(countryId:Int) {
        
        guard  let url = URL(string: "https://pcapi.pyar.com/api/utils/gci/\(countryId)/sid") else { return }
        
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, response, error) in
            
            if let response = response
            {
                print(response)
            }
            if let data = data
            {
                
                do {
                    let result = try JSON(data: data)
                    //  print("my data is \(result[0])")
                    var i = 0
                    for arr in result.arrayValue{
                        //  let cna = result[i]["countryName"]
                        self.states.append(StateA(stateJson: arr))
                        print("\( self.states[i].stateName)")
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
    
    
    
      public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
     {
        if searchBar == self.searchBar
        {
        myTB.isHidden = false
        myTB.reloadData()
        }
        else
        {
            STB.isHidden = false
            STB.reloadData()
        }
     }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar == self.searchBar {
            let  countryS = countries.map({$0.countryName})
            searchCountry = countryS.filter({$0.lowercased().prefix(searchText.count)==searchText.lowercased()})
            searching = true
            myTB.isHidden = false
            myTB.reloadData()
        }
        else{
            let  stateS = Array(Set(states.map({$0.stateName}))) 
            searchStates = stateS.filter({$0.lowercased().prefix(searchText.count)==searchText.lowercased()})
            SSearching = true
            STB.isHidden = false
            STB.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar == self.searchBar {
            searchBar.text = ""
            searching = false
            myTB.isHidden = true
            myTB.reloadData()
        }
        else{
            SSearchBar.text = ""
            SSearching = false
            STB.isHidden = true
            STB.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.myTB
        {
        if searching {
             return searchCountry.count
        }
        else
        {
        return countries.count
        }
       }
        else
        {
            if SSearching {
                return searchStates.count
            }
            else
            {
                return states.count
            }
          
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
         let SCell = tableView.dequeueReusableCell(withIdentifier: "SCELL")
        
        if tableView == self.myTB {
        if searching
        {
            cell?.textLabel?.text = searchCountry[indexPath.row]
        }
       else
        {
            cell?.textLabel?.text = countries[indexPath.row].countryName
        }
            return cell!
    }
        
        else
        {
            if SSearching
            {
                SCell?.textLabel?.text = searchStates[indexPath.row]
            }
            else
            {
                SCell?.textLabel?.text = states[indexPath.row].stateName
            }
            return SCell!
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.myTB
        {
            var countryId = 0
            
            print("number row is :\(indexPath.row)")
            if searching
            {
                searchBar?.text = searchCountry[indexPath.row]
              //  countryId = Int(searchCountry[indexPath.row])!
                
                let aa = countries.map({$0.countryName}).index(of: (searchBar?.text)!)
                let countryIds = countries.map({$0.countryId})
                
                countryId = countryIds[aa!]
                states.removeAll()
                SSearchBar.text = ""
                
            }
            else
            {
                searchBar?.text = countries[indexPath.row].countryName
                countryId = countries[indexPath.row].countryId
            }
            
            print("Country id  \(countryId)")
            getStateRequest(countryId: countryId)
            myTB.isHidden = true
        }
        
        else
        {
            if SSearching
            {
                SSearchBar?.text = searchStates[indexPath.row]
            }
            else
            {
                SSearchBar?.text = states[indexPath.row].stateName
            }
            STB.isHidden = true
            
        }
      
    }
}
