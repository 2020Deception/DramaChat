//
//  API.swift
//  DramaChat
//
//  Created by Brian Sharrief Alim Bowman on 8/19/17.
//  Copyright © 2017 Brian Sharrief Alim Bowman. All rights reserved.
//

import Foundation

typealias completionBlock = (_ feed: Feed?)->()

class API {
    static let sharedAPI = API()
    
    private let timeoutInterval = 3.0
    private let fetchURL = URL(string: "http://localhost:3000/posts?_embed=comments")!
    private let postURLString =  URL(string: "http://localhost:3000/comments")!
    private let queue = DispatchQueue(label: "background",
                              qos: DispatchQoS.background,
                              attributes: DispatchQueue.Attributes.concurrent,
                              autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.workItem,
                              target: nil)
    
    final func fetchData(completion: @escaping completionBlock) {
        queue.async {
            self.urlSession().dataTask(with: self.fetchURLRequest()) { (data, response, error) in
                self.handler(data: data, response: response, error: error, completion: completion)
                }.resume()
        }
    }
    
    final func postData(comment:Comment!, completion: @escaping completionBlock) {
        if let data = postData(comment: comment) {
            queue.async {
                self.urlSession().dataTask(with: self.postURLRequest(postData: data)) { (data, response, error) in
                    self.handler(data: data, response: response, error: error, completion: completion)
                    }.resume()
                
            }
        } else {
            OperationQueue.main.addOperation {
                completion(nil)
            }
        }
    }
    
    final func cancelOperations() {
        urlSession().invalidateAndCancel()
    }
    
    final private func handler(data: Data?, response: URLResponse?, error: Error?, completion: @escaping completionBlock) {
        print(data as Any, response as Any, error as Any)
        if let data = data {
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? Array<Any>,
                let dict = json.first as? JSONDict,
                let commentsArray = dict["comments"] as? Array<JSONDict> {
                    let actor = Actor(dict: dict)
                    var comments = [Comment]()
                    for item in commentsArray {
                        comments.append(Comment(dict: item))
                    }
                    let feed = Feed(actor: actor, comments: comments)
                    OperationQueue.main.addOperation {
                        completion(feed)
                        self.urlSession().finishTasksAndInvalidate()
                    }
                    return
                }
            } catch {
                print("Error: \(error)")
            }
        }
        OperationQueue.main.addOperation {
            completion(nil)
            self.urlSession().finishTasksAndInvalidate()
        }
    }
    
    final private func urlSession() -> URLSession {
        return URLSession.shared
    }
    
    final private func fetchURLRequest() -> URLRequest {
        var req = URLRequest(url: fetchURL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: timeoutInterval)
        req.httpMethod = "GET"
        return req
    }
    
    final private func postURLRequest(postData: Data!) -> URLRequest {
        var req = URLRequest(url: postURLString, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: timeoutInterval)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "POST"
        req.httpBody = postData
        return req
    }
    
    final private func postData(comment:Comment!) -> Data? {
        var data: Data?
        do {
            let dict = ["body": comment.body!, "postId": comment.postId!] as [String : Any]
            data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        } catch {
            print("Error: \(error)")
        }
        return data
    }
    

}
