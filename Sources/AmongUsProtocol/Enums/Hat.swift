import Foundation

public enum Hat: UInt32 {
    case none = 0
    case astronaut
    case baseballCap
    case brainSlug
    case bushHat
    case captainHat
    case doubleTopHat
    case flowerpot
    case goggles
    case hardHat
    case militaryHat
    case paperHat
    case partyHat
    case policeHat
    case stethoscope
    case topHat
    case towelWizard
    case ushanka
    case viking
    case wallGuardCap
    case snowman
    case reindeerAntlers
    case christmasLights
    case santaHat
    case christmasTree
    case christmasPresent
    case candyCanes
    case elfHat
    case newYears2018
    case whiteHat
    case crown
    case eyebrows
    case halo
    case heroCap
    case pipCap
    case plunger
    case scubaMask
    case henryStickmin
    case strawHat
    case tenGallonHat
    case thirdEye
    case toiletPaper
    case toppatClanLeader
    case blackFedora
    case skiGoggles
    case hearingProtection
    case hazmatMask
    case faceMask
    case securityHatGlasses
    case safariHat
    case banana
    case beanie
    case bearEars
    case cheese
    case cherry
    case egg
    case greenFedora
    case flamingo
    case flower
    case knightHelmet
    case plant
    case batEyes
    case batWings
    case horns
    case mohawk
    case pumpkin
    case scaryPaperBag
    case witchHat
    case wolfEars
    case pirateHat
    case plagueDoctor
    case machete
    case hockeyMask
    case minerHelmet
    case winterCap
    case archaeologistHat
    case antenna
    case balloon
    case birdNest
    case blackBelt
    case cautionSign
    case chefHat
    case copHat
    case doRag
    case dumSticker
    case fez
    case generalHat
    case pompadourHair
    case hunterHat
    case jungleHat
    case miniCrewmate
    case ninjaMask
    case ramHorns
    case miniCrewmateSnowman
    case geoffKeighleyMask
}

extension Hat: CustomStringConvertible {
    public var description: String {
        switch self {
        case .none:
            return "None"
        case .astronaut:
            return "Astronaut"
        case .baseballCap:
            return "Baseball Cap"
        case .brainSlug:
            return "Brain Slug"
        case .bushHat:
            return "Bush Hat"
        case .captainHat:
            return "Captain Hat"
        case .doubleTopHat:
            return "Double Top Hat"
        case .flowerpot:
            return "Flowerpot"
        case .goggles:
            return "Goggles"
        case .hardHat:
            return "Hard Hat"
        case .militaryHat:
            return "Military Hat"
        case .paperHat:
            return "Paper Hat"
        case .partyHat:
            return "Party Hat"
        case .policeHat:
            return "Police Hat"
        case .stethoscope:
            return "Stethoscope"
        case .topHat:
            return "Top Hat"
        case .towelWizard:
            return "Towel Wizard"
        case .ushanka:
            return "Ushanka"
        case .viking:
            return "Viking"
        case .wallGuardCap:
            return "Wall Guard Cap"
        case .snowman:
            return "Snowman"
        case .reindeerAntlers:
            return "Reindeer Antlers"
        case .christmasLights:
            return "Christmas Lights"
        case .santaHat:
            return "Santa Hat"
        case .christmasTree:
            return "Christmas Tree"
        case .christmasPresent:
            return "Christmas Present"
        case .candyCanes:
            return "Candy Canes"
        case .elfHat:
            return "Elf Hat"
        case .newYears2018:
            return "New Years 2018"
        case .whiteHat:
            return "White Hat"
        case .crown:
            return "Crown"
        case .eyebrows:
            return "Eyebrows"
        case .halo:
            return "Halo"
        case .heroCap:
            return "Hero Cap"
        case .pipCap:
            return "Pip Cap"
        case .plunger:
            return "Plunger"
        case .scubaMask:
            return "Scuba Mask"
        case .henryStickmin:
            return "Henry Stickmin"
        case .strawHat:
            return "Straw Hat"
        case .tenGallonHat:
            return "Ten Gallon Hat"
        case .thirdEye:
            return "Third Eye"
        case .toiletPaper:
            return "Toilet Paper"
        case .toppatClanLeader:
            return "Toppat Clan Leader"
        case .blackFedora:
            return "Black Fedora"
        case .skiGoggles:
            return "Ski Goggles"
        case .hearingProtection:
            return "Hearing Protection"
        case .hazmatMask:
            return "Hazmat Mask"
        case .faceMask:
            return "Face Mask"
        case .securityHatGlasses:
            return "Security Hat Glasses"
        case .safariHat:
            return "Safari Hat"
        case .banana:
            return "Banana"
        case .beanie:
            return "Beanie"
        case .bearEars:
            return "Bear Ears"
        case .cheese:
            return "Cheese"
        case .cherry:
            return "Cherry"
        case .egg:
            return "Egg"
        case .greenFedora:
            return "Green Fedora"
        case .flamingo:
            return "Flamingo"
        case .flower:
            return "Flower"
        case .knightHelmet:
            return "Knight Helmet"
        case .plant:
            return "Plant"
        case .batEyes:
            return "Bat Eyes"
        case .batWings:
            return "Bat Wings"
        case .horns:
            return "Horns"
        case .mohawk:
            return "Mohawk"
        case .pumpkin:
            return "Pumpkin"
        case .scaryPaperBag:
            return "Scary Paper Bag"
        case .witchHat:
            return "Witch Hat"
        case .wolfEars:
            return "Wolf Ears"
        case .pirateHat:
            return "Pirate Hat"
        case .plagueDoctor:
            return "Plague Doctor"
        case .machete:
            return "Machete"
        case .hockeyMask:
            return "Hockey Mask"
        case .minerHelmet:
            return "Miner Helmet"
        case .winterCap:
            return "Winter Cap"
        case .archaeologistHat:
            return "Archaeologist Hat"
        case .antenna:
            return "Antenna"
        case .balloon:
            return "Balloon"
        case .birdNest:
            return "Bird Nest"
        case .blackBelt:
            return "Black Belt"
        case .cautionSign:
            return "Caution Sign"
        case .chefHat:
            return "Chef Hat"
        case .copHat:
            return "Cop Hat"
        case .doRag:
            return "Do Rag"
        case .dumSticker:
            return "Dum Sticker"
        case .fez:
            return "Fez"
        case .generalHat:
            return "General Hat"
        case .pompadourHair:
            return "Pompadour Hair"
        case .hunterHat:
            return "Hunter Hat"
        case .jungleHat:
            return "Jungle Hat"
        case .miniCrewmate:
            return "Mini Crewmate"
        case .ninjaMask:
            return "Ninja Mask"
        case .ramHorns:
            return "Ram Horns"
        case .miniCrewmateSnowman:
            return "Mini Crewmate Snowman"
        case .geoffKeighleyMask:
            return "Geoff Keighley Mask"
        }
    }
}
