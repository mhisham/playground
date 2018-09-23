

class SignMainController: UIViewController {

 static func signupResponse(viewController:SignMainController, json:JSON,mobile:String?){
        
        //Response of activation sent
        if(json["key"].stringValue == "activation_sent"){
            let viewC = viewController.storyboard?.instantiateViewController(withIdentifier: "activationCode") as! ActivationCodeViewController // Activation Code View
            if json["msg"].string != nil {
                viewC.message = json["msg"].string
            }
            viewController.navigationController?.pushViewController(viewC, animated: true)//Open Activation Code
            return //Exit
        }
        if(json["key"].stringValue == "success"){ // Other requests Success..
            print("SUCCESS: \(json)")//Print the requiest in the console
            let loginAsView = viewController.storyboard?.instantiateViewController(withIdentifier: "loginAs") as! LoginAsViewController // Login As View
            
            if json["results"]["accounts"].arrayObject != nil { // IF there's accounts key in the results prepair it
                let accounts = json["results"]["accounts"].arrayValue
                var profileArr:[GsProfile] = []
                accounts.forEach({ (jsonProfile) in
                    let profile = GsProfile()
                    //Acount number / GS Number
                    profile.accountNumber = jsonProfile["username"].stringValue
                    //Password
                    profile.accountPassword = jsonProfile["password"].stringValue
                    //Balance
                    profile.balance = jsonProfile["balance"].floatValue
                    
                    //Expiration Date
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
                    profile.expiryDate = dateFormatter.date(from: jsonProfile["expire_date"].stringValue)
                    profileArr.append(profile)
                })
                loginAsView.gsNumbers = profileArr
            }
            
            if json["results"]["user"]["full_name"].string != nil { //If Any response has Full Name save it in user prefrences
                UserData.setFullName(json["results"]["user"]["full_name"].stringValue)
            }
            if json["results"]["user"]["email"].string != nil { //If Any response has Email save it in user prefrences
                UserData.setEmail(json["results"]["user"]["email"].stringValue)
            }
            
            //New GULFSIP and New Kuwait Connect
            if json["results"]["ask_for_free_account"].bool != nil && json["results"]["ask_for_free_account"].bool == true{ // If Respnse has ask_for free_account and = true
                loginAsView.newGsNumber = true // Pass true to the View
            }
            if json["results"]["ask_for_kuwait_connect"].bool != nil && json["results"]["ask_for_kuwait_connect"].bool == true{ // If Respnse has ask_for free_account and = true
                loginAsView.newKuwaitNumber = true // pass true to the view
            }
            viewController.navigationController?.pushViewController(loginAsView, animated: true) // Open Login As View
            return //Exit
        }
        
    }
}
