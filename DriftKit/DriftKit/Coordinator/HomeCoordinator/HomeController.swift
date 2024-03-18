//
//  ViewController.swift
//  DriftKit
//
//  Created by batuhan on 17.12.2023.
//

import UIKit

enum SectionType {
    case stories
    case posts

    var title : String {
        switch self {
        case .stories:
            return "Stories"
        case .posts:
            return "Posts"
        }
    }
}

protocol HomeControllerProtocol:AnyObject {
    func reloadData()
    func setCollection()
    func refreshControl()
    func fetching()
}

class HomeController: UIViewController{

    var viewModel   : HomeViewModel?
    private var sections = [SectionType]()
    
    private lazy var collectionView : UICollectionView        = {
        let cv = UICollectionView(frame: .zero,collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { index, layout in
            return self.compositionalLayoutSection(index: index)
        }))
        return cv
    }()
    
    private let spinner          : UIActivityIndicatorView = {
        let spinner              = UIActivityIndicatorView()
        spinner.tintColor        = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.viewDidLoad()
        sections.append(.stories)
        sections.append(.posts)
        title = "Social"
        view.addSubview(spinner)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.viewWillAppear()
    }
    
    @objc private func refreshCollectionView(){
        DispatchQueue.main.async {
//            self.fetching()
            self.reloadData()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    func fetching(){
        Task{
            await viewModel?.fetchingUsersPosts()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setLayout()
    }
    
    private func setLayout(){
        collectionView.frame = view.bounds
    }
    
    private func supplementaryHeaderView()->NSCollectionLayoutBoundarySupplementaryItem {
        return .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(20)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
    
    func compositionalLayoutSection(index:Int)->NSCollectionLayoutSection{
        let category = self.sections[index]
        
        switch category {
        case .stories:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(70), heightDimension: .absolute(70)), subitems: [item])
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing           = 10
            section.contentInsets               = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
            section.boundarySupplementaryItems  = [supplementaryHeaderView()]
            return section
        case .posts:
            
            let postItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            postItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0)
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.4)), subitems: [postItem])
            
            let section = NSCollectionLayoutSection(group: verticalGroup)
            section.contentInsets = .init(top: 10, leading: 0, bottom: 10, trailing: 0)
            return section
            
        }
    }
    

}
extension HomeController : UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
        case .stories:
            return /*viewModel?.storyCount ??*/ 1
        case .posts  :
            return viewModel?.postsCount ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let category = sections[indexPath.section]
        switch category{
        case .stories:
            if indexPath.row == 0{
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addStory", for: indexPath) as? StoryAddCell else { return UICollectionViewCell()}
                cell.delegate = self
                ImageManager.shared.getCacheForImage(forKey: .profileImage) {[weak self] image in
                    cell.userImage.image = image
                }
                return cell
            }else{
                guard let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCell.reuseIdentifier, for: indexPath) as? StoryCell else {
                    return UICollectionViewCell()}
//                cell.story = viewModel?.cellForRowForStories(indexPath: indexPath.item)
                return cell
            }
            
        case .posts:
            guard let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: PostsCell.reuseIdentifier, for: indexPath) as? PostsCell else {
                return UICollectionViewCell()}
            cell.post = viewModel?.cellForRow(indexPath: indexPath.row)
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cat = sections[indexPath.section]
        
        switch cat {
        case .stories:
            if indexPath.row == 0 {
                if let storyCount = viewModel?.myStories, storyCount > 0 {
                    viewModel?.showStoryController(storyIndex: indexPath.row)
                }else {
                    viewModel?.openCameraForStory()
                }
            }else {
                viewModel?.showStoryController(storyIndex: indexPath.row)
            }
        case .posts:
            viewModel?.showDetail(indexPath: indexPath.row)
      
        }
    }
}

extension HomeController:HomeControllerProtocol{
    
    func refreshControl(){
        let refreshControl            = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
    }
    
    func setCollection(){
        view.addSubview(collectionView)
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.register(PostsCell.self, forCellWithReuseIdentifier: PostsCell.reuseIdentifier)
        collectionView.register(StoryCell.self, forCellWithReuseIdentifier: StoryCell.reuseIdentifier)
        collectionView.register(StoryAddCell.self, forCellWithReuseIdentifier: "addStory")
    }
    
    func reloadData(){
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
      
    }
}

extension HomeController : StoryDelegate {
    func addStory() {
//        viewModel?.addStory()
    }
    
    
}

