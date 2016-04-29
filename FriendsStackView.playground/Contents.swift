/*:
# FriendsStackView
Display friends avatar in a grid with UIStackView

@mbessagnet - Copyright 2016 ekito
*/

import UIKit
import XCPlayground

//: ### Constants
let avatarImageHeight: CGFloat = 60
//: ### Enum Gender
enum Gender {
    case Male
    case Female
    case Other
}
//: ### Struct Friend
struct Friend {
    var firstName: String = "John"
    var lastName: String = "Doe"
    var gender: Gender = .Male
    
    init(aFirstName: String, aLastName: String, aGender: Gender = .Male) {
        firstName = aFirstName
        lastName = aLastName
        gender = aGender
    }
}
//: ### Utils methods
extension CollectionType {
    // Split a collection into subcollections with a given size
    func chunk(withDistance distance: Index.Distance) -> [[SubSequence.Generator.Element]] {
        var index = startIndex
        let generator: AnyGenerator<Array<SubSequence.Generator.Element>> = AnyGenerator {
            defer { index = index.advancedBy(distance, limit: self.endIndex) }
            return index != self.endIndex ? Array(self[index ..< index.advancedBy(distance, limit: self.endIndex)]) : nil
        }
        return Array(generator)
    }
}

func makeAvatarIcon(gender: Gender) -> UIImageView {
    let avatarImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: avatarImageHeight, height: avatarImageHeight))
    avatarImageView.backgroundColor = UIColor(white: 0.6, alpha: 1.0)
    avatarImageView.layer.cornerRadius = ceil(avatarImageHeight/2)
    avatarImageView.layer.borderColor = UIColor.grayColor().CGColor
    avatarImageView.layer.borderWidth = 2
    avatarImageView.clipsToBounds = true
    avatarImageView.contentMode = .ScaleAspectFit
    
    switch gender {
    case .Male:
        avatarImageView.image = UIImage(named: "avatar_male")
    case .Female:
        avatarImageView.image = UIImage(named: "avatar_female")
    case .Other:
        avatarImageView.image = nil
    }
    
    avatarImageView.widthAnchor.constraintEqualToConstant(avatarImageHeight).active = true
    avatarImageView.heightAnchor.constraintEqualToConstant(avatarImageHeight).active = true
    
    return avatarImageView
}

func makeNameLabel(friend: Friend) -> UILabel {
    let nameLabel = UILabel(frame: .zero)
    nameLabel.text = "\(friend.firstName.characters.first!). \(friend.lastName)"
    nameLabel.font = UIFont(name: "HelveticaNeue", size: 14)
    nameLabel.textColor = UIColor.blackColor()
    nameLabel.textAlignment = NSTextAlignment.Center
    nameLabel.lineBreakMode = NSLineBreakMode.ByTruncatingMiddle
    
    return nameLabel
}

func friendView(friend: Friend) -> UIStackView {
    let avatarImageView: UIImageView = makeAvatarIcon(friend.gender)
    let nameLabel: UILabel = makeNameLabel(friend)
    
    let personInfoStackView = UIStackView(arrangedSubviews: [avatarImageView, nameLabel])
    personInfoStackView.axis = .Vertical
    personInfoStackView.alignment = .Center
    personInfoStackView.spacing = 10
    
    return personInfoStackView
}
//: ## Build stack view
if #available(iOS 9, *) {
    var friends: [Friend] = []
    friends.append(Friend(aFirstName: "Beyoncé", aLastName: "Knowles", aGender: .Female))
    friends.append(Friend(aFirstName: "Kobe", aLastName: "Bryant", aGender: .Male))
    friends.append(Friend(aFirstName: "Buzz", aLastName: "Lightyear", aGender: .Other))
    friends.append(Friend(aFirstName: "Walt", aLastName: "Disney", aGender: .Male))
    friends.append(Friend(aFirstName: "Bruce", aLastName: "Wayne", aGender: .Male))
    friends.append(Friend(aFirstName: "Natasha", aLastName: "Romanov", aGender: .Female))
    friends.append(Friend(aFirstName: "Marie", aLastName: "Curie", aGender: .Female))
    
/*: - experiment: Try changing stackViewWidth to 800.0 or avatarWidth to 100.0 */
    // Group of X friends per line
    let stackViewWidth: CGFloat = 400.0
    let lineXSpacing: CGFloat = 20.0
    let avatarWidth: CGFloat = 80.0
    
    let numberOfFriendsPerLine = Int(round(stackViewWidth / (avatarWidth + lineXSpacing)))
    let newFriends = friends.chunk(withDistance: numberOfFriendsPerLine)
    
    let heightLine: CGFloat = 120.0
    let lineYSpacing: CGFloat = 10.0
    let stackViewHeight: CGFloat = heightLine * CGFloat(newFriends.count) + lineYSpacing * CGFloat(newFriends.count - 1)
    var stackViewContainer: UIStackView = UIStackView(frame: CGRect(x: 0.0, y: 0.0, width: stackViewWidth, height: stackViewHeight))
    stackViewContainer.axis = .Vertical
    stackViewContainer.spacing = lineYSpacing
    stackViewContainer.distribution = .FillEqually
/*: - experiment: Try changing aligment to Leading or Fill */
    stackViewContainer.alignment = .Center
    
    for friendsLine:[Friend] in newFriends {
        var stackViewLine1: UIStackView = UIStackView()
        stackViewLine1.axis = .Horizontal
        stackViewLine1.spacing = lineXSpacing
        stackViewLine1.distribution = .FillEqually
        stackViewLine1.alignment = .Center
        
        for friend in friendsLine {
            let friendStackView: UIStackView = friendView(friend)
            stackViewLine1.addArrangedSubview(friendStackView)
        }
        
        stackViewContainer.addArrangedSubview(stackViewLine1)
    }
    
    let containerView: UIView = UIView(frame: stackViewContainer.frame)
    containerView.backgroundColor = UIColor.whiteColor()
    containerView.addSubview(stackViewContainer)
    
    // Display container view in Assistant View
    XCPlaygroundPage.currentPage.liveView = containerView
    

}
