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
            playerName += " [C & WK]"
        } else if let wicketKeeper = player?.isKeeper, wicketKeeper {
            playerName += " [WK]"
        } else if let captain = player?.isCaptain, captain {
            playerName += " [C]"
        }
        playerNameLbl.text = playerName
    }
}
