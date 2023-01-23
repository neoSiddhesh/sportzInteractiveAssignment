//
//  FixtureTableViewCell.swift
//  SportzInteractive
//
//  Created by Neosoft on 23/01/23.
//

import UIKit

class FixtureTableViewCell: UITableViewCell {
    
    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var seriesDetailLbl: UILabel!
    @IBOutlet weak var seriesNameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var matchResultLbl: UILabel!
    @IBOutlet weak var matchNumberLbl: UILabel!
    
    @IBOutlet weak var homeTeamLbl: UILabel!
    @IBOutlet weak var homeTeamScore: UILabel!
    @IBOutlet weak var homeTeamOvers: UILabel!
    
    @IBOutlet weak var awayTeamLbl: UILabel!
    @IBOutlet weak var awayTeamScore: UILabel!
    @IBOutlet weak var awayTeamOvers: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupUI() {
        baseView.layer.cornerRadius = 10
    }
    
    func setupFixtureTableViewCell(matchDetailResponse: MatchDetailResponse?) {
        let teamHome = matchDetailResponse?.matchdetail?.teamHome ?? "0"
        let teamAway = matchDetailResponse?.matchdetail?.teamAway ?? "0"
        var homeInning: Inning?
        var awayInning: Inning?
        
        matchDetailResponse?.innings?.forEach({ inning in
            if inning.battingteam == teamHome {
                homeInning = inning
            } else if inning.battingteam == teamAway {
                awayInning = inning
            }
        })
        
        let dateString = matchDetailResponse?.matchdetail?.match?.date ?? "N.A"
        dateLbl.text = AppUtils.convertDateToString(date: dateString)
        matchResultLbl.text = matchDetailResponse?.matchdetail?.result ?? "N.A"
        seriesDetailLbl.text = "(\( matchDetailResponse?.matchdetail?.series?.status ?? "N.A" ))"
        seriesNameLbl.text = matchDetailResponse?.matchdetail?.series?.name ?? "N.A"
        matchNumberLbl.text = "\(matchDetailResponse?.matchdetail?.match?.number ?? "N.A"), \(matchDetailResponse?.matchdetail?.venue?.name ?? "N.A")"
        
        homeTeamLbl.text = matchDetailResponse?.teams?[teamHome]?.nameShort ?? "Team Two"
        homeTeamOvers.text = "(\(homeInning?.overs ?? "N.A"))"
        homeTeamScore.text = "\(homeInning?.total ?? "N.A")/\(homeInning?.wickets ?? "N.A")"

        awayTeamLbl.text = matchDetailResponse?.teams?[teamAway]?.nameShort ?? "Team One"
        awayTeamOvers.text = "(\(awayInning?.overs ?? "N.A"))"
        awayTeamScore.text = "\(awayInning?.total ?? "N.A")/\(awayInning?.wickets ?? "N.A")"
    }
}
