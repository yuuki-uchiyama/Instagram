//
//  CommentViewController.swift
//  Instagram
//
//  Created by 内山由基 on 2018/06/12.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commenterNameLabel: UILabel!
    @IBOutlet weak var newCommentTextField: UITextField!
    @IBOutlet weak var keyboardLayout: NSLayoutConstraint!
    
    
    let name = Auth.auth().currentUser?.displayName
    var postDataId: String = ""
    var caption = ""
    
    var commentArray: [CommentData] = []
    
    var newComment = false
    
    var scrollLenge: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTableView.dataSource = self
        commentTableView.delegate = self
        commentTableView.allowsSelection = false
        
        commenterNameLabel.text = name
        captionLabel.text = caption
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let commentRef = Database.database().reference().child("comment:\(postDataId)")

        commentRef.observe(.childAdded, with: { snapshot in
            let commentData = CommentData(snapshot: snapshot, myId: (Auth.auth().currentUser?.uid)!)
                self.commentArray.insert(commentData, at: 0)
            self.commentTableView.reloadData()
            })
        if newComment == true{
            newCommentTextField.becomeFirstResponder()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentTableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath)
        let comment = commentArray[indexPath.row]

        cell.textLabel?.text = "\(comment.commenter!) : \(comment.comment!)"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: comment.date!)
        cell.detailTextLabel?.text = dateString
        return cell
    }
    @objc func keyboardWillBeShown(notification:NSNotification) {
        if let keyboardFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
            scrollLenge = keyboardFrame.height
            if scrollLenge > keyboardLayout.constant{
            keyboardLayout.constant += scrollLenge

            UIView.animate(withDuration: 0.5, animations:{ self.view.layoutIfNeeded()})
            }
        }
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
        if  keyboardLayout.constant > scrollLenge{
            keyboardLayout.constant -= scrollLenge
            UIView.animate(withDuration: 0.5, animations:{ self.view.layoutIfNeeded()})
            scrollLenge = 0.0
            }
        }
    
    @IBAction func postCommentButton(_ sender: Any) {
        if newCommentTextField.text == ""{
            return
        }else{
        let time = Date.timeIntervalSinceReferenceDate
        
        let commentRef = Database.database().reference().child("comment:\(postDataId)")
        let commentDic = ["commenter": self.name, "comment": newCommentTextField.text!, "time": String(time)]
        commentRef.childByAutoId().setValue(commentDic)

        
        newCommentTextField.text = ""
        commentTableView.reloadData()
        view.endEditing(true)
        if  keyboardLayout.constant > scrollLenge{
            keyboardLayout.constant -= scrollLenge
            UIView.animate(withDuration: 0.5, animations:{ self.view.layoutIfNeeded()})
            scrollLenge = 0.0
            
            }
        }
        
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
