//
//  FullScreenImageViewController.swift
//  SearchPhotosApp
//
//  Created by Vaishnavi Rathod on 03/11/22.
//

import Foundation
import UIKit
import SDWebImage

class FullScreenImageViewController:UIViewController {
    
    @IBOutlet weak var zoomableImageView: UIImageView!
    @IBOutlet weak var imageScrollView: UIScrollView!
    var photo:Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parseImage(url: photo?.link)
        
        imageScrollView.minimumZoomScale = 1.0
        imageScrollView.maximumZoomScale = 6.0
        
        //for zoom out of image
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImageView(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 2
        imageScrollView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func parseImage(url: String?) {
        let activityIndicator: UIActivityIndicatorView =  UIActivityIndicatorView.init(style: .large)
        zoomableImageView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.frame = zoomableImageView.frame
        ImageManager.shared.downloadImage(with: url ?? "", completionHandler: { (image, cached) in
              activityIndicator.stopAnimating()
              activityIndicator.removeFromSuperview()
            self.zoomableImageView.image = image
        }, placeholderImage: UIImage(named: "placeholder"))
    }
    
    
    @objc private func didTapImageView(_ sender: UITapGestureRecognizer) {
        let scale = min(imageScrollView.minimumZoomScale * 2, imageScrollView.maximumZoomScale)
        if scale != imageScrollView.zoomScale {
            let point = sender.location(in: zoomableImageView)
            
            let scrollSize = imageScrollView.frame.size
            let size = CGSize(width: scrollSize.width / scale,
                              height: scrollSize.height / scale)
            let origin = CGPoint(x: point.x - size.width / 2,
                                 y: point.y - size.height / 2)
            imageScrollView.zoom(to:CGRect(origin: origin, size: size), animated: true)
            print(CGRect(origin: origin, size: size))
        } else {
            imageScrollView.setZoomScale(1.0, animated: true)
        }
    }
}
//MARK:- UIScrollViewDelegate
extension FullScreenImageViewController:UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return zoomableImageView
    }
}
