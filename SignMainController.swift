

class SignMainController: UIViewController {

 static func signupResponse(viewController:SignMainController, json:JSON,mobile:String?){
        
        //Response of activation sent
        if(json["key"].stringValue == "activation_sent"){
            let viewC = viewController.storyboard?.instantiateViewController(withIdentifier: "activationCode") as! ActivationCodeViewController
            if json["msg"].string != nil {
                viewC.message = json["msg"].string
            }
            viewController.navigationController?.pushViewController(viewC, animated: true)
            return
        }
        if(json["key"].stringValue == "success"){
            print("SUCCESS: \(json)")
            let loginAsView = viewController.storyboard?.instantiateViewController(withIdentifier: "loginAs") as! LoginAsViewController
            if json["results"]["accounts"].arrayObject != nil {
                let accounts = json["results"]["accounts"].arrayValue
                var profileArr:[GsProfile] = []
                accounts.forEach({ (jsonProfile) in
                    let profile = GsProfile()
                    profile.accountNumber = jsonProfile["username"].stringValue
                    profile.accountPassword = jsonProfile["password"].stringValue
                    profile.balance = jsonProfile["balance"].floatValue
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
                    profile.expiryDate = dateFormatter.date(from: jsonProfile["expire_date"].stringValue)
                    profileArr.append(profile)
                })
                loginAsView.gsNumbers = profileArr
            }
            if json["results"]["user"]["full_name"].string != nil {
                UserData.setFullName(json["results"]["user"]["full_name"].stringValue)
            }
            if json["results"]["user"]["email"].string != nil {
                UserData.setEmail(json["results"]["user"]["email"].stringValue)
            }
            
            //New GULFSIP and New Kuwait Connect
            if json["results"]["ask_for_free_account"].bool != nil && json["results"]["ask_for_free_account"].bool == true{
                loginAsView.newGsNumber = true
            }
            if json["results"]["ask_for_kuwait_connect"].bool != nil && json["results"]["ask_for_kuwait_connect"].bool == true{
                loginAsView.newKuwaitNumber = true
            }
            viewController.navigationController?.pushViewController(loginAsView, animated: true)
            return
        }
        
    }
}
