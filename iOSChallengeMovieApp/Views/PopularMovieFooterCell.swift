//
//  PopularMovieFooterCell.swift
//  iOSChallengeMovieApp
//
//  Created by Muhammed Emin Aydın on 2.06.2021.
//

import UIKit

class PopularMovieFooterCell: UICollectionViewCell {
  
  // MARK: — Views
  let loadMoreButton: UIButton = {
    let btn = UIButton(type: .system)
    btn.setTitle("Load More", for: .normal)
    btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    btn.backgroundColor = UIColor.rgb(red: 229, green: 33, blue: 21)
    btn.titleLabel?.textColor = .white
    btn.clipsToBounds = true
    btn.layer.cornerRadius = 10
    btn.tintColor = .white
    return btn
  }()
  
  // MARK: — Override functions
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  // MARK: - Add views to subview
  fileprivate func setupViews() {
    addSubview(loadMoreButton)
    loadMoreButton.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
  }
  
  // MARK: - Default initializer
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
