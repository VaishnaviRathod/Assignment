//
//  ViewController.swift
//  SearchPhotosApp
//
//  Created by Vaishnavi Rathod on 01/11/22.
//

import UIKit

class SearchCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!

    var imagesViewModel: ImagesViewModel? {
        didSet {
        }
    }
    
    func configureCell(info: PhotosResponse?) {
        self.titleLabel.text = info?.title
    }
    
    override func prepareForReuse() {
        
    }
}
