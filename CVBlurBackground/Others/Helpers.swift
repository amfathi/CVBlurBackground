//
//  Helpers.swift
//  CollectionWithBackground
//
//  Created by Ahmed Fathi on 5/31/20.
//  Copyright © 2020 Ahmed Fathi. All rights reserved.
//

import UIKit

extension Array {
    func contains(index: Int) -> Bool {
        index >= 0 && index < count
    }
}

enum Filters {
    
    private static var cache: [String: UIImage] = [:]
    
    static func prepareCache() {
        DispatchQueue.global(qos: .userInteractive).async {
            for game in mockGames {
                _ = game.blurredImage
            }
        }
    }
    
    static func blur(_ image: UIImage, id: String) -> UIImage? {
        
        if let cachedImage = cache[id] {
            return cachedImage
        }
        
        guard let cgImage = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
        
        guard let filter = CIFilter(name: "CIGaussianBlur") else { return nil }
        filter.setDefaults()
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(5, forKey: kCIInputRadiusKey)
        
        guard let outputCIImage = filter.outputImage else { return nil }
        let outputImage = UIImage(ciImage: outputCIImage)
        cache[id] = outputImage
        return outputImage
    }
    
}
