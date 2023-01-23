//
//  ViewController.swift
//  SportzInteractive
//
//  Created by Neosoft on 20/01/23.
//

import UIKit

class MatchCenterViewController: UIViewController {
    
    @IBOutlet weak var fixtureTableView: UITableView!
    
    private var fixtureViewModel: FixtureViewModel?
    
    var fixtures: [MatchDetailResponse]? = [] {
        didSet {
            DispatchQueue.main.async {
                Spinner.stop()
                self.fixtureTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fixtureTableView.delegate = self
        fixtureTableView.dataSource = self
        
        fixtureViewModel = FixtureViewModel()
        fixtureViewModel?.delegate = self

        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = Constant.matchCenter
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(named: "BaseColor")
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.shadowColor = .clear
            navigationController?.navigationBar.tintColor = UIColor(named: "BaseColor")
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
    }
    
    func setupView() {
        let fixtureNib = UINib(nibName: Constant.fixtureTableViewCell, bundle: nil)
        fixtureTableView.register(fixtureNib, forCellReuseIdentifier: Constant.fixtureTableViewCell)
        
        fixtureViewModel?.fetchFixtureData()
        Spinner.start()
    }
}

extension MatchCenterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fixtures?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.fixtureTableViewCell, for: indexPath) as! FixtureTableViewCell
        cell.setupFixtureTableViewCell(matchDetailResponse: fixtures?[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = TeamDetailsViewModel(fixture: fixtures?[indexPath.row])
        let storyboard = UIStoryboard(name: Constant.teamDetailsVC, bundle: nil)
        let nextVC = storyboard.instantiateViewController(identifier: Constant.teamDetailsVC) { coder in
            return TeamDetailsViewController(coder: coder, viewModel: viewModel)
        }
        nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension MatchCenterViewController: FixtureViewModelOutput {
    func getFixtureData(data: [MatchDetailResponse]?) {
        self.fixtures = data ?? []
    }
}

