//
//  PostData.swift
//  Instagram
//
//  Created by 内山由基 on 2018/06/09.
//  Copyright © 2018年 yuuki uchiyama. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class PostData: NSObject {
    var id: String?
    var image: UIImage?
    var imageString: String?
    var name: String?
    var caption: String?
    var date: Date?
    var likes: [String] = []
    var isLiked: Bool = false
    
    init(snapshot: DataSnapshot, myId: String){
        self.id = snapshot.key
        
        let valueDictionary = snapshot.value as! [String: Any]
        imageString = valueDictionary["image"] as? String
        image = UIImage(data: Data(base64Encoded: imageString!, options: .ignoreUnknownCharacters)!)
        
        self.name = valueDictionary["name"] as? String
        self.caption = valueDictionary["caption"] as? String
        
        let time = valueDictionary["time"] as? String
        self.date = Date(timeIntervalSinceReferenceDate: TimeInterval(time!)!)
        
        if let likes = valueDictionary["likes"] as? [String]{
            self.likes = likes
        }
        for likeId in self.likes{
            if likeId == myId{
                self.isLiked = true
                break
            }
        }
    }
}

class CommentData: NSObject{
    var id: String?
    var commenter: String?
    var comment: String?
    var date: Date?
    
    init(snapshot: DataSnapshot, myId: String) {
        self.id = snapshot.key
        
        let commentDictionary = snapshot.value as! [String: Any]
        
        self.commenter = commentDictionary["commenter"] as? String
        self.comment = commentDictionary["comment"] as? String
        
        let time = commentDictionary["time"] as? String
        self.date = Date(timeIntervalSinceReferenceDate: TimeInterval(time!)!)
        }
}
