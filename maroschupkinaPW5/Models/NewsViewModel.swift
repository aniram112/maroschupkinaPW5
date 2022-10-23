//
//  NewsViewModel.swift
//  maroschupkinaPW5
//
//  Created by Marina Roshchupkina on 22.10.2022.
//

import UIKit

final class NewsViewModel {
    let title: String
    let description: String
    let imageURL: URL?
    var imageData: Data? = nil
    init(title: String, description: String, imageURL: URL?) {
        self.title = title
        self.description = description
        self.imageURL = imageURL
    }
}
