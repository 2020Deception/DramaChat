//
//  ChatItemTableViewCell.swift
//  DramaChat
//
//  Created by Brian Sharrief Alim Bowman on 8/21/17.
//  Copyright © 2017 Brian Sharrief Alim Bowman. All rights reserved.
//

import UIKit

class ChatItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var flippableView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var bubbleImageView: UIImageView! // Image TBD!
    
    var isFlip: Bool = false {
        didSet {
            textView.textAlignment = isFlip ? .left : .right
            flippableView.semanticContentAttribute = isFlip ? .forceRightToLeft : .forceLeftToRight
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.clear
    }

}
