//
//  ViewController.swift
//  SearchPhotosApp
//
//  Created by Vaishnavi Rathod on 01/11/22.
//

import UIKit

class SearchViewController: UIViewController {
    
    //MARK:- Elements
    @IBOutlet weak var collectionViewPhotos: UICollectionView!
    @IBOutlet var viewNoRecord: UIView!
    let searchController = UISearchController(searchResultsController: nil)
    
    //MARK:- variables
    var cellId = "SearchCellView"
    var photosViewModel :SearchViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        photosViewModel = SearchViewModel(apiManager: APIManager())
        self.photosViewModel.getPhotosBySearch( searchText: "dogs")
        self.setupSearchController()
        
        self.handleApiErrorResponse()
        self.handleApiSuccessResponse()
        
        searchController.searchBar.compatibleSearchTextField.backgroundColor = .white
        searchController.searchBar.tintColor = .white
        
        
    }
    
   
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Photos"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    /// Handling Error
    func handleApiErrorResponse() {
        photosViewModel.bindAPIErrorResponse = { [weak self] in
            DispatchQueue.main.async {
                if let self = self {
                    AlertManager.showErrorAlert(with: self.photosViewModel.error?.localizedDescription ?? "", view: self)
                }
            }
        }
    }
    
    func handleApiSuccessResponse() {
        photosViewModel.bindAPISuccessResponse = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionViewPhotos.reloadData()
                self?.handleEmptyData()
            }
        }
    }
    
    func handleEmptyData() {
        
        if photosViewModel.response?.searchedData?.isEmpty == true  {
            self.collectionViewPhotos.backgroundView = self.viewNoRecord
        }
        else {
            self.collectionViewPhotos.backgroundView = nil
        }
    }
    
    func fetchPhotos(_ text:String) {
        print(text)
        var pendingRequestWorkItem: DispatchWorkItem?
        pendingRequestWorkItem?.cancel()
        let requestWorkItem = DispatchWorkItem { [weak self] in
            if pendingRequestWorkItem?.isCancelled == false {
                self?.photosViewModel.getPhotosBySearch( searchText: text)
            }
        }
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1),
                                      execute: requestWorkItem)
    }

}
//MARK:- UISearchResultsUpdating, UISearchControllerDelegate
extension SearchViewController: UISearchResultsUpdating,UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            if searchText.isEmpty == false {
                fetchPhotos(searchText)
            } else {
                self.photosViewModel.getPhotosBySearch( searchText: "dogs")
                self.handleApiErrorResponse()
                self.handleApiSuccessResponse()
                if photosViewModel.numberOfRows() > 0 {
                    collectionViewPhotos.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
            searchBar.text = nil
            searchBar.showsCancelButton = false

            searchBar.endEditing(true)

            self.photosViewModel.getPhotosBySearch( searchText: "dogs")
            self.handleApiErrorResponse()
            self.handleApiSuccessResponse()
            
        }
}

//MARK:- UISearchBar
extension UISearchBar {

    // Due to searchTextField property who available iOS 13 only, extend this property for iOS 13 previous version compatibility
    var compatibleSearchTextField: UITextField {
        guard #available(iOS 13.0, *) else { return legacySearchField }
        return self.searchTextField
    }

    private var legacySearchField: UITextField {
        if let textField = self.subviews.first?.subviews.last as? UITextField {
            // Xcode 11 previous environment
            return textField
        } else if let textField = self.value(forKey: "searchField") as? UITextField {
            // Xcode 11 run in iOS 13 previous devices
            return textField
        } else {
            // exception condition or error handler in here
            return UITextField()
        }
    }
}

//MARK:- UICollectionViewDataSource,UICollectionViewDelegate
extension SearchViewController : UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosViewModel.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewPhotos.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchCell
        cell.configureCell(info: photosViewModel.response?.searchedData?[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        let imagesListViewController = storyBoard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImageListViewController
        imagesListViewController.imageViewModal.photosArray = photosViewModel.response?.searchedData?[indexPath.row]
        self.navigationController?.pushViewController(imagesListViewController, animated:true)
        
    }
    
}
//MARK:- UICollectionViewDelegateFlowLayout
extension SearchViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 60)
    }
}
