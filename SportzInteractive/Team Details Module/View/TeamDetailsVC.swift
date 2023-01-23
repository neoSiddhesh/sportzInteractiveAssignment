//
//  TeamDetailsVC.swift
//  SportzInteractive
//
//  Created by Neosoft on 23/01/23.
//

import UIKit

enum DisplayPlayers: CaseIterable {
    case homeTeam
    case awayTeam
    case allPlayers
}

class TeamDetailsVC: UIViewController {
    
    @IBOutlet weak var teamDetailsTableView: UITableView!
    
    private var viewModel: TeamDetailsViewModel?
    private var filterButton = UIBarButtonItem()
    
    var displayPlayers: DisplayPlayers = .allPlayers
    
    let picker = UIPickerView()
    
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
        picker.delegate = self
        picker.dataSource = self
        
        setupView()
    }
    
    func setupView() {
        let fixtureNib = UINib(nibName: "TeamDetailTableViewCell", bundle: nil)
        teamDetailsTableView.register(fixtureNib, forCellReuseIdentifier: "TeamDetailTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "Teams"
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
        let alertController = UIAlertController(title: "Select Filter", message: nil, preferredStyle: .actionSheet)
        let allPlayersAction = UIAlertAction(title: "All", style: .default) { action in
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
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(allPlayersAction)
        alertController.addAction(teamHomeAction)
        alertController.addAction(teamAwayAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }

    private func addPickerView() {
        picker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(picker)
        picker.backgroundColor = .white
        picker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        picker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        picker.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        let barAccessory = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let btnDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        barAccessory.barStyle = .default
        barAccessory.isTranslucent = false
       // barAccessory.items = [spaceButton,btnDone]
        
        picker.addSubview(barAccessory)
        barAccessory.leadingAnchor.constraint(equalTo: picker.leadingAnchor).isActive = true
        barAccessory.trailingAnchor.constraint(equalTo: picker.trailingAnchor).isActive = true
        barAccessory.bottomAnchor.constraint(equalTo: picker.topAnchor).isActive = true
        
        picker.isHidden = true
    }
    
    private func getPlayerStylesAlert(player: Player?) {
        var message = "Batting Style: " + (player?.batting?.style ?? "N/A") + "\n"
        message += "Bowling Style: " + (player?.bowling?.style ?? "N/A")
        let alertController = UIAlertController(title: player?.nameFull ?? "", message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true)
    }
}

extension TeamDetailsVC: UITableViewDelegate, UITableViewDataSource {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamDetailTableViewCell", for: indexPath) as! TeamDetailTableViewCell
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


extension TeamDetailsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel?.filterOprions.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel?.filterOprions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            displayPlayers = .allPlayers
        } else if row == 1 {
            displayPlayers = .homeTeam
        } else if row == 2 {
            displayPlayers = .awayTeam
        }
        DispatchQueue.main.async {
            self.teamDetailsTableView.reloadData()
            self.picker.isHidden = true
        }
    }
}
