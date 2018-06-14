//
//  SettingViewController.swift
//  Instagram
//
//  Created by 内山由基 on 2018/06/07.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit
import ESTabBarController
import Firebase
import FirebaseAuth
import SVProgressHUD

class SettingViewController: UIViewController {
    @IBOutlet weak var displayNameTextField: UITextField!
    
    @IBAction func handleChangeButton(_ sender: Any) {
        if let displayName = displayNameTextField.text{
            if displayName.isEmpty{
                SVProgressHUD.showError(withStatus: "表示名を入力してください")
                return
            }
            
            let user = Auth.auth().currentUser
            if let user = user{
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = displayName
                changeRequest.commitChanges{ error in
                    if let error = error{
                        SVProgressHUD.showError(withStatus: "表示名の変更に失敗しました")
                        print("DEBUG:" + error.localizedDescription)
                        return
                    }
                    print("DEBUG: [displayName = \(user.displayName!)]の設定に成功しました")
                    SVProgressHUD.showSuccess(withStatus: "表示名を変更しました")
                }
            }
        }
        self.view.endEditing(true)
    }
    @IBAction func handleLogoutButton(_ sender: Any) {
        try! Auth.auth().signOut()
        
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.present(loginViewController!, animated: true, completion: nil)
        
        let tabBarController = parent as! ESTabBarController
        tabBarController.setSelectedIndex(0, animated: false)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
