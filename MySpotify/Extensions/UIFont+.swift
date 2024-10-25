//
//  UIFont+.swift
//  MySpotify
//
//  Created by Muhammadjon Madaminov on 11/10/24.
//
import UIKit
import Foundation

extension UIFont {
    func withWeight(_ weight: UIFont.Weight) -> UIFont {
        let descriptor = self.fontDescriptor.addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: weight]])
        return UIFont(descriptor: descriptor, size: self.pointSize) // Keeps the original size
    }
}
