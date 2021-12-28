//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Artemiy Zuzin on 25.09.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import UIKit
import FirebaseAuth

final class ProfileViewController: UIViewController, Coordinatable {
    
    weak var tabBar: TabBarController?
    var callTabBar: (() -> Void)?
    
    private let footerView = ProfileTimerFooterView()
    private let headerView = ProfileHeaderView()
    private let logInViewControler = LogInViewController()
    private let cellid = "post"

    private var date: DateComponents? {
        didSet {
            if date!.second == -1 {
                date!.minute! -= 1
                date!.second = 59
            }
        }
    }
    
    private lazy var signOutButton: CustomButton = {
        let button = CustomButton(title: "Sign Out", color: .systemBlue,
                                  target: { [weak self] in self?.signOutButtonTaped() })
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private let exit: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "xmark"))
                
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = .white
        image.isHidden = true
        image.isUserInteractionEnabled = true
        image.alpha = 0
                
        return image
    }()
    
    private let translucentView: UIView = {
       let view = UIView()
        
        view.backgroundColor = .black
        view.alpha = 0
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        
        setupViews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
                
        if translucentView.isHidden == false {
            
            tapExit()
        }
    }
    
    private func setupViews() {
        view.addSubview(signOutButton)
        view.addSubview(tableView)
        view.addSubview(exit)
        
        view.insertSubview(headerView, at: 10)
                
        headerView.addSubview(translucentView)
        
        headerView.insertSubview(translucentView, at: 4)
                        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: cellid)
        
        let constraints = [signOutButton.topAnchor.constraint(equalTo:
                                                                view.safeAreaLayoutGuide.topAnchor),
                           signOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                           signOutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                           signOutButton.heightAnchor.constraint(equalToConstant: 50),
                           
                           tableView.topAnchor.constraint(equalTo: signOutButton.bottomAnchor),
                           tableView.bottomAnchor.constraint(equalTo:
                                                                view.safeAreaLayoutGuide.bottomAnchor),
                           tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                           tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                
                           translucentView.topAnchor.constraint(equalTo: view.topAnchor),
                           translucentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                           translucentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                           translucentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                           
                           exit.leadingAnchor.constraint(equalTo:
                                                            view.safeAreaLayoutGuide.leadingAnchor,
                                                         constant: 16),
                           exit.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                     constant: 16),
        
                           headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                           headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)]
        
        NSLayoutConstraint.activate(constraints)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapImage))
        
        headerView.avatarImageView.isUserInteractionEnabled = true
        
        headerView.avatarImageView.addGestureRecognizer(tapGesture)
        
        let tapExitGesture = UITapGestureRecognizer(target: self, action: #selector(tapExit))
        
        exit.addGestureRecognizer(tapExitGesture)
        
        var dateComponents  = DateComponents()
        
        dateComponents.minute = 1
        dateComponents.second = 30
        
        self.date = dateComponents

        let firstTimer = Timer(timeInterval: 90, repeats: true) { timer in
            let internetConnection = Bool.random()
            
            guard internetConnection else { preconditionFailure() }
            
            self.date!.minute = 1
            self.date!.second = 30
            
            self.footerView.timerLabel.text = "До обновления осталось: \(self.date!.minute!) минут \(self.date!.second!) секунд."
            
            let alertController = UIAlertController(title: "Страница была обновлена",
                                        message: nil,
                                        preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "ОК", style: .default)
            
            
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        let secondTimer = Timer(timeInterval: 1, repeats: true) { [self] timer in
            self.date!.second! -= 1
            
            self.footerView.timerLabel.text = "До обновления осталось: \(date!.minute!) минут \(date!.second!) секунд."
        }
        
        RunLoop.main.add(firstTimer, forMode: .common)
        RunLoop.main.add(secondTimer, forMode: .common)
    }
    
    private func signOutButtonTaped() {
        if FirebaseAuth.Auth.auth().currentUser != nil {
            do {
                try FirebaseAuth.Auth.auth().signOut()
                
                navigationController?.popViewController(animated: true)
                
                let alertController = UIAlertController(title: "Вы вышли из аккаунта", message: nil,
                                                        preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "ОК", style: .default)

                alertController.addAction(cancelAction)

                present(alertController, animated: true, completion: nil)
                
            } catch {
                let alertController = UIAlertController(title: "Произошла ошибка.",
                                            message: "Не получилось выйти из аккаунта.",
                                            preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "ОК", style: .default)

                alertController.addAction(cancelAction)

                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @objc private func tapImage() {
            
        translucentView.isHidden = false
        
        exit.isHidden = false
        
        tableView.isScrollEnabled = false

        UIView.animate(withDuration: 0.5, animations: { [self] in
            
            headerView.avatarImageView.transform = headerView.avatarImageView.transform.scaledBy(
                    x: view.safeAreaLayoutGuide.layoutFrame.width /
                        headerView.avatarImageView.frame.width,
                    y: view.safeAreaLayoutGuide.layoutFrame.width /
                        headerView.avatarImageView.frame.width)
            headerView.avatarImageView.frame.origin = CGPoint(
                x: view.safeAreaLayoutGuide.layoutFrame.minX, y: headerView.frame.minY)
           
            headerView.avatarImageView.layer.cornerRadius = 0
                    
            translucentView.alpha = 0.5
        })
        
        UIView.animate(withDuration: 0.3, delay: 0.5, animations: { self.exit.alpha = 1 })
    }
    
    @objc private func tapExit() {
        tableView.isScrollEnabled = true
        
        UIView.animate(withDuration: 0.5, animations: { [self] in
            
            headerView.avatarImageView.transform = .identity
            headerView.avatarImageView.frame.origin = CGPoint(x:
                                                            view.safeAreaLayoutGuide.layoutFrame.minX + 16,
                                                              y: headerView.frame.minY + 16)
            
            headerView.avatarImageView.layer.cornerRadius = headerView.avatarImageView.frame.width / 2
        
            translucentView.alpha = 0
        })
        
        UIView.animate(withDuration: 0.3, delay: 0.5, animations: { self.exit.alpha = 0 })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [self] in
            
            translucentView.isHidden = true
    
            exit.isHidden = true
        }
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) ->
    CGFloat{ 220 }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    { UITableView.automaticDimension }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    { headerView }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    { posts.count + 1 }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row != 0 else {
            let cell = PhotosTableViewCell()
            
            var image = [UIImageView]()
            
            for i in 0 ..< posts.count {
                
                image.append(UIImageView(image: UIImage(named: posts[i].image)))
            }
            
            cell.images = image
            
            return cell
        }
        
        let cell: PostTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellid,
                                          for: indexPath) as! PostTableViewCell
        
        cell.post = posts[indexPath.row - 1]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            let photosController = PhotosViewController()
            
            var images = [UIImageView]()
    
            for i in 0 ..< posts.count {
                images.append(UIImageView(image: UIImage(named: posts[i].image)))
            }
                
            photosController.imageViews = images
            
            navigationController?.pushViewController(photosController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        footerView.timerLabel.text = "До обновления осталось: \(date!.minute!) минут \(date!.second!) секунд."
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { 70 }
}
