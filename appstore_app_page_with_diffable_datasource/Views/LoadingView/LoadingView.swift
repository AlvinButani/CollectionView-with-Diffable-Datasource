//
//  LoadingView.swift
//  appstore_app_page_with_diffable_datasource
//
//  Created by sunny on 02/01/24.
//

import UIKit

class LoadingView:UIView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupUI()
    }
    
    
    func setupUI(){
        self.backgroundColor = .systemBackground
        self.alpha = 0
    }
}
