//
//  InfoViewController.swift
//  Navigation
//
//  Created by Artem Novichkov on 12.09.2020.
//  Copyright © 2020 Artem Novichkov. All rights reserved.
//

import UIKit
import SnapKit

final class InfoViewController: UIViewController, Coordinatable {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        firstCall()
        planetCall()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let firstURL = URL(string: "https://jsonplaceholder.typicode.com/todos/42")!
    private let planetURL = URL(string: "https://swapi.dev/api/planets/1/?format=json")!
    private let cellid = "resident"
        
    private var jsonFirstModel: InfoJsonModel? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.titleLabel.text = "1. \(self?.jsonFirstModel?.title ?? "Данные пока не полученны")"
            }
        }
    }
    
    private var jsonPlanetModel: InfoPlanetModel? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.orbitalPeriodLabel.text = "2. orbital period = \(self?.jsonPlanetModel?.orbitalPeriod ?? "nil")"
                
                self?.callPlanetResidents()
            }
        }
    }
    
    var callTabBar: (() -> Void)?
    weak var tabBar: TabBarController?
    
    private var infoPlanetResidentJsonModels = [InfoPlanetResidentJsonModel]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    private var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        
        view.backgroundColor = .white
        view.tintColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    private lazy var button: CustomButton = { [weak self] in
        let button = CustomButton(title: "Tap me",
                                  color: .clear,
                                  target: self!.showAlert)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        
        label.textColor = .white
        label.text = "1. Данные пока не полученны"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let orbitalPeriodLabel: UILabel = {
       let label = UILabel()
        
        label.textColor = .white
        label.text = "2. Данные пока не полученны"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBlue
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(InfoTableViewCell.self, forCellReuseIdentifier: cellid)
        
        setupViews()
        firstCall()
        planetCall()
    }
    
    private func setupViews() {
        view.addSubview(button)
        view.addSubview(titleLabel)
        view.addSubview(orbitalPeriodLabel)
        view.addSubview(tableView)
        
        button.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(10)
        })
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(button.snp.bottom).inset(-10)
        }
        
        orbitalPeriodLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).inset(-10)
        }
        
        tableView.snp.makeConstraints { make in
            make.bottom.trailing.leading.equalToSuperview()
            make.top.equalTo(orbitalPeriodLabel.snp.bottom).inset(-10)
        }
    }
    
    private func firstCall() {
        URLSession.shared.dataTask(with: firstURL) { [weak self] data, response, error in
            if let error = error {
                print(error.localizedDescription)
                
                return
            }
            
            guard let data = data else {
                print("error: data is equal to nil")
                
                return
            }
            
           
            let stringData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                
            self?.jsonFirstModel = InfoJsonModel(userId: stringData?["userId"] as! Int,
                                            id: stringData?["id"] as! Int,
                                            title: stringData?["title"] as! String,
                                            completed: stringData?["completed"] as! Bool)
        }.resume()
    }
    
    private func planetCall() {
        URLSession.shared.dataTask(with: planetURL) { [weak self] data, response, error in
            if let error = error {
                print(error.localizedDescription)
                
                return
            }
            
            guard let data = data else {
                print("error: data is equal to nil")
                
                return
            }
            
            let planetData = try? JSONDecoder().decode(InfoPlanetModel.self, from: data)
            
            self?.jsonPlanetModel = planetData
        }.resume()
    }
    
    private func callPlanetResidents() {
        
        jsonPlanetModel?.residents.forEach({ url in
            URLSession.shared.dataTask(with: URL(string: "\(url)?format=json")!) { [self] data, response, error in
                if let error = error {
                    print(error.localizedDescription)
                    
                    return
                }
                
                guard let data = data else {
                    print("error: data is equal nil")
                    
                    return
                }
                
                if infoPlanetResidentJsonModels.count >= 10 { return }
                
                if let residentData = try? JSONDecoder().decode(InfoPlanetResidentJsonModel.self,                                                             from: data) {
                    infoPlanetResidentJsonModels.append(residentData)
                }
            }.resume()
        })
    }
    
    @objc private func showAlert() {
        let alertController = UIAlertController(title: "Удалить пост?",
                                    message: "Пост нельзя будет восстановить",
                                    preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default) { _ in
            
            print("Отмена")
        }
        
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            
            print("Удалить")
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension InfoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoPlanetResidentJsonModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: InfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellid,
                                          for: indexPath) as! InfoTableViewCell
                
        cell.name = infoPlanetResidentJsonModels[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Tatooine residents:"
    }
}
