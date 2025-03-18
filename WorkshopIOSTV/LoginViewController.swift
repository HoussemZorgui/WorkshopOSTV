//
//  LoginViewController.swift
//  WorkshopIOSTV
//
//  Created by Khaled Guedria on 2/3/2022.
//  Copyright © 2022 Khaled Guedria. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //var
    
    
    //widget
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //action
    @IBAction func signinAction(_ sender: Any) {
        
        //1 : user defaults
        UserDefaults.standard.set(usernameField.text, forKey: "username")
        
        //2
        performSegue(withIdentifier: "loginSegue", sender: sender)
        
        
    }
    


}
