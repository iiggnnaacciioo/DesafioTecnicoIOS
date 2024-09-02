//
//  UIViewController + Extensions.swift
//  DesafioTecnicoIOS
//
//  Created by Ignacio Schiefelbein on 01-09-24.
//

import UIKit

protocol Toast: UIViewController {
    var toastView: ToastView? { get set }
}

extension Toast {
    func showToast(message : String, parentView: UIView?) {
        removeToast()
        
        toastView = ToastView(message: message)
        
        toastView?.translatesAutoresizingMaskIntoConstraints = false
        
        guard let toastView = toastView,
        let parentView = parentView else {
            return
        }
        
        parentView.addSubview(toastView)
        
        NSLayoutConstraint.activate([
            toastView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 32),
            toastView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -32),
            toastView.bottomAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.bottomAnchor, constant: -32),
        ])
        
        toastView.layer.cornerRadius = 16
        
        let work = DispatchWorkItem(block: { [weak self] in
            self?.fadeOut()
        })
        
        toastView.work = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3, execute: work)
    }
    
    private func fadeOut() {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.toastView?.alpha = 0
        }, completion: { [weak self] _ in
            self?.removeToast()
        })
    }
    
    private func removeToast() {
        toastView?.cancelWork()
        toastView?.removeFromSuperview()
        toastView = nil
        toastView?.layer.removeAllAnimations()
    }
}

class ToastView: UIView {
    let label:UILabel
    
    var labelWork: DispatchWorkItem?
    
    var work: DispatchWorkItem?
    
    init(message: String) {
        label = UIBuilder.multilineLabel(message, style: .subheadline, weight: .medium, alignment: .center)
        
        super.init(frame: .zero)
        
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        ])
        
        label.textColor = .white
        
        label.isHidden = true
        
        backgroundColor = .systemGray3
        
        
        let work = DispatchWorkItem(block: { [weak self] in
            self?.label.isHidden = false
        })
        labelWork = work
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: work)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cancelWork() {
        work?.cancel()
        labelWork?.cancel()
    }
}
