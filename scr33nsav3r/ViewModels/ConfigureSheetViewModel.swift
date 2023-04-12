//  scr33nsav3r by Alpha King of a3ther

import SwiftUI
import Combine

protocol SettingsViewModelDelegate: AnyObject {
    func saveSettingsAndClose()
}

class SettingsViewModel: ObservableObject {
    @Published var urlString: String = ""
    @Published var urlList: [String]
    @Published var includeNSFW: Bool = false
    @Published var selectedArtist: String = "Ungenannt"
    weak var delegate: SettingsViewModelDelegate?
    
    var onAnimationSpeedIndexChanged: (() -> Void)?
    
    @Published var animationSpeedIndex: Int {
        didSet {
            onAnimationSpeedIndexChanged?()
        }
    }
    
    
    private let defaults: UserDefaults
    
    init() {
        let bundleIdentifier = "wtf.a3ther.scr33nsav3r"
        self.defaults = UserDefaults.init(suiteName: bundleIdentifier)!
        self.animationSpeedIndex = defaults.integer(forKey: "animationSpeedIndex")
        self.urlList = defaults.stringArray(forKey: "urlList") ?? ["https://16colo.rs/pack/acid-100/x2/LD-RIP.ANS.png"]
        if let selectedArtist = defaults.string(forKey: "selectedArtist") {
            self.selectedArtist = selectedArtist
        }
    }
    
