//
//  TeamDetailTableViewCell.swift
//  SportzInteractive
//
//  Created by Neosoft on 23/01/23.
//

import UIKit

class TeamDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var playerNameLbl: UILabel!
    
    func setupcell(player: Player?) {
        var playerName = player?.nameFull ?? ""
        
        if let wicketKeeper = player?.isKeeper, wicketKeeper, let captain = player?.isCaptain, captain {
            playerName += Constant.captainWK
        } else if let wicketKeeper = player?.isKeeper, wicketKeeper {
            playerName += Constant.wk
        } else if let captain = player?.isCaptain, captain {
            playerName += Constant.captain
        }
        playerNameLbl.text = playerName
    }
}
