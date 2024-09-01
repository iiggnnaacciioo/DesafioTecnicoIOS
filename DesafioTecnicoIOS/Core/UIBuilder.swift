//
//  UIBuilder.swift
//  DesafioCodigoIOS
//
//  Created by Ignacio Schiefelbein on 30-08-24.
//

import UIKit

struct UIBuilder {
    static func multilineLabel(_ text: String, style: UIFont.TextStyle, weight: UIFont.Weight, alignment: NSTextAlignment, numberOfLines: Int = 3) -> UILabel {
        let l = UILabel()
        let font = UIFont.preferredFont(forTextStyle: style)
        l.font = UIFont.systemFont(ofSize: font.pointSize, weight: weight)
        l.textColor = .darkText
        l.text = text
        l.numberOfLines = numberOfLines
        l.textAlignment = alignment
        return l
    }
    
    static func singleLineLabel(size: CGFloat, weight: UIFont.Weight, alignment: NSTextAlignment = .left) -> UILabel {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: size, weight: weight)
        l.textColor = .darkText
        l.numberOfLines = 1
        l.textAlignment = alignment
        return l
    }
    
    static func imageView(image: UIImage?) -> UIImageView {
        let iv = UIImageView(frame: .zero)
        iv.contentMode = .scaleAspectFit
        iv.image = image
        return iv
    }
    
    static func view(color: UIColor) -> UIView {
        let iv = UIView(frame: .zero)
        iv.backgroundColor = color
        return iv
    }

    static func stackView(axis: NSLayoutConstraint.Axis, spacing: CGFloat, alignment: UIStackView.Alignment = .center, distribution: UIStackView.Distribution = .fill) -> UIStackView {
        let s = UIStackView(frame: .zero)
        s.axis = axis
        s.alignment = alignment
        s.distribution = distribution
        s.spacing = spacing
        return s
    }
    
    static func iconButton(systemName: String, iconSize: CGFloat) -> UIButton {
        let b = UIButton(frame: .zero)
        b.setImage(UIImage(systemName: systemName), for: .normal)
        b.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration.init(pointSize: iconSize), forImageIn: .normal)
        return b
    }
    
    static func loadingView() -> UIActivityIndicatorView {
        let l = UIActivityIndicatorView(style: .large)
        l.color = .gray
        l.hidesWhenStopped = true
        return l
    }
}
