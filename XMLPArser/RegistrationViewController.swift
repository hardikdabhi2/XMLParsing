//
//  RegistrationViewController.swift
//  XMLPArser
//
//  Created by Hardik on 15/04/19.
//  Copyright © 2019 HardikDabhi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyXMLParser

class RegistrationViewController: UIViewController {

    @IBOutlet weak var tf_email:UITextField!
    @IBOutlet weak var tf_name:UITextField!
    @IBOutlet weak var tf_password:UITextField!
    @IBOutlet weak var tf_passwordConfirm:UITextField!
    
    var arrayBaseUrl = [String]()
    var isRegister = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Base url is ",self.arrayBaseUrl)
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnActionRegistration(_ sender:UIButton)
    {
        
        for api in self.arrayBaseUrl{
            
            let name = self.tf_name.text!
            let email = self.tf_email.text!
            let password = self.tf_password.text!
            let confirm = self.tf_passwordConfirm.text!
            
            let finalApi =  api+"join?action=join&name="+name+"&email="+email+"&password="+password+"&verify="+confirm
            
            self.doRegistration(withApi:finalApi)
        }
        //join?action=join&name=abc&email=junto06&password=123&verify=123
    }
    
    private func doRegistration(withApi url:String){
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseString { response in
                print(" - API url: \(String(describing: response.request))")   // original url request
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
    
}
