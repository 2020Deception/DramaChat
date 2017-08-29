//
//  BaseObject.swift
//  DramaChat
//
//  Created by Brian Sharrief Alim Bowman on 8/19/17.
//  Copyright © 2017 Brian Sharrief Alim Bowman. All rights reserved.
//

import Foundation

typealias JSONDict = [String:AnyObject?]

class BaseObject {
    var id: Int?
    init(dict:JSONDict?) {
        guard let dict = dict, let id = dict["id"] as? Int else { return }
        self.id = id
    }
}
