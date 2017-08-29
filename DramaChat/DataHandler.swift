//
//  DataHandler.swift
//  DramaChat
//
//  Created by Brian Sharrief Alim Bowman on 8/28/17.
//  Copyright © 2017 Brian Sharrief Alim Bowman. All rights reserved.
//

import Foundation

struct DataHandler {
    /**
     inputs the data being parsed
     and returns an optional feed
     */
    static func buildFeed(data : Data) -> Feed? {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? Array<Any>,
                let dict = json.first as? JSONDict,
                let commentsArray = dict["comments"] as? Array<JSONDict> else {
                    return nil
            }
            let actor = Actor(dict: dict)
            var comments = [Comment]()
            for item in commentsArray {
                comments.append(Comment(dict: item))
            }
            let feed = Feed(actor: actor, comments: comments)
            return feed
        } catch {
            print("Error: \(error)")
        }
        return nil
    }
}
