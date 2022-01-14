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
import SwiftUI

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
        self.view.backgroundColor = .white
        self.navigationItem.title = "Save"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Применить фильтер",
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(rightBarButtonTapped))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Сбросить фильтер",
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(leftBarButtonAction))
        
        self.view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.bottom.trailing.leading.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func postsFilter(autor: String) {
        posts = posts.filter({ $0.title == autor })
    }
    
    private func save() {
        let context = persistentContainer.viewContext
            
        let fetchRequest: NSFetchRequest<CoreDataPosts> = CoreDataPosts.fetchRequest()
         
        context.perform { [ weak self ] in
            do {
                self?.posts = try context.fetch(fetchRequest)
                
                self?.tableView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func rightBarButtonTapped() {
        
        let alertController = UIAlertController(title: "Фильтер по автору поста",
                                    message: "Введите имя автора",
                                    preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.backgroundColor = .white
            textField.textColor = .black
            textField.tintColor = #colorLiteral(red: 0.3675304651, green: 0.5806378722, blue: 0.7843242884, alpha: 1)
            textField.placeholder = "Имя автора"
            textField.layer.borderColor = UIColor.black.cgColor
        }

        let firstAlertAction = UIAlertAction(title: "Добавить фильтер", style: .cancel) { [weak self] _ in
            
            self?.postsFilter(autor: (alertController.textFields?.first?.text)!)
            self?.tableView.reloadData()
        }
        
        let secondAlertAction = UIAlertAction(title: "Нет", style: .default)
        
        alertController.addAction(firstAlertAction)
        alertController.addAction(secondAlertAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func leftBarButtonAction() {
        
        let alertController = UIAlertController(title: "Удалить фильтр?",
                                    message: nil,
                                    preferredStyle: .alert)

        let firstAlertAction = UIAlertAction(title: "да", style: .cancel) { [weak self] _ in
            
            self?.save()
        }
        
        let secondAlertAction = UIAlertAction(title: "Нет", style: .default)
        
        alertController.addAction(firstAlertAction)
        alertController.addAction(secondAlertAction)
        
        present(alertController, animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let contextualAction = UIContextualAction(style: .normal, title: "Удалить") { [ weak self ] _, _, _ in
            
            let object = (self?.posts[indexPath.row])! as NSManagedObject
            let context = (self?.persistentContainer.viewContext)!
            let fetchRequest: NSFetchRequest<CoreDataPosts> = CoreDataPosts.fetchRequest()
            
            context.delete(object)
            
            context.perform {
                do {
                    try context.save()
                    
                    self?.posts = try context.fetch(fetchRequest)
                    
                    tableView.reloadData()
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        contextualAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [contextualAction])
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
