//
//  SaveViewController.swift
//  Navigation
//
//  Created by Artemiy Zuzin on 30.12.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import UIKit
import SnapKit
import CoreData

class SaveViewController: UIViewController, Coordinatable {
    
    var tabBar: TabBarController?
    var callTabBar: (() -> Void)?
    
    private var posts = [CoreDataPosts]()
    
    private let cellId = "save"
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PostModel")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error {

                fatalError("Unresolved error \(error)")
            }
        })
        
        return container
    }()
    
    private let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        save()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationItem.title = "Save"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: cellId)
        
        setupViews()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("save"),
                                               object: nil,
                                               queue: nil) { [weak self] _ in
            
            self?.save()
        }
    }
    
    private func setupViews() {
        self.view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.bottom.trailing.leading.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func save() {
        let context = persistentContainer.viewContext
            
        let fetchRequest: NSFetchRequest<CoreDataPosts> = CoreDataPosts.fetchRequest()
            
        do {
            posts = try context.fetch(fetchRequest)
            
            tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension SaveViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PostTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellId,
                                          for: indexPath) as! PostTableViewCell

        cell.post = ProfilePost(autor: posts[indexPath.row].title ?? "",
                                description: posts[indexPath.row].text ?? "",
                                image: posts[indexPath.row].imageName ?? "",
                                likes: Int(posts[indexPath.row].numberLikes),
                                views: Int(posts[indexPath.row].numberViews))

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Сохранённые посты:"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(posts.count)
        
        return posts.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
