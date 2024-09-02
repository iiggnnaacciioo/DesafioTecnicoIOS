//
//CartView.swift 
//
//DesafioCodigoIOS
//
//Created by Ignacio Schiefelbein on 24-09-01.
//Copyright © 2024 -. All rights reserved.
//

import UIKit

protocol CartViewProtocol: UIView {
    func show(cartProducts: [CartProductModel], totalAmount: String, animated: Bool)
    func show(isLoading: Bool)
}

protocol CartViewDelegate: AnyObject {
    func addUnit(productId: Int)
    func removeUnit(productId: Int, currentQuantity: Int)
    func removeProduct(productId: Int)
}

class CartView: UIView {
    //MARK: View Components
    let loadingView: UIActivityIndicatorView = UIBuilder.loadingView()

    let topGradient: UIImageView = UIBuilder.imageView(image: UIImage(named: "gradient"))

    let tableView: UITableView = UITableView()
    
    let totalAmountView: CartTotalAmountView = CartTotalAmountView()
    
    //MARK: Properties
    var totalAmountBottomConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    lazy var dataSource: UITableViewDiffableDataSource = makeDataSource()

	weak var delegate: CartViewDelegate?

	init(delegate: CartViewDelegate) {
		self.delegate = delegate
		super.init(frame: .zero)
        setupView()
        setupTableView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    
    func setupView() {
        addSubview(tableView)
        addSubview(topGradient)
        addSubview(totalAmountView)
        addSubview(loadingView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        topGradient.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        totalAmountView.translatesAutoresizingMaskIntoConstraints = false

        totalAmountBottomConstraint = totalAmountView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 200)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0),

            topGradient.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            topGradient.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            topGradient.topAnchor.constraint(equalTo: self.tableView.topAnchor),
            topGradient.heightAnchor.constraint(equalToConstant: 10),

            totalAmountView.leadingAnchor.constraint(equalTo: leadingAnchor),
            totalAmountView.trailingAnchor.constraint(equalTo: trailingAnchor),
            totalAmountBottomConstraint,
            
            loadingView.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        
        topGradient.contentMode = .scaleToFill
        topGradient.alpha = 0.1
        
        tableView.backgroundColor = .white
        backgroundColor = .white
    }
    
    private func setupTableView() {
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.backgroundColor = .white
        tableView.register(CartProductCell.self, forCellReuseIdentifier: CartProductCell.reuseIdentifier)
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
    }
    
    private func makeDataSource() -> UITableViewDiffableDataSource<Int, CartProductModel> {
        UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, cartProduct in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CartProductCell.reuseIdentifier, for: indexPath) as? CartProductCell else {
                return UITableViewCell()
            }
            cell.setup(title: cartProduct.title, price: cartProduct.formattedPrice, imageURL: cartProduct.imageURL, quantity: cartProduct.quantity, increaseQuantity: { [weak self] in
                self?.delegate?.addUnit(productId: cartProduct.id)
            }, decreaseQuantity: { [weak self] in
                self?.delegate?.removeUnit(productId: cartProduct.id, currentQuantity: cartProduct.quantity)
            }, removeProduct: { [weak self] in
                self?.delegate?.removeProduct(productId: cartProduct.id)
            })
            return cell
        }
    }
}

extension CartView: CartViewProtocol {
    func show(cartProducts: [CartProductModel], totalAmount: String, animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CartProductModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(cartProducts, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: animated)
        
        totalAmountView.setup(text: totalAmount, isEnabled: !cartProducts.isEmpty)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.01, animations: { [weak self] in
            self?.totalAmountBottomConstraint.constant = 0
            self?.layoutIfNeeded()
        })
    }
    
    func show(isLoading: Bool) {
        if isLoading {
            loadingView.startAnimating()
        } else {
            loadingView.stopAnimating()
        }
    }
}
