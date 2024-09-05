//
//  ScrollViewAutolayout.swift
//  HelloMovieApp
//
//  Created by Grigory Sapogov on 05.09.2024.
//

import UIKit

class ScrollViewAutolayout: UIScrollView {
    
    let contentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
        self.layout()
    }
    
    func commonInit() {

    }
    
    private func layout() {
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(contentView)
        
        self.contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        self.contentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        self.contentView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0).isActive = true
        
    }
    
}
