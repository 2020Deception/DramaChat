//
//  LoadingView.swift
//  DramaChat
//
//  Created by Brian Sharrief Alim Bowman on 8/21/17.
//  Copyright © 2017 Brian Sharrief Alim Bowman. All rights reserved.
//

import UIKit

typealias NextStepBlock = (()->())

class LoadingView: UIVisualEffectView {
    
    let timeInterval = 1.0

    @IBOutlet weak var imageView: LoadingImageView!
    @IBOutlet var edgeConstraint: NSLayoutConstraint!
    var zeroHeightConstraint: NSLayoutConstraint!
    
    public func show(nextStepBlock: NextStepBlock!) {
        
        if zeroHeightConstraint == nil {
            zeroHeightConstraint = heightAnchor.constraint(equalToConstant: 0)
        }
        
        zeroHeightConstraint.isActive = false
        edgeConstraint.isActive = true
        
        if isHidden == true {
            isHidden = false
        }
        
        imageView.startAnimating()
        
        UIView.animate(withDuration: timeInterval, animations: { 
            self.layoutIfNeeded()
        }) { (done) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                nextStepBlock()
            })
        }
        
    }
    
    public func hide(nextStepBlock: NextStepBlock? = nil) {
        edgeConstraint.isActive = false
        zeroHeightConstraint.isActive = true
        
        imageView.stopAnimating()
        
        UIView.animate(withDuration: timeInterval, animations: {
            self.layoutIfNeeded()
        }) { (done) in
            if let nextStepBlock = nextStepBlock {
                nextStepBlock()
            }
        }
        
    }

}
