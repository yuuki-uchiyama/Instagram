//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 内山由基 on 2018/06/09.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!//コメント数
    @IBOutlet weak var addCommentButton: UIButton!
    @IBOutlet weak var displayCommentButton: UIButton!
    
    var commentArray: [CommentData] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPostData(_ postData: PostData){

        self.postImageView.image = postData.image
        
        self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: postData.date!)
        self.dateLabel.text = dateString
        
        if postData.isLiked{
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        }else{
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
        let commentRef = Database.database().reference().child("comment:\(postData.id!)")
        commentRef.observe(.childAdded, with: { snapshot in
            let commentData = CommentData(snapshot: snapshot, myId: (Auth.auth().currentUser?.uid)!)
            self.commentArray.insert(commentData, at: 0)
            let newComment = self.commentArray.first
            if newComment != nil{
            self.commentLabel.text = "\((newComment?.commenter)!) : \((newComment?.comment)!)"
            }else{
                self.commentLabel.text = ""
            }
        })
    }
    
}
