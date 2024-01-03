//
//  AppViewController.swift
//  appstore_app_page_with_diffable_datasource
//
//  Created by sunny on 01/01/24.
//

import UIKit

class AppViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var collectionView:UICollectionView!
    
    enum Section:Hashable {
        case apps(title:String)
    }
    
    //MARK: - Properties
    private var cellID = "AppCollectionViewCell"
    private var headerID = "AppCollectionReusableView"
    private var snapshot = NSDiffableDataSourceSnapshot<Section, Application>()
    
    private lazy var dataSource:UICollectionViewDiffableDataSource<Section, Application> = {
        let dataSource =  UICollectionViewDiffableDataSource<Section, Application>(collectionView: self.collectionView) { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as? AppCollectionViewCell else { return nil }
            
            cell.items = itemIdentifier
            
            return cell
                    
        }
        
        dataSource.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerID, for: indexPath) as? AppCollectionReusableView else {
                return nil
            }
            
            switch self.snapshot.sectionIdentifiers[indexPath.section]{
            case let .apps(title):
                headerView.lblTitle.text = title
            }
            
            return headerView
        }
        
        return dataSource
        
    }()
    
    private var loadingView:LoadingView!
    
    //MARK: - override
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
}

//MARK: - Func
extension AppViewController{
    
    private func configure(){
        let bundle = Bundle(for: LoadingView.self)
        let nib = bundle.loadNibNamed("LoadingView", owner: LoadingView.self, options: nil)
        self.loadingView = (nib?.first as! LoadingView)
        
        
        // Register Collection view cell and header
        self.collectionView.register(UINib(nibName: cellID, bundle: .main), forCellWithReuseIdentifier: cellID)
        self.collectionView.register(UINib(nibName: headerID, bundle: .main),
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: headerID)
        
        self.collectionView.collectionViewLayout = self.createLayout()
        self.getApplicationList()
    }
    
    private func createLayout() -> UICollectionViewLayout{
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1/3))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 2, leading: 0, bottom: 02, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                               heightDimension: .absolute(231))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                     subitems: [item])

        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                                    heightDimension: .estimated(100))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize,
                                                                     elementKind: UICollectionView.elementKindSectionHeader,
                                                                     alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.boundarySupplementaryItems = [headerItem]
        section.contentInsets = .init(top: 16, leading: 0, bottom: 16, trailing: 0)

        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
        
    }
    
    private func snapshot(topFee: [Application], appForThisSeason:[Application]){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Application>()
        
        snapshot.appendSections([.apps(title: "Top Free")])
        snapshot.appendItems(topFee, toSection: .apps(title: "Top Free"))
        
        snapshot.appendSections([.apps(title: "App For This Season")])
        snapshot.appendItems(appForThisSeason, toSection: .apps(title: "App For This Season"))
        
        self.snapshot = snapshot
        
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func getApplicationList(){
        Task{
            do {
                self.showLoadingView()
                let applications = try await API.shared.getApplicationList()
                
                let apps = applications[0..<applications.count / 2]
                let appForThisSeason = applications[applications.count / 2 ..< applications.count]
                
                self.snapshot(topFee: Array(apps), appForThisSeason: Array(appForThisSeason))
                self.hideLoadingView()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    
                })
                
            }catch{
                print(error)
                self.hideLoadingView()
            }
        }
    }
    
    private func showLoadingView(){
        
        self.view.addSubview(self.loadingView)
        
        self.loadingView.translatesAutoresizingMaskIntoConstraints = false
        self.loadingView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.loadingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.loadingView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.loadingView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        
        UIView.animate(withDuration: 0.25, animations: { self.loadingView.alpha = 0.8 })
    }
    
    private func hideLoadingView(){
        self.loadingView.removeFromSuperview()
    }
}

