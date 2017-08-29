//
//  Comment.swift
//  DramaChat
//
//  Created by Brian Sharrief Alim Bowman on 8/19/17.
//  Copyright © 2017 Brian Sharrief Alim Bowman. All rights reserved.
//

import Foundation

class Comment: BaseObject {
    var body: String?
    var postId: Int?
    
    override init(dict: JSONDict?) {
        super.init(dict: dict)
        guard let dict = dict else { return }
        self.body = dict["body"] as? String ?? ""
        guard let postId = dict["postId"] as? Int else { return }
        self.postId = postId
    }
    
}
