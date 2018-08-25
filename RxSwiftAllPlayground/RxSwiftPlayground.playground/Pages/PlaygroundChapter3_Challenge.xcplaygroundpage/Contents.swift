import RxSwift

public func example(of description: String, action: () -> Void) {
    print("\n--- Example of:", description, "---")
    action()
}

/// Challenge 1

example(of: "PublishSubject") {
    
    let disposeBag = DisposeBag()
    
    let dealtHand = PublishSubject<[(String, Int)]>()
    
    func deal(_ cardCount: UInt) {
        var deck = cards
        var cardsRemaining: UInt32 = 52
        var hand = [(String, Int)]()
        
        for _ in 0..<cardCount {
            let randomIndex = Int(arc4random_uniform(cardsRemaining))
            hand.append(deck[randomIndex])
            deck.remove(at: randomIndex)
            cardsRemaining -= 1
        }
        
        // Add code to update dealtHand here
        if points(for: hand) > 21 {
            dealtHand.onError(HandError.busted)
        } else {
            dealtHand.onNext(hand)
        }
    }
    
    // Add subscription to dealtHand here
    dealtHand
        .subscribe(
            onNext: {
                print(cardString(for: $0), "for", points(for: $0), "points")
        },
            onError: {
                print(String(describing: $0).capitalized)
        })
        .disposed(by: disposeBag)
    
    deal(3)
    deal(3)
    
}

/// Challenge 2

example(of: "Variable") {
    
    enum UserSession {
        
        case loggedIn, loggedOut
    }
    
    enum LoginError: Error {
        
        case invalidCredentials
    }
    
    let disposeBag = DisposeBag()
    
    // Create userSession Variable of type UserSession with initial value of .loggedOut
    let userSession = Variable(UserSession.loggedOut)
    
    // Subscribe to receive next events from userSession
    userSession.asObservable().subscribe {
        print("userSession changed:", $0)
        }.disposed(by: disposeBag)
    
    func logInWith(username: String, password: String, completion: (Error?) -> Void) {
        guard username == "johnny@appleseed.com",
            password == "appleseed"
            else {
                completion(LoginError.invalidCredentials)
                return
        }
        
        // Update userSession
        userSession.value = .loggedIn
        
    }
    
    func logOut() {
        // Update userSession
        userSession.value = .loggedOut
    }
    
    func performActionRequiringLoggedInUser(_ action: () -> Void) {
        // Ensure that userSession is loggedIn and then execute action()
        guard userSession.value == .loggedIn else {
            print("You can't do that!")
            return
        }
        action()
    }
    
    for i in 1...5 {
        let password = i % 2 == 0 ? "appleseed" : "password"
        
        logInWith(username: "johnny@appleseed.com", password: password) { error in
            guard error == nil else {
                print(error!)
                return
            }
            
            print("User logged in.")
        }
        
        performActionRequiringLoggedInUser {
            print("Successfully did something only a logged in user can do.")
        }
    }
}
