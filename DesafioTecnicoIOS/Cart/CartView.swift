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
    func show(cartProducts: [CartProductModel], animated: Bool)
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

    let tableView: UITableView = UITableView()
    
    //MARK: Properties
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
        addSubview(loadingView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0),
            
            loadingView.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])

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
    func show(cartProducts: [CartProductModel], animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CartProductModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(cartProducts, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    func show(isLoading: Bool) {
        if isLoading {
            loadingView.startAnimating()
        } else {
            loadingView.stopAnimating()
        }
    }
}
