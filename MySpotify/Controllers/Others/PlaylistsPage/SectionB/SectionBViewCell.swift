//
//  SectionBViewCell.swift
//  MySpotify
//
//  Created by Muhammadjon Madaminov on 09/12/24.
//

import UIKit

class SectionBViewCell: UICollectionViewCell {
    static let identifier = "MusicsCellViewB"
    private let mediaManager = MediaDownloader()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private var coverImage:UIImageView = UIImageView()
    private var overrideTitle:UILabel = UILabel()
    private var overrideSubTitle:UILabel = UILabel()
}






//MARK: View
extension SectionBViewCell {
    private func setUpUI() {
        self.setOverrideTitle()
        self.setOverrideSubTitle()
        
    }
    
    
    
    
    private func setOverrideTitle() {
        overrideTitle.text = ""
        overrideTitle.font = .systemFont(ofSize: 20, weight: .semibold)
        overrideTitle.textColor = .white
        overrideTitle.numberOfLines = 1
        overrideTitle.textAlignment = .left
        overrideTitle.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setOverrideSubTitle() {
        overrideSubTitle.text = ""
        overrideSubTitle.font = .systemFont(ofSize: 15, weight: .regular)
        overrideSubTitle.textColor = .white
        overrideSubTitle.numberOfLines = 1
        overrideSubTitle.textAlignment = .left
        overrideSubTitle.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    private func setCoverImage() {
        coverImage.image = UIImage(named: "placeholder")
        coverImage.contentMode = .scaleAspectFill
        coverImage.clipsToBounds = true
        coverImage.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
