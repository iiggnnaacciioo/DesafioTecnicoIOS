//
//LandingPageView.swift 
//
//DesafioCodigoIOS
//
//Created by Ignacio Schiefelbein on 24-08-29.
//Copyright © 2024 -. All rights reserved.
//

import UIKit

protocol LandingPageViewProtocol: UIView {
    func show(highlightedItem: ProductModel, items: [ProductModel])
    func show(isLoading: Bool)
}

protocol LandingPageViewDelegate: AnyObject {
    func showProductDetail(selectedProductId: Int)
    func addToCart(selectedProductId: Int)
}

class LandingPageView: UIView {
    //MARK: View Components
    let loadingView: UIActivityIndicatorView = UIBuilder.loadingView()
    
    let topGradient: UIImageView = UIBuilder.imageView(image: UIImage(named: "gradient"))
            
    let bottomGradient: UIImageView = UIBuilder.imageView(image: UIImage(named: "gradient"))
            
    let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())

    //MARK: Properties
    lazy var dataSource: UICollectionViewDiffableDataSource = makeDataSource()
    
    weak var delegate: LandingPageViewDelegate?

    let margin: CGFloat = 16

    //MARK: Life cycle
	init(delegate: LandingPageViewDelegate) {
		self.delegate = delegate
		super.init(frame: .zero)
        
        setupView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    
    private func setupView() {
        setupCollectionView()

        addSubview(collectionView)
        addSubview(topGradient)
        addSubview(bottomGradient)
        addSubview(loadingView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        topGradient.translatesAutoresizingMaskIntoConstraints = false
        bottomGradient.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),

            topGradient.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            topGradient.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            topGradient.topAnchor.constraint(equalTo: self.collectionView.topAnchor),
            topGradient.heightAnchor.constraint(equalToConstant: 10),

            bottomGradient.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomGradient.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomGradient.bottomAnchor.constraint(equalTo: self.collectionView.bottomAnchor),
            bottomGradient.heightAnchor.constraint(equalToConstant: 10),

            loadingView.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        
        backgroundColor = .white
        collectionView.backgroundColor = .clear
        
        topGradient.contentMode = .scaleToFill
        topGradient.alpha = 0.1
        
        bottomGradient.contentMode = .scaleToFill
        bottomGradient.alpha = 0.1
        bottomGradient.transform = CGAffineTransform(scaleX: 1, y: -1)

    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0

        collectionView.collectionViewLayout = layout
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: margin, left: margin, bottom: margin * 2, right: margin)
        collectionView.register(LandingPageHighlightCell.self, forCellWithReuseIdentifier: LandingPageHighlightCell.reuseIdentifier)
        collectionView.register(LandingPageItemCell.self, forCellWithReuseIdentifier: LandingPageItemCell.reuseIdentifier)
    }

    private func makeDataSource() -> UICollectionViewDiffableDataSource<Int, ProductModel> {
        UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, model in
            var cell: LandingPageCellProtocol?
            if indexPath.section == 0 {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: LandingPageHighlightCell.reuseIdentifier, for: indexPath) as? LandingPageCellProtocol
            } else {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: LandingPageItemCell.reuseIdentifier, for: indexPath) as? LandingPageCellProtocol
            }
            
            cell?.setup(title: model.title,
                        price: model.formattedPrice,
                        imageURL: model.imageURL) { [weak self] in
                self?.delegate?.showProductDetail(selectedProductId: model.id)
            } addProductAction: { [weak self] in
                self?.delegate?.addToCart(selectedProductId: model.id)
            }

            return cell ?? UICollectionViewCell()
        }
    }
    
    private func resetCollectionView() {
        let snapshot = NSDiffableDataSourceSnapshot<Int, ProductModel>()
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension LandingPageView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.frame.size.width - margin * 2
        if indexPath.section == 0 {
            return CGSizeMake(collectionViewWidth, 220)
        } else {
            return CGSizeMake(collectionViewWidth / 2, 212)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets.zero
    }
}

//MARK: LandingPageViewProtocol
extension LandingPageView: LandingPageViewProtocol {
    func show(highlightedItem: ProductModel, items: [ProductModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ProductModel>()
        snapshot.appendSections([0, 1])
        snapshot.appendItems([highlightedItem], toSection: 0)
        snapshot.appendItems(items, toSection: 1)
        dataSource.apply(snapshot)
    }
    
    func show(isLoading: Bool) {
        if isLoading {
            resetCollectionView()
            loadingView.startAnimating()
        } else {
            loadingView.stopAnimating()
        }
    }
}

