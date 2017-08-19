//
//  StreamManager.swift
//  DramaChat
//
//  Created by Brian Sharrief Alim Bowman on 8/21/17.
//  Copyright © 2017 Brian Sharrief Alim Bowman. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit

class StreamManager: AVPlayerViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        let asset = AVAsset(url: URL(string: "https://s3.amazonaws.com/2020jsondemo/IMG_1552.m4v")!)
        let playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(failedToPlayToEndTime(n:)),
            name: Notification.Name.AVPlayerItemFailedToPlayToEndTime,
            object: player?.currentItem)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc final private func failedToPlayToEndTime(n: Notification) {
        let err = n.userInfo!["AVPlayerItemFailedToPlayToEndTimeErrorKey"] as? Error
        print(err as Any)
    }
    
}
