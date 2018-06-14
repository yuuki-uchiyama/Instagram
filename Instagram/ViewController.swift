//
//  ViewController.swift
//  Instagram
//
//  Created by 内山由基 on 2018/06/07.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit
import ESTabBarController
import Firebase
import FirebaseAuth


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTab()

    }
    
    func setupTab(){
        let tabBarController: ESTabBarController! = ESTabBarController(tabIconNames:["home", "camera", "setting"])
        
        tabBarController.selectedColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        tabBarController.buttonsBackgroundColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        tabBarController.selectionIndicatorHeight = 3
        
        addChildViewController(tabBarController)
        //↑ 親ViewにESTabBarを追加　↓はその際の設定（位置など）
        let tabBarView = tabBarController.view!
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        //AutoLayoutが使えるよう設定
        view.addSubview(tabBarView)
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tabBarView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tabBarView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tabBarView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tabBarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)])
        tabBarController.didMove(toParentViewController: self)
        //↑ 完了報告
        
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: "Home")
        let settingViewController = storyboard?.instantiateViewController(withIdentifier: "Setting")
        
        tabBarController.setView(homeViewController, at: 0)
        tabBarController.setView(settingViewController, at: 2)
        
        tabBarController.highlightButton(at: 1)
        tabBarController.setAction({
            let imageViewController = self.storyboard?.instantiateViewController(withIdentifier: "ImageSelect")
            self.present(imageViewController!, animated:true, completion: nil)}, at: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser == nil{
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(loginViewController!, animated: true, completion: nil)
            
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

