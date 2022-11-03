//
//  ImagesCell.swift
//  SearchPhotosApp
//
//  Created by Vaishnavi Rathod on 02/11/22.
//

import Foundation
import UIKit
import SDWebImage
import AVKit

class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewPhoto: UIImageView!
    
    var isAnimated:Bool?
    var url: String? {
        didSet {
            if isAnimated ?? true {
                let activityIndicator: UIActivityIndicatorView =  UIActivityIndicatorView.init(style: .large)
                imageViewPhoto.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                activityIndicator.frame = imageViewPhoto.frame
                ImageManager.shared.createThumbnailOfVideoFromFileURL(videoURL: url ?? "", completionHandler: { (image, cached) in
                    
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                  self.imageViewPhoto.image = image
              }, placeholderImage: UIImage(named: "placeholder"))
            } else {
                imageViewPhoto.sd_imageIndicator = SDWebImageActivityIndicator.gray
                imageViewPhoto.sd_setImage(with: URL(string: url!), placeholderImage: UIImage(named: "placeholder.png"))
            }
        }
    }
    
    func configureCell(info: Photo?) {
        self.isAnimated = info?.isAnimated
        self.url = info?.link
    }
    
    override func prepareForReuse() {
        imageViewPhoto.image = #imageLiteral(resourceName: "placeHolder")
    }
}
