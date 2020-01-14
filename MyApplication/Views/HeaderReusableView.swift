//
//  HeaderReusableView.swift
//  MyApplication
//
//  Created by Can Talay on 31.12.2019.
//  Copyright © 2019 Can Talay. All rights reserved.
//

import UIKit

class HeaderReusableView: UICollectionReusableView {
    
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    var heavyLabel = UILabel()
    var descriptionLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.fillSuperview()
        
        //VisualEffectView Properities
        addSubview(visualEffectView)
        visualEffectView.fillSuperview()
        visualEffectView.alpha = 0
        visualEffectViewBlur()
        
        //GradientView Properties
        setupGradientLayer()
    }
    
    ///GradientView
    func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5,1]
        
        //layer.addSublayer(gradientLayer)
        
        let gradientContainerView = UIView()
        addSubview(gradientContainerView)
        
        
        gradientContainerView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        gradientContainerView.layer.addSublayer(gradientLayer)
        //staticFrame
        gradientLayer.frame = self.bounds
        gradientLayer.frame.origin.y -= bounds.height
        
        
        heavyLabel.text = "Surf the web for courses"
        heavyLabel.font  = .systemFont(ofSize: 24, weight: .heavy)
        heavyLabel.textColor = .white
        
        
        descriptionLabel.text = "Go onto the website and buy more stuff otherwise a sad puppy dies if you don't"
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 0
        
        
        
        
        let stackView = UIStackView(arrangedSubviews: [heavyLabel,descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        
        addSubview(stackView)
        
        stackView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        
        
    }
    
    //VisualEffectView and Animators/////
    var animator: UIViewPropertyAnimator!
    
    fileprivate func visualEffectViewBlur() {
        
        animator = UIViewPropertyAnimator(duration: 3.0, curve: .linear, animations: { [self] in
            self.visualEffectView.alpha = 1
            
        })
        animator.fractionComplete = 0
        animator.pausesOnCompletion = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ////-------///////
    
}

//MARK: - extensionForUIView

extension UIView {
    func fillSuperview(withPadding padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            topAnchor.constraint(equalTo: superview.topAnchor, constant: padding.top).isActive = true
            leftAnchor.constraint(equalTo: superview.leftAnchor, constant: padding.left).isActive = true
            rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -padding.right).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -padding.bottom).isActive = true
        }
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero){
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        
    }
}
