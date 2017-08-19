//
//  Actor.swift
//  DramaChat
//
//  Created by Brian Sharrief Alim Bowman on 8/19/17.
//  Copyright © 2017 Brian Sharrief Alim Bowman. All rights reserved.
//

import Foundation

class Actor: BaseObject {
    var title: String!
    var imageURL: String!
    
    override init(dict: JSONDict) {
        super.init(dict: dict)
        title = dict["title"] as? String ?? ""
        imageURL = dict["imageURL"] as? String ?? ""
    }
}
