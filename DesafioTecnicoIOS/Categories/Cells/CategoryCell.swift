//
//  CategoryCell.swift
//  DesafioCodigoIOS
//
//  Created by Ignacio Schiefelbein on 31-08-24.
//

import UIKit

class CategoryCell: UITableViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
    
    //MARK: View components
    let titleLabel: UILabel = UIBuilder.multilineLabel("", style: .headline, weight: .regular, alignment: .left)

    //MARK: Properties
    var categoryAction: (() -> ())?
    
    //MARK: Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(title: String,
               categoryAction: @escaping() -> ()) {
        self.categoryAction = categoryAction

        titleLabel.text = title
    }

    //MARK: Actions
    @objc func cellWasTapped() {
        categoryAction?()
    }
    
    private func updateTitleLabel(isHighlighted: Bool) {
        if isHighlighted {
            titleLabel.textColor = UIColor(named: "BlueHighlightedColor")
        } else {
            titleLabel.textColor = UIColor.systemBlue
        }
    }

    private func setupView() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
                
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
        ])
        
        updateTitleLabel(isHighlighted: false)
        contentView.backgroundColor = .white
    }
    
    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellWasTapped))
        contentView.addGestureRecognizer(tapGesture)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        updateTitleLabel(isHighlighted: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        updateTitleLabel(isHighlighted: false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        updateTitleLabel(isHighlighted: false)
    }
}
