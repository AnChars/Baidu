//
//  TableView.swift
//  BaiDu_XA_GTZ_iOS
//
//  Created by AnChar on 16/9/22.
//  Copyright © 2016年 GG. All rights reserved.
//

import UIKit

class TableView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        self.backgroundColor=UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
