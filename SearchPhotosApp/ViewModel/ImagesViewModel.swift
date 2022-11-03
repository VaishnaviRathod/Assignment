//
//  ImagesCellViewModel.swift
//  SearchPhotosApp
//
//  Created by Vaishnavi Rathod on 02/11/22.
//
import Foundation
import UIKit

struct ImagesViewModel {
    //MARK:- Properties
    var photosArray: PhotosResponse?
    
    var numberOfRows:Int {
        photosArray?.photos?.count ?? 0
    }
}

