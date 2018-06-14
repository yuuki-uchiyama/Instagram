//
//  HomeViewController.swift
//  Instagram
//
//  Created by 内山由基 on 2018/06/07.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var tableView: UITableView!
    
    var postArray: [PostData] = []
    var indexPath: IndexPath?
    
    var observing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsSelection = false
        
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = UIScreen.main.bounds.width + 100
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG: viewWillAppear")
        
        if Auth.auth().currentUser != nil{
            if self.observing == false{
                let postsRef = Database.database().reference().child(Const.PostPath)
                postsRef.observe(.childAdded, with: { snapshot in
                    print("DEBUG: .childAddedイベント開始")
                    
                    if let uid = Auth.auth().currentUser?.uid{
                        let postData = PostData(snapshot: snapshot, myId: uid)
                        self.postArray.insert(postData, at: 0)
                        self.tableView.reloadData() 
                    }
                })
                postsRef.observe(.childChanged, with: { snapshot in
                    print("DEBUG: .childChangedイベント開始")
                    
                    if let uid = Auth.auth().currentUser?.uid{
                        let postData = PostData(snapshot: snapshot, myId: uid)
                        
                        var index: Int = 0
                        for post in self.postArray{
                            if post.id == postData.id{
                                index = self.postArray.index(of: post)!
                                break
                            }
                        }
                        self.postArray.remove(at: index)
                        self.postArray.insert(postData, at: index)
                        self.tableView.reloadData()
                    }
                })
                observing = true
            }
        }else{
            if observing == true {
                postArray = []
                tableView.reloadData()
                Database.database().reference().removeAllObservers()
                
                
                observing = false
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.setPostData(postArray[indexPath.row])
        
        cell.likeButton.addTarget(self, action:#selector(handleButton(_:forEvent:)), for: .touchUpInside)
        cell.addCommentButton.addTarget(self, action:#selector(newCommentSegue(_:forEvent:)), for: .touchUpInside)
        cell.displayCommentButton.addTarget(self, action:#selector(toCommentSegue(_:forEvent:)), for: .touchUpInside)

            return cell
    }
    
    @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent){
        print("DEBUG: likeボタンがタップされました")
        
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        let postData = postArray[indexPath!.row]
        
        if let uid = Auth.auth().currentUser?.uid{
            if postData.isLiked{
                var index = -1
                for likeId in postData.likes{
                    if likeId == uid{
                        index = postData.likes.index(of: likeId)!
                        break
                    }
                }
                postData.likes.remove(at: index)
            }else{
                postData.likes.append(uid)
            }
            let postRef = Database.database().reference().child(Const.PostPath).child(postData.id!)
            let likes = ["likes": postData.likes]
            postRef.updateChildValues(likes)
        }
    }
    
    @objc func newCommentSegue(_ sender: UIButton, forEvent event: UIEvent){
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        indexPath = tableView.indexPathForRow(at: point)
        
        performSegue(withIdentifier: "addCommentSegue", sender: nil)
        
    }
    
    @objc func toCommentSegue(_ sender: UIButton, forEvent event: UIEvent){
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        indexPath = tableView.indexPathForRow(at: point)
        
        performSegue(withIdentifier: "displayCommentSegue", sender: nil)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let commentViewController:CommentViewController = segue.destination as! CommentViewController
        commentViewController.postDataId = postArray[indexPath!.row].id!
        commentViewController.caption = postArray[indexPath!.row].caption!
        
        if segue.identifier == "addCommentSegue"{
            commentViewController.newComment = true

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwind(_ segue: UIStoryboardSegue){
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
