//
//  PopularMovieVC.swift
//  iOSChallengeMovieApp
//
//  Created by Muhammed Emin Aydın on 2.06.2021.
//

import UIKit
import SDWebImage

private let reuseIdentifier = "Cell"

class PopularMovieViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    fileprivate let cellId = "cellId"
    fileprivate let footerId = "footerId"
    fileprivate var isMultiColumn = false
    fileprivate var pageId = 1
    fileprivate var lastPage = 1
    
    var movieResult: [MovieResult] = [] {
      didSet {
        DispatchQueue.main.async {
          self.collectionView.reloadData()
        }
      }
    }
    
    
    override func viewDidLoad() {
      super.viewDidLoad()
      configureViews()
      
      fetchMovies(page: pageId)
    }
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(true)
      // Set navigation title
      navigationController?.navigationBar.topItem?.title = "Popular Movies"
    }
    

    fileprivate func configureViews() {
      // Set background color
      collectionView.backgroundColor = .white
      
      // Register cells
      collectionView.register(PopularMovieCell.self, forCellWithReuseIdentifier: cellId)
      collectionView.register(PopularMovieFooterCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
    }
    
    // MARK: — Data fetch
    fileprivate func fetchMovies(page: Int) {
      Service.shared.fetchMovieDetail(page: page) { (res, err) in
        if let err = err {
          print("Popular movies fetch failed...", err)
        }
        
        if let res = res {
          self.movieResult += res.results
          self.lastPage = res.lastPage
          self.pageId = res.page
        }
      }
    }

    @objc fileprivate func handleDisplayModeBarButtonItem() {
      // switch display mode
      // isMultiColumn = isMultiColumn ? false : true
      if isMultiColumn {
        isMultiColumn = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "grid-mode"), style: .done, target: self, action: #selector(handleDisplayModeBarButtonItem))
      } else {
        isMultiColumn = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "list-mode"), style: .done, target: self, action: #selector(handleDisplayModeBarButtonItem))
      }
      collectionView.reloadData()
    }

    // MARK: - CollectionViewCell
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return movieResult.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PopularMovieCell
      cell.nameLabel.text = "  " + movieResult[indexPath.item].name
      
      // switch display mode
      var imageUrl = Service.getImageUrl(path: movieResult[indexPath.item].backdrop ?? "")
      if isMultiColumn {
        imageUrl = Service.getImageUrl(path: movieResult[indexPath.item].poster ?? "")
      }
      cell.posterImage.sd_setImage(with: URL(string: imageUrl))
      
      return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      let movieDetailsController = MovieDetailsViewController()
      movieDetailsController.movieResult = movieResult[indexPath.item]
      navigationController?.pushViewController(movieDetailsController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      var width = view.frame.width - 8
      var height: CGFloat = 250
      
      // switch display mode
      if isMultiColumn {
        width = (view.frame.width / 2) - 8
        height = height * 1.22
      }
      return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
      return UIEdgeInsets(top: 10, left: 4, bottom: 0, right: 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return 8
    }
    
    // MARK: - CollectionViewFooter
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
      let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath) as! PopularMovieFooterCell
      
      footer.loadMoreButton.addTarget(self, action: #selector(handleLoadMoreButtom), for: .touchUpInside)
      
      // Compare total page and check results array
      if pageId == lastPage || movieResult.isEmpty {
        footer.isHidden = true
        footer.isUserInteractionEnabled = false
      } else {
        footer.isHidden = false
        footer.isUserInteractionEnabled = true
      }
      return footer
    }
    
    @objc fileprivate func handleLoadMoreButtom() {
      // fetch next page
      fetchMovies(page: pageId + 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
      return CGSize(width: view.frame.width, height: 65)
    }
    
    // MARK: - Default initializer
    init() {
      super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    

}
