//
//CategoriesView.swift 
//
//DesafioCodigoIOS
//
//Created by Ignacio Schiefelbein on 24-08-31.
//Copyright © 2024 -. All rights reserved.
//

import UIKit

protocol CategoriesViewProtocol: UIView {
    func show(categories: [CategoryItemModel])
    func show(isLoading: Bool)
}

protocol CategoriesViewDelegate: AnyObject {
    func filter(categoryPath: String?)
    func close()
}

class CategoriesView: UIView {
    //MARK: View components
    let loadingView = UIBuilder.loadingView()
    
    let titleLabel = UIBuilder.multilineLabel("Categories", style: .title2, weight: .semibold, alignment: .left)
    
    let closeButton: UIButton =  UIBuilder.iconButton(systemName: "xmark", iconSize: 16)
    
    let tableView: UITableView = UITableView()
    
    //MARK: Properties
    lazy var dataSource: UITableViewDiffableDataSource = makeDataSource()
    
	weak var delegate: CategoriesViewDelegate?

    //MARK: Life cycle
	init(delegate: CategoriesViewDelegate) {
		self.delegate = delegate
		super.init(frame: .zero)
        setupView()
        setupActions()
        setupTableView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    
    //MARK: Actions
    @objc func closeButtonWasTapped() {
        delegate?.close()
    }
    
    private func setupView() {
        addSubview(titleLabel)
        addSubview(closeButton)
        addSubview(tableView)
        addSubview(loadingView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: closeButton.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 44 * 4),
            
            loadingView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
        ])

        backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 245/255, alpha: 0.75)

        closeButton.tintColor = .darkGray
        
        tableView.layer.cornerRadius = 16
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }
    
    private func setupActions() {
        closeButton.addTarget(self, action: #selector(closeButtonWasTapped), for: .touchUpInside)
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .white
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.reuseIdentifier)
        tableView.allowsSelection = false
    }
    
    private func makeDataSource() -> UITableViewDiffableDataSource<Int, CategoryItemModel> {
        UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, category in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as? CategoryCell else {
                return UITableViewCell()
            }
            cell.setup(title: category.name.capitalized) { [weak self] in
                self?.delegate?.filter(categoryPath: category.path)
            }
            return cell
        }
    }
}

extension CategoriesView: CategoriesViewProtocol {
    func show(categories: [CategoryItemModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CategoryItemModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(categories, toSection: 0)
        dataSource.apply(snapshot)
    }
    
    func show(isLoading: Bool) {
        if isLoading {
            loadingView.startAnimating()
        } else {
            loadingView.stopAnimating()
        }
    }
}
