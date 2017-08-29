//
//  API.swift
//  DramaChat
//
//  Created by Brian Sharrief Alim Bowman on 8/19/17.
//  Copyright © 2017 Brian Sharrief Alim Bowman. All rights reserved.
//

import Foundation

typealias completionBlock = (_ feed: Feed?)->()

struct API {
    static let sharedAPI = API()
    
    private let timeoutInterval = 3.0
    private let fetchURL = URL(string: "http://localhost:3000/posts?_embed=comments")!
    private let postURLString =  URL(string: "http://localhost:3000/comments")!
    private let queue = DispatchQueue(label: "background",
                              qos: DispatchQoS.background,
                              attributes: DispatchQueue.Attributes.concurrent,
                              autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.workItem,
                              target: nil)
    
     func fetchData(completion: @escaping completionBlock) {
        queue.async {
            URLSession.shared.dataTask(with: self.fetchURLRequest()) { (data, response, error) in
                self.handler(data: data, response: response, error: error, completion: completion)
                }.resume()
        }
    }
    
     func postData(comment:Comment!, completion: @escaping completionBlock) {
        if let data = postData(comment: comment) {
            queue.async {
                URLSession.shared.dataTask(with: self.postURLRequest(postData: data)) { (data, response, error) in
                    self.handler(data: data, response: response, error: error, completion: completion)
                    }.resume()
                
            }
        } else {
            OperationQueue.main.addOperation {
                completion(nil)
            }
        }
    }
    
     func cancelOperations() {
        URLSession.shared.invalidateAndCancel()
    }
    
     private func handler(data: Data?, response: URLResponse?, error: Error?, completion: @escaping completionBlock) {
        print(data as Any, response as Any, error as Any)
        func handle(_ feed: Feed?){
            OperationQueue.main.addOperation {
                completion(feed)
                URLSession.shared.finishTasksAndInvalidate()
            }
        }
        guard let data = data, let feed = DataHandler.buildFeed(data: data) else {
            handle(nil)
            return
        }
        handle(feed)
    }
    
     private func fetchURLRequest() -> URLRequest {
        var req = URLRequest(url: fetchURL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: timeoutInterval)
        req.httpMethod = "GET"
        return req
    }
    
     private func postURLRequest(postData: Data!) -> URLRequest {
        var req = URLRequest(url: postURLString, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: timeoutInterval)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "POST"
        req.httpBody = postData
        return req
    }
    
     private func postData(comment:Comment!) -> Data? {
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
