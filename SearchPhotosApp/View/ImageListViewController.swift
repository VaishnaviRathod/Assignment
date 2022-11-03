//
//  ImagesListViewController.swift
//  SearchPhotosApp
//
//  Created by Vaishnavi Rathod on 02/11/22.
//

import Foundation
import UIKit
class ImageListViewController: UIViewController {
    
    @IBOutlet weak var imageListCollectionView: UICollectionView!
    
    var imageViewModal  = ImagesViewModel()
    var cellId = "ImageCellView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageListCollectionView.reloadData()
    }
    
}
//MARK:- UICollectionViewDataSource,UICollectionViewDelegate
extension ImageListViewController : UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imageViewModal.numberOfRows
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageListCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImageCell
        cell.configureCell(info: imageViewModal.photosArray?.photos?[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        let fullScreenImageViewController = storyBoard.instantiateViewController(withIdentifier: "FullScreenImageViewController") as! FullScreenImageViewController
        fullScreenImageViewController.photo = imageViewModal.photosArray?.photos?[indexPath.row]
        self.navigationController?.pushViewController(fullScreenImageViewController, animated:true)
    }
    
    
}
//MARK:- UICollectionViewDelegateFlowLayout
extension ImageListViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width/2, height: self.view.frame.size.height/5)
    }
}
