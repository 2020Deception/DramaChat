//
//  LoadingImageView.swift
//  DramaChat
//
//  Created by Brian Sharrief Alim Bowman on 8/21/17.
//  Copyright © 2017 Brian Sharrief Alim Bowman. All rights reserved.
//

import UIKit

class LoadingImageView: UIImageView {

    override func awakeFromNib() {
        animationImages = [#imageLiteral(resourceName: "1"), #imageLiteral(resourceName: "2"), #imageLiteral(resourceName: "2"), #imageLiteral(resourceName: "1"), #imageLiteral(resourceName: "1"), #imageLiteral(resourceName: "2")]
        animationDuration = 3.0
        animationRepeatCount = 0
    }

}
