//
//  LoginViewController.swift
//  Instagram
//
//  Created by 内山由基 on 2018/06/07.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class LoginViewController: UIViewController {
    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var displayNameTextField: UITextField!
    
    @IBAction func handleLoginButton(_ sender: Any) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text{
            if address.isEmpty || password.isEmpty{//パスワードやIDが入力されていない
                SVProgressHUD.showError(withStatus: "必要項目を入力してください")
                return
            }
            
            SVProgressHUD.show()
            
            Auth.auth().signIn(withEmail: address, password: password){ user, error in
                if let error = error{
                    print("DEBUG:" + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "サインインに失敗しました")
                    return
                }else{
                    print("DEBUG:ログイン成功")
                    SVProgressHUD.dismiss()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func handleCreateAccountButton(_ sender: Any) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text, let displayName = displayNameTextField.text{
            if address.isEmpty || password.isEmpty || displayName.isEmpty{
                print("DEBUG:何かが空です")
                SVProgressHUD.showError(withStatus: "必要項目を入力してください")
                return
            }
            
            SVProgressHUD.show()
            
            Auth.auth().createUser(withEmail: address, password: password){ user, error in
                if let error = error{
                    print("DEBUG:" + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "ユーザー作成に失敗しました")
                    return
                }
                
                print("DEBUG:ユーザー作成成功")
                let user = Auth.auth().currentUser
                if let user = user{//わからん
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = displayName
                    changeRequest.commitChanges{ error in//わからん
                        if let error = error{
                            print("DEBUG:" + error.localizedDescription)
                            SVProgressHUD.showError(withStatus: "表示名の設定に失敗しました")
                            return
                        }
                        print("DEBUG:[displayName = \(user.displayName!)]の設定に成功しました。")
                        SVProgressHUD.dismiss()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
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