    let artistURLs: [String: [String]] = [
        "Lord Jazz": [
            "https://16colo.rs/pack/uni-0195/x2/LD-TBP1.ANS.png",
            "https://16colo.rs/pack/acdu1194/x2/LD-UI1.ANS.png",
            "https://16colo.rs/pack/acdu0495/x2/LD-PARA1.ANS.png",
            "https://16colo.rs/pack/acdu0695/x2/LD-HOLE1.ANS.png",
            "https://16colo.rs/pack/bleach04/x2/LD-FS2.ANS.png",
            "https://16colo.rs/pack/acdu0895/x2/US-GLUE2.ANS.png",
            "https://16colo.rs/pack/acdu0895/x2/LD-FS1.ANS.png",
            "https://16colo.rs/pack/acid-51a/x2/LD-NS1.ANS.png"
        ],
        "Somms": [
            "https://16colo.rs/pack/acdu0894/x2/SO-LR1.ANS.png",
            "https://16colo.rs/pack/acdu0594/x2/SO-DSUN1.ANS.png",
            "https://16colo.rs/pack/acdu1094/x2/SO-NEO1.ANS.png",
            "https://16colo.rs/pack/itr-9503/x2/SO-PG1.ICE.png",
            "https://16colo.rs/pack/acdu0695/x2/SO-CC1.ANS.png",
            "https://16colo.rs/pack/legend03/x2/SO-HMP1.ANS.png",
            "https://16colo.rs/pack/legend05/x2/SO-RGNC1.ANS.png",
            "https://16colo.rs/pack/apathy13/x2/so-tcf-saga.ans.png"
        ],
        "Tainted": [
            "https://16colo.rs/pack/fire-36/x2/US-TREMR.ANS.png",
            "https://16colo.rs/pack/fire-36/x2/TNT-ODE.ANS.png",
            "https://16colo.rs/pack/fire-36/x2/US-MAXX.ANS.png",
            "https://16colo.rs/pack/fire-35/x2/TNT-Y0DA.ANS.png",
            "https://16colo.rs/pack/fire-35/x2/US-DS22.ANS.png",
            "https://16colo.rs/pack/laz15/x2/tnt-acuw.ans.png",
            "https://16colo.rs/pack/blocktronicsonice/x2/tnt-tr0n.ans.png",
            "https://16colo.rs/pack/blocktronicsonice/x2/us-1c33.ans.png",
            "https://16colo.rs/pack/blocktronicsonice/x2/us-spidygirl.ans.png",
            "https://16colo.rs/pack/blocktronicsonice/x2/tnt-kfr0.ans.png",
            "https://16colo.rs/pack/fire-34/x2/TNT-UTOP.ANS.png",
            "https://16colo.rs/pack/fire-34/x2/US-BVII.ANS.png",
            "https://16colo.rs/pack/laz12/x2/mx_tnt-ink2.ans.png",
            "https://16colo.rs/pack/blocktronics-20th-century-blocks/x2/tnt-bl0b.ans.png",
            "https://16colo.rs/pack/blocktronics-globalblockdown/x2/us-aes_and_tnt__ink_ii.ans.png",
            "https://16colo.rs/pack/1465-001/x2/tnt-so2x.ans.png",
            "https://16colo.rs/pack/blocktronics-globalblockdown/x2/us-aes_and_tnt__ink_ii.ans.png"
        ],
        "Ungenannt": [
            "https://16colo.rs/pack/blocktronics_blockalypse/x2/ungenannt_no%20quarter_bf.ans.png",
            "https://16colo.rs/pack/blocktronics_1010/x2/ungenannt_bellum_part1.xb.png",
            "https://16colo.rs/pack/blocktronics_blocktober/x2/ungenannt_1453.ans.png",
            "https://16colo.rs/pack/blocktronics_blocktober/x2/ungenannt_artemis.ans.png",
            "https://16colo.rs/pack/blocktronics_ansi_love/x1/ungenannt_holy%20crusade.png",
            "https://16colo.rs/pack/blocktronics_darker_image_2/x2/ungenannt_barritus.ans.png",
            "https://16colo.rs/pack/blocktronics-6710/x2/us-voodoo-kudu.ans.png",
            "https://16colo.rs/pack/blocktronics_miracle_on_67th_street/x2/ungenannt-rawn.ans.png",
            "https://16colo.rs/pack/blocktronics_miracle_on_67th_street/x2/ungenannt-petrus.ans.png",
            "https://16colo.rs/pack/blocktronics_miracle_on_67th_street/x2/ungenannt-jeannedarc.ans.png",
            "https://16colo.rs/pack/blocktronics-dsotb/x2/ungenannt-darkness.ans.png",
            "https://16colo.rs/pack/blocktronics_miracle_on_67th_street/x2/ungenannt-imlovinit.ans.png",
            "https://16colo.rs/pack/blocktronics_miracle_on_67th_street/x2/ungenannt-b7.ans.png",
            "https://16colo.rs/pack/blocktronics_miracle_on_67th_street/x2/ungenannt-asmodeus.ans.png",
            "https://16colo.rs/pack/blocktronics-dsotb/x2/ungenannt-zhentilkeep.ans.png",
            "https://16colo.rs/pack/blocktronics_16colors/x2/ungenannt_itsover.ans.png",
            "https://16colo.rs/pack/blocktronics_space_invaders/x2/ungenannt_cockadoodledoodle.ans.png",
            "https://16colo.rs/pack/blocktronics_acid_trip/x2/ungenannt_worldscollide.ANS.png",
            "https://16colo.rs/pack/blocktronics_acid_trip/x2/ungenannt_nachteule.ANS.png",
            "https://16colo.rs/pack/blocktronics_acid_trip/x2/ungenannt_mohctp_darksorrow.ANS.png",
            "https://16colo.rs/pack/blocktronics_1010/x2/ungenannt_bellum_part1.xb.png",
            "https://16colo.rs/pack/blocktronics_blockalypse/x2/ungenannt_no%20quarter_bf.ans.png",
            "https://16colo.rs/pack/blocktronics_blockalypse/x2/ungenannt_motherofsorrows.ans.png"
        ],
        "Filth": [
            "https://16colo.rs/pack/blocktronics_space_invaders/x2/fil-dez.ans.png",
            "https://16colo.rs/pack/blocktronics_space_invaders/x2/fil-abcd.ans.png",
            "https://16colo.rs/pack/blocktronics_acid_trip/x2/fil-BLOQ.ANS.png",
            "https://16colo.rs/pack/blocktronics_acid_trip/x2/fil-FUEL.ANS.png",
            "https://16colo.rs/pack/blocktronics_blockalypse/x2/fil-DOOM.ANS.png",
            "https://16colo.rs/pack/blocktronics_1980/x2/fil-slip.ans.png",
            "https://16colo.rs/pack/apathy13/x2/fil-saga.ans.png",
            "https://16colo.rs/pack/blocktronics_there_will_be_blocks/x2/fil-meep.ans.png",
            "https://16colo.rs/pack/blocktronics_darker_image_2/x2/fil-darker%20north.ans.png",
            "https://16colo.rs/pack/fuel23/x2/fil-Gluckwunsche.ans.png",
            "https://16colo.rs/pack/blocktronics-420/x2/fil-maude.ans.png",
            "https://16colo.rs/pack/fuel25/x2/us-nsfw.ans.png",
            "https://16colo.rs/pack/blocktronics-6710/x2/FIL-BUZZ.ans.png",
            "https://16colo.rs/pack/blocktronics-6710/x2/US-LEGION.ANS.png",
            "https://16colo.rs/pack/fuel30/x2/fIL-SSSSSSSSSSSS.ans.png",
            "https://16colo.rs/pack/blocktronics-blocky-horror/x2/fil-bloxxi.ans.png",
            "https://16colo.rs/pack/blocktr0nics30302020/x2/fil-TRiBE.ans.png",
            "https://16colo.rs/pack/fire-34/x2/FIL-GAUL.ANS.png",
            "https://16colo.rs/pack/blocktronicsonice/x2/fil-1351N_VanNess.ans.png",
            "https://16colo.rs/pack/fire-35/x2/FIL-UNI.ANS.png"
        ]
    ]
    
    var randomSelectedArtistURL: String? {
        guard let urls = artistURLs[selectedArtist] else { return nil }
        return urls.randomElement()
    }
    
    var animationSpeed: Double {
        switch animationSpeedIndex {
        case 1:
            return 0.2
        case 2:
            return 0.1
        case 3:
            return 0.05
        default:
            return 0.5
        }
    }
    
    func saveSettings() {
        defaults.set(animationSpeedIndex, forKey: "animationSpeedIndex")
        defaults.synchronize()
    }
    
    func saveSettingsAndClose() {
        defaults.set(animationSpeedIndex, forKey: "animationSpeedIndex")
        defaults.synchronize()
        delegate?.saveSettingsAndClose()
    }
}
