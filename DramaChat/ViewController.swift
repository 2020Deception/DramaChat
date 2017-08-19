//
//  ViewController.swift
//  DramaChat
//
//  Created by Brian Sharrief Alim Bowman on 8/19/17.
//  Copyright © 2017 Brian Sharrief Alim Bowman. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    // tableView which contains the comments
    @IBOutlet weak var commentsTableView: UITableView!
    // loading view for initial load
    @IBOutlet weak var loadingView: LoadingView!
    // cell identifier
    fileprivate static let chatCellReuseIdentifier = "chatCell"
    // tableView header imageView
    fileprivate var artistView: ArtistImageView!
    // feed to be displayed
    fileprivate var feed: Feed?
    // refresh control
    private let refreshControl = UIRefreshControl()
    // Wrapper view controller for the custom input accessory view
    private let chatInputAccessoryViewController = UIInputViewController()
    // Custom Input Accessory View
    private let chatInputAccessoryView: TextEntryAccessoryView = {
        let view = TextEntryAccessoryView(frame: CGRect.zero, inputViewStyle: UIInputViewStyle.default)
        view.sendButton.addTarget(self, action: #selector(didTapSend(sender:)), for: UIControlEvents.touchUpInside)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentsTableView.rowHeight = UITableViewAutomaticDimension
        commentsTableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.interactive
        commentsTableView.backgroundView?.layer.zPosition -= 1;
        setRefreshControl()
        getData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        API.sharedAPI.cancelOperations()
    }
    
    // MARK: - Input accessory view
    
    override var inputAccessoryViewController: UIInputViewController? {
        chatInputAccessoryViewController.inputView = chatInputAccessoryView
        return chatInputAccessoryViewController
    }
    
    final private func sendMessage(message: String) {
        let comment = Comment(dict: ["body" : message as AnyObject, "postId": feed?.actor?.id as AnyObject])
        API.sharedAPI.postData(comment: comment) { (feed) in
            if let _ = feed, let _ = feed?.comments {
                self.parseFeed(feed: feed)
            } else {
                API.sharedAPI.fetchData(completion: { (feed) in
                    self.parseFeed(feed: feed)
                })
            }
        }
    }
    
    // MARK: - Data handling
    
    final private func setRefreshControl() {
        refreshControl.addTarget(self, action: #selector(getData(completion:)), for: UIControlEvents.valueChanged)
        commentsTableView.refreshControl = refreshControl
    }
    
    @objc
    final private func getData(completion: NextStepBlock? = nil) {
        loadingView.show {
            API.sharedAPI.fetchData { (feed) in
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
                self.parseFeed(feed: feed, parseArtist: true)
            }
        }
    }
    
    final private func parseFeed(feed: Feed?, parseArtist: Bool? = nil) {
        if let feed = feed {
            self.feed = feed
            if let parseArtist = parseArtist, parseArtist != false {
                self.setActor(actor: self.feed?.actor)
            }
            self.setComments(comments: self.feed?.comments)
        }
        loadingView.hide()
    }
    
    final private func setComments(comments: [Comment]?) {
        if let comments = comments, comments.count > 0 {
            commentsTableView.reloadData()
            let newIndexPath = IndexPath(row: commentsTableView.numberOfRows(inSection: 0) - 1, section: 0)
            commentsTableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
    }
    
    final private func setActor(actor: Actor?) {
        if let actor = actor {
            self.title = actor.title
            do {
                if let url = URL(string: actor.imageURL) {
                    let data = try Data(contentsOf: url)
                    self.setPic(image:  UIImage(data: data))
                }
            } catch {
                print("Error:\(error)")
            }
        }
    }
    
    final private func setPic(image: UIImage? = nil) {
        artistView = ArtistImageView(image:image == nil ? #imageLiteral(resourceName: "fallbackImage") : image)
        // add a random stream (should be some kind of video/promo pertaining to feed)
        let g = UITapGestureRecognizer(target: self, action: #selector(showStream))
        artistView .addGestureRecognizer(g)
    }
    
    // MARK: - Actions
    
    @IBAction func didTapAdd(_ sender: UIBarButtonItem) {
        chatInputAccessoryView.expandingTextView.becomeFirstResponder()
    }
    
    @objc
    final private func didTapSend(sender: Any) {
        let text = chatInputAccessoryView.expandingTextView.text!
        if !text.characters.isEmpty {
            sendMessage(message: text)
            chatInputAccessoryView.expandingTextView.text = ""
        }
    }
    
    @objc
    final private func showStream() {
        let controller = StreamManager()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - UIResponder overrides and key commands
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func becomeFirstResponder() -> Bool {
        let didBecome = super.becomeFirstResponder()
        return didBecome
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return view.frame.height / 6
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return artistView
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let commentsArray = feed?.comments else {
            return 0
        }
        return commentsArray.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.chatCellReuseIdentifier, for: indexPath) as! ChatItemTableViewCell
        
        if let chatItem = feed?.comments?[indexPath.row] {
            cell.textView.text = chatItem.body
        }
        cell.isFlip = indexPath.row % 2 == 0
        
        return cell
    }
    
}
