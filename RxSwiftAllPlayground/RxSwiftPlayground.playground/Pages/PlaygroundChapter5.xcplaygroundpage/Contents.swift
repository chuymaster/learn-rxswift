import Foundation
import RxSwift

public func example(of description: String, action: () -> Void) {
    print("\n--- Example of:", description, "---")
    action()
}


example(of: "ignoreElements") {
    let strikes = PublishSubject<String>()
    let disposeBag = DisposeBag()
    strikes.ignoreElements().subscribe { _ in
        print("you are out!")
    }.disposed(by: disposeBag)
    
    strikes.onNext("X")
    strikes.onNext("X")
    strikes.onNext("X")
    
    strikes.onCompleted()
    
}

example(of: "elementAt") {
    // 1
    let strikes = PublishSubject<String>()
    let disposeBag = DisposeBag()
    // 2
    strikes
        .elementAt(2)
        .subscribe(onNext: { _ in
            print("You're out!")
        })
        .disposed(by: disposeBag)
    
    strikes.onNext("X")
    strikes.onNext("X")
    strikes.onNext("X")
    
}

example(of: "filter") {
    let disposeBag = DisposeBag()
    // 1
    Observable.of(1, 2, 3, 4, 5, 6)
        // 2
        .filter { integer in
            integer % 2 == 0
        }
        // 3
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
    
}

example(of: "skip") {
    let disposeBag = DisposeBag()
    // 1
    Observable.of("A", "B", "C", "D", "E", "F")
        // 2
        .skip(3)
        .subscribe(onNext: {
            print($0) })
        .disposed(by: disposeBag)
}

example(of: "skipWhile") {
    let disposeBag = DisposeBag()
    // 1
    Observable.of(4, 2, 2, 3, 4, 4)
        // 2
        .skipWhile { integer in
            integer % 2 == 0
        }
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
}

example(of: "skipUntil") {
    let disposeBag = DisposeBag()
    // 1
    let subject = PublishSubject<String>()
    let trigger = PublishSubject<String>()
    // 2
    subject
        .skipUntil(trigger)
        .subscribe(onNext: {
            print($0) })
        .disposed(by: disposeBag)
    
    subject.onNext("A")
    subject.onNext("B")
    
    trigger.onNext("X")
    
    subject.onNext("C")
}


example(of: "take") {
    let disposeBag = DisposeBag()
    // 1
    Observable.of(1, 2, 3, 4, 5, 6)
        // 2
        .take(3)
        .subscribe(onNext: {
            print($0) })
        .disposed(by: disposeBag)
}
//
//example(of: "takeWhileWithIndex") {
//    let disposeBag = DisposeBag()
//    // 1
//    Observable.of(2, 2, 4, 4, 6, 6)
//        // 2
//        .takeWhileWithIndex { integer, index in
//            // 3
//            integer % 2 == 0 && index < 3
//        }
//        // 4
//        .subscribe(onNext: {
//            print($0)
//        })
//        .disposed(by: disposeBag)
//}

example(of: "takeUntil") {
    let disposeBag = DisposeBag()
    // 1
    let subject = PublishSubject<String>()
    let trigger = PublishSubject<String>()
    // 2
    subject
        .takeUntil(trigger)
        .subscribe(onNext: {
            print($0) })
        .disposed(by: disposeBag)
    // 3
    subject.onNext("1")
    subject.onNext("2")
    
    trigger.onNext("aa")
    
    subject.onNext("3")

    //someObservable
    //    .takeUntil(self.rx.deallocated)
    //    .subscribe(onNext: {
    //        print($0) })

}

example(of: "distinctUntilChanged") {
    let disposeBag = DisposeBag()
    // 1
    Observable.of("A", "A", "B", "B", "A")
        // 2
        .distinctUntilChanged()
        .subscribe(onNext: {
            print($0) })
        .disposed(by: disposeBag)
}

example(of: "distinctUntilChanged(_:)") {
    let disposeBag = DisposeBag()
    // 1
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    // 2
    Observable<NSNumber>.of(10, 110, 20, 200, 210, 310)
        // 3
        .distinctUntilChanged { a, b in
            // 4
            guard let aWords = formatter.string(from:
                a)?.components(separatedBy: " "),
                let bWords = formatter.string(from: b)?.components(separatedBy: " ") else {
                    return false
            }
            
            var containsMatch = false
// 5
            for aWord in aWords {
                print(aWord)
                for bWord in bWords {
                    if aWord == bWord {
                        containsMatch = true
                        break
                    } }
            }
            return containsMatch
        }
        // 4
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
}




example(of: "Challenge 1") {
    
    let disposeBag = DisposeBag()
    
    let contacts = [
        "603-555-1212": "Florent",
        "212-555-1212": "Junior",
        "408-555-1212": "Marin",
        "617-555-1212": "Scott"
    ]
    
    func phoneNumber(from inputs: [Int]) -> String {
        var phone = inputs.map(String.init).joined()
        
        phone.insert("-", at: phone.index(
            phone.startIndex,
            offsetBy: 3)
        )
        
        phone.insert("-", at: phone.index(
            phone.startIndex,
            offsetBy: 7)
        )
        
        return phone
    }
    
    let input = PublishSubject<Int>()
    
    // Add your code here
    input.skipWhile({
        $0 == 0
    }).filter({
        $0 < 10 // let the user input only 1 digit
    }).take(10).toArray().subscribe(onNext: {
        print ($0)
        
        let phone = phoneNumber(from: $0)
        print(phone)
        if let contact = contacts[phone] {
            print("Dialing \(contact) (\(phone))...")
        } else {
            print("Contact not found")
        }
    })
    
    
    input.onNext(0)
    input.onNext(603)
    
    input.onNext(2)
    input.onNext(1)
    
    // Confirm that 7 results in "Contact not found", and then change to 2 and confirm that Junior is found
    input.onNext(2)
    
    "5551212".forEach {
        if let number = (Int("\($0)")) {
            input.onNext(number)
        }
    }
    
    input.onNext(9)
    
}
