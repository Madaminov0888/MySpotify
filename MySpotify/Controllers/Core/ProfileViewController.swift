//
//  ProfileViewController.swift
//  MySpotify
//
//  Created by Muhammadjon Madaminov on 05/09/24.
//
import UIKit

class ProfileViewController: UIViewController {

    private let apiManager = APIManager()
    private var user: UserProfile? = nil
    private var playlists: [PlaylistModel] = [] {
        didSet {
            setUserProfileView()
        }
    }
    
    //UserProfile(country: "Uz", displayName: "Muhammad", email: "", explicitContent: .init(filterEnabled: false, filterLocked: false), externalUrls: .init(spotify: ""), followers: .init(href: "", total: 10), href: "", id: "23", images: [], product: "", type: "", uri: "")
    
    // Background view to hold the gradient layer
    private let backgroundGradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .csBackgroundColor

        setUserProfileView()

        //MARK: - Tasks
        tasks()
    }

    private func setUserProfileView() {
        self.view.addSubview(backgroundGradientView)
        backgroundGradientView.layer.addSublayer(gradientLayer)

        NSLayoutConstraint.activate([
            backgroundGradientView.topAnchor.constraint(equalTo: self.view.topAnchor),
            backgroundGradientView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            backgroundGradientView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            backgroundGradientView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        
        guard let user = user else { return }
        
        // Set up the background gradient view first
        
        // Setup user image or initials in the circle view
        if user.images.count > 0 {
            hstack.addArrangedSubview(circlePhoto)
        } else {
            circleNameLabel.text = user.displayName.first?.uppercased()
            hstack.addArrangedSubview(circleNameLabel)
        }
        
        
        // Setup display name label
        displayNameLabel.text = user.displayName
        followersLabel.text = "\(user.followers.total) followers"
        vstack.addArrangedSubview(displayNameLabel)
        vstack.addArrangedSubview(followersLabel)
        hstack.addArrangedSubview(vstack)

        self.view.addSubview(hstack)
        self.view.addSubview(toolbarHStack)
            
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        toolbarHStack.addArrangedSubview(changeButton)
        toolbarHStack.addArrangedSubview(shareButton)
        toolbarHStack.addArrangedSubview(threeDotsButton)
        toolbarHStack.addArrangedSubview(spacer)
        
        
        if playlists.count < 1 {
            self.view.addSubview(noItemsView)
            self.view.addSubview(checkOutLabel)
            
            NSLayoutConstraint.activate([
                noItemsView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
                noItemsView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
                noItemsView.topAnchor.constraint(equalTo: self.toolbarHStack.bottomAnchor, constant: 100),
                
                checkOutLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
                checkOutLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
                checkOutLabel.topAnchor.constraint(equalTo: self.noItemsView.bottomAnchor, constant: 20),
            ])
        }


        NSLayoutConstraint.activate([
            circleNameLabel.widthAnchor.constraint(equalToConstant: 120),
            circleNameLabel.heightAnchor.constraint(equalToConstant: 120),

            hstack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            hstack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            hstack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            hstack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            changeButton.widthAnchor.constraint(equalToConstant: 120),
            spacer.widthAnchor.constraint(equalToConstant: self.view.width/3),
            
            toolbarHStack.topAnchor.constraint(equalTo: self.hstack.bottomAnchor, constant: 20),
            toolbarHStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            toolbarHStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
        ])
    }

    private func tasks() {
        Task(priority: .high) {
            do {
                let user = try await apiManager.getUserProfile()
                let playlists = try await apiManager.getUserPlaylists()
                await MainActor.run {
                    self.user = user
                    self.playlists = playlists
                }
            } catch {
                print(error)
            }
        }
    }
    
    
    private let vstack: UIStackView = {
        let vstack = UIStackView()
        vstack.axis = .vertical
        vstack.distribution = .fill
        vstack.alignment = .leading
        vstack.spacing = 0
        vstack.translatesAutoresizingMaskIntoConstraints = false
        
        return vstack
    }()

    private let hstack: UIStackView = {
        let hstack = UIStackView()
        hstack.axis = .horizontal
        hstack.distribution = .fill
        hstack.alignment = .center
        hstack.spacing = 20
        hstack.translatesAutoresizingMaskIntoConstraints = false
        return hstack
    }()

    private let displayNameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.textColor = .white
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        return label
    }()
    
    private let followersLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    private let circlePhoto: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 100
        image.clipsToBounds = true
        return image
    }()

    private let circleNameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .brown
        label.font = .systemFont(ofSize: 55, weight: .semibold)
        label.layer.cornerRadius = 60
        label.clipsToBounds = true
        return label
    }()

    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemGreen.cgColor, UIColor.clear.cgColor]
        gradient.locations = [-0.3, 0.7]
        return gradient
    }()
    
    
    
    //MARK: - Toolbar
    private let changeButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Edit", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.setTitleColor(.systemGray2, for: .normal)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 18
        button.layer.borderColor = UIColor.systemGray2.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)
        button.setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: config), for: .normal)
        button.imageView?.tintColor = .systemGray2
        return button
    }()
    
    private let threeDotsButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)
        button.setImage(UIImage(systemName: "ellipsis", withConfiguration: config), for: .normal)
        button.imageView?.tintColor = .systemGray2
        return button
    }()
    
    private let toolbarHStack: UIStackView = {
        let hstack = UIStackView()
        hstack.axis = .horizontal
        hstack.distribution = .fill
        hstack.alignment = .leading
        hstack.alignment = .center
        hstack.spacing = 15
        hstack.translatesAutoresizingMaskIntoConstraints = false
        return hstack
    }()
    
    
    //MARK: -Content
    private let noItemsView: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "No recent activity."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let checkOutLabel: UILabel = {
        let label = UILabel()
        label.text = "Check out some new music now"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Ensure the gradient layer fits the entire background gradient view
        gradientLayer.frame = backgroundGradientView.bounds
    }
}



//MARK: For preview, you can delete it
public struct ProfileView: UIViewControllerRepresentable {
    public func makeUIViewController(context: Context) -> some UIViewController {
        return UINavigationController(rootViewController: ProfileViewController())
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}



import SwiftUI

struct RandomProfileView: View {
    var body: some View {
        ProfileView()
            .ignoresSafeArea()
    }
}


#Preview {
    RandomProfileView()
}
