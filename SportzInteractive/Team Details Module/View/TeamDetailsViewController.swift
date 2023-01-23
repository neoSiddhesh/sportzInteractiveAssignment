//
//  TeamDetailsVC.swift
//  SportzInteractive
//
//  Created by Neosoft on 23/01/23.
//

import UIKit

class TeamDetailsViewController: UIViewController {
    
    @IBOutlet weak var teamDetailsTableView: UITableView!
    
    private var viewModel: TeamDetailsViewModel?
    private var filterButton = UIBarButtonItem()
    
    var displayPlayers: DisplayPlayers = .allPlayers
        
    init?(coder: NSCoder, viewModel: TeamDetailsViewModel?) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teamDetailsTableView.delegate = self
        teamDetailsTableView.dataSource = self
        setupView()
    }
    
    func setupView() {
        let fixtureNib = UINib(nibName: Constant.teamDetailTableViewCell, bundle: nil)
        teamDetailsTableView.register(fixtureNib, forCellReuseIdentifier: Constant.teamDetailTableViewCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = Constant.team
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .clear//UIColor(named: "BaseColor")
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.shadowColor = .clear
            navigationController?.navigationBar.tintColor = UIColor.white
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            tabBarAppearance.backgroundColor = .clear
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            UITabBar.appearance().standardAppearance = tabBarAppearance
        }
    }
    
    override func viewDidLayoutSubviews() {
        filterButton.image = UIImage(named: "filter")
        filterButton.tintColor = UIColor.white
        filterButton.target = self
        filterButton.action = #selector(filterTapped)
        navigationController?.navigationBar.topItem?.rightBarButtonItem = filterButton
    }
    
    @objc func filterTapped() {
        let alertController = UIAlertController(title: Constant.filterTitle, message: nil, preferredStyle: .actionSheet)
        let allPlayersAction = UIAlertAction(title: Constant.all, style: .default) { action in
            self.displayPlayers = .allPlayers
            self.teamDetailsTableView.reloadData()
        }
        let teamHomeAction = UIAlertAction(title: viewModel?.homeTeamName, style: .default) { action in
            self.displayPlayers = .homeTeam
            self.teamDetailsTableView.reloadData()
        }
        let teamAwayAction = UIAlertAction(title: viewModel?.awayTeamName, style: .default) { action in
            self.displayPlayers = .awayTeam
            self.teamDetailsTableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: Constant.cancel, style: .cancel)
        alertController.addAction(allPlayersAction)
        alertController.addAction(teamHomeAction)
        alertController.addAction(teamAwayAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    
    private func getPlayerStylesAlert(player: Player?) {
        var message = Constant.battingStyle + (player?.batting?.style ?? "N/A") + "\n"
        message += Constant.bowlingStyle + (player?.bowling?.style ?? "N/A")
        let alertController = UIAlertController(title: player?.nameFull ?? "", message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: Constant.ok, style: .default)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TeamDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        switch displayPlayers {
        case .homeTeam:
            return 1
        case .awayTeam:
            return 1
        case .allPlayers:
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch displayPlayers {
        case .homeTeam:
            return viewModel?.homeTeam?.count ?? 0
        case .awayTeam:
            return viewModel?.awayTeam?.count ?? 0
        case .allPlayers:
            if section == 0 {
                return viewModel?.homeTeam?.count ?? 0
            } else {
                return viewModel?.awayTeam?.count ?? 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.teamDetailTableViewCell, for: indexPath) as! TeamDetailTableViewCell
        switch displayPlayers {
        case .homeTeam:
            cell.setupcell(player: viewModel?.homeTeam?[indexPath.row])
        case .awayTeam:
            cell.setupcell(player: viewModel?.awayTeam?[indexPath.row])
        case .allPlayers:
            if indexPath.section == 1 {
                cell.setupcell(player: viewModel?.homeTeam?[indexPath.row])
            } else {
                cell.setupcell(player: viewModel?.awayTeam?[indexPath.row])
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44))
        headerView.backgroundColor = .white
        let label = UILabel()
        label.frame = headerView.frame
        label.textColor = .black
        
        switch displayPlayers {
        case .homeTeam:
            label.text = viewModel?.homeTeamName?.uppercased() ?? ""
        case .awayTeam:
            label.text = viewModel?.awayTeamName?.uppercased() ?? ""
        case .allPlayers:
            if section == 1 {
                label.text = viewModel?.homeTeamName?.uppercased() ?? ""
            } else {
                label.text = viewModel?.awayTeamName?.uppercased() ?? ""
            }
        }
        
        headerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch displayPlayers {
        case .homeTeam:
            getPlayerStylesAlert(player: viewModel?.homeTeam?[indexPath.row])
        case .awayTeam:
            getPlayerStylesAlert(player: viewModel?.awayTeam?[indexPath.row])
        case .allPlayers:
            if indexPath.section == 1 {
                getPlayerStylesAlert(player: viewModel?.homeTeam?[indexPath.row])
            } else {
                getPlayerStylesAlert(player: viewModel?.awayTeam?[indexPath.row])
            }
        }
    }
}
