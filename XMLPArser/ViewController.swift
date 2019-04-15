//
//  ViewController.swift
//  XMLPArser
//
//  Created by Hardik on 15/04/19.
//  Copyright © 2019 HardikDabhi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyXMLParser

class ViewController: UIViewController,XMLParserDelegate{
    var currentParsingElement = ""
    var arrayBaseURL = [String]()
    
    var isLogin = false
    
    @IBOutlet weak var tf_email:UITextField!
    @IBOutlet weak var tf_password:UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.getAllrequest()
    }
    @IBAction func btnActionLogin(_ sender:UIButton)
    {
            let api = "?login"
            let email = self.tf_email.text!
            let password = self.tf_password.text!
//        login?action=login&email=junto06&password=123
        for baseUrl in self.arrayBaseURL{
            let finalURL = baseUrl+"login?action=login&email="+email+"&password="+password
            
            self.doLogin(withBaseUrlandApi:finalURL)
        }
        
    }
    
    
    @IBAction func btnActionRegistration(_ sender:UIButton)
    {
        let SB = UIStoryboard.init(name: "Main", bundle:nil)
        let registration = SB.instantiateViewController(withIdentifier:"registration") as! RegistrationViewController
        for i in self.arrayBaseURL{
            registration.arrayBaseUrl.append(i)
        }
        self.navigationController?.pushViewController(registration, animated:true)
        
    }
    
    
    
    private func doLogin(withBaseUrlandApi url:String){
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseString { response in
                print(" - API url: \(String(describing: response.request!))")   // original url request
                var statusCode = response.response?.statusCode
                switch response.result {
                case .success:
                    print("status code is: \(String(describing: statusCode!))")
                    print(response.result.value!)
                    
                case .failure(let error):
                    statusCode = error._code // statusCode private
                    print("status code is: \(String(describing: statusCode))")
                    print(error)
                }
        }
    }
    
    
    
    private func getAllrequest(){
        
        let url = "https://ipdns.us/check1two-rest-api/get-list-of-servers"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseString { response in
                print(" - API url: \(String(describing: response.request!))")   // original url request
                var statusCode = response.response?.statusCode
                switch response.result {
                case .success:
                    print("status code is: \(String(describing: statusCode!))")
                    print(response.result.value!)
                    
                    let parser = XMLParser(data: response.data!)
                    parser.delegate = self
                    if(parser.parse()){
                        print("XML Parsing Response",self.currentParsingElement)
                    }
                    
                case .failure(let error):
                    statusCode = error._code // statusCode private
                    print("status code is: \(String(describing: statusCode))")
                    print(error)
                }
        }
        
        }
    
    //MARK:- XML Delegate methods
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentParsingElement = elementName
        if elementName == "servers" {
            print("Started parsing...")
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let foundedChar = string.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
        
        if (!foundedChar.isEmpty) {
            if currentParsingElement == "server" {
                print("You just entered in server")
            }
            else if currentParsingElement == "id" {
                print("ID is:--->",foundedChar)
            }
            else if currentParsingElement == "url" {
                    print("ID is:--->",foundedChar)
                self.arrayBaseURL.append(foundedChar)
            }
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "servers" {
            print("Final base url data is",self.arrayBaseURL)
            print("Ended parsing...")
            
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        DispatchQueue.main.async {
            // Update UI
            
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("parseErrorOccurred: \(parseError)")
    }
    
    
    }
    




//Required XML Parser String
/*
baseURl api ->https://ipdns.us/check1two-rest-api/get-list-of-servers

the above apis will return a list of servers that we need to store in storage and will use as baseURl.

for each below apis, we need to use oen by one server and in case there is an error we will use seoncd third etc.

P.S Note we need to get baseURl from from storage and in case there is an error we will use next available server. and if there is no more server then we will return default value that there is an error.

login api ->login?action=login&email=junto06&password=123

signup api ->join?action=join&name=abc&email=junto06&password=123&verify=123
*/
