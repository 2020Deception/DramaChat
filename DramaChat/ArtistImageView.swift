//
//  ArtistImageView.swift
//  DramaChat
//
//  Created by Brian Sharrief Alim Bowman on 8/21/17.
//  Copyright © 2017 Brian Sharrief Alim Bowman. All rights reserved.
//

import UIKit

class ArtistImageView: UIImageView {

    override init(image: UIImage?) {
        super.init(image: image)
        contentMode = .scaleAspectFit
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
