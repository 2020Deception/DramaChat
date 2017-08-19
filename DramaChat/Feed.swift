//
//  Feed.swift
//  DramaChat
//
//  Created by Brian Sharrief Alim Bowman on 8/21/17.
//  Copyright © 2017 Brian Sharrief Alim Bowman. All rights reserved.
//

import Foundation
import UIKit

struct Feed {
    var comments: [Comment]?
    var actor: Actor?
    init(actor: Actor?, comments: [Comment]?) {
        self.actor = actor
        self.comments = comments
    }
}
