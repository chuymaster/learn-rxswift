import Foundation
import RxSwift

public func example(of description: String, action: () -> Void) {
    print("\n--- Example of:", description, "---")
    action()
}

example(of: "startWith") {
    // 1
    let numbers = Observable.of(2, 3, 4)
    // 2
    let observable = numbers.startWith(1)
    observable.subscribe(onNext: { value in
        print(value)
    })
}
example(of: "Observable.concat") {
    // 1
    let first = Observable.of(1, 2, 3)
    let second = Observable.of(4, 5, 6)
    // 2
    let observable = Observable.concat([first, second])
    observable.subscribe(onNext: { value in
        print(value)
    })
    
    second.subscribe(onNext: {
        print($0)
    })
}

example(of: "concat") {
    let germanCities = Observable.of("Berlin", "Münich", "Frankfurt")
    let spanishCities = Observable.of("Madrid", "Barcelona", "Valencia")
    let observable = germanCities.concat(spanishCities)
    observable.subscribe(onNext: { value in
        print(value)
    })
}

example(of: "concat one element") {
    let numbers = Observable.of(2, 3, 4)
    let observable = Observable
        .just(1)
        .concat(numbers)
    observable.subscribe(onNext: { value in
        print(value)
    })
}

example(of: "merge") {
    // 1
    let left = PublishSubject<String>()
    let right = PublishSubject<String>()
    // 2
    let source = Observable.of(left.asObservable(), right.asObservable())
    // 3
    let observable = source.merge()
    let disposable = observable.subscribe(onNext: { value in
        print(value)
    })
    // 4
    var leftValues = ["Berlin", "Munich", "Frankfurt"]
    var rightValues = ["Madrid", "Barcelona", "Valencia"]
    repeat {
        if arc4random_uniform(2) == 0 {
            if !leftValues.isEmpty {
                left.onNext("Left:  " + leftValues.removeFirst())
            }
        } else if !rightValues.isEmpty {
            right.onNext("Right: " + rightValues.removeFirst())
        }
    } while !leftValues.isEmpty || !rightValues.isEmpty
    
    disposable.dispose()
}

example(of: "combineLatest") {
    let left = PublishSubject<String>()
    let right = PublishSubject<String>()
    // 1
    let observable = Observable.combineLatest(left, right, resultSelector:
    {
        lastLeft, lastRight in
        "\(lastLeft) \(lastRight)"
    })
    let disposable = observable.subscribe(onNext: { value in
        print(value)
    })
    
    // 2
    print("> Sending a value to Left")
    left.onNext("Hello,")
    print("> Sending a value to Right")
    right.onNext("world")
    print("> Sending another value to Right")
    right.onNext("RxSwift")
    print("> Sending another value to Left")
    left.onNext("Have a good day,")
    
    disposable.dispose()
}

example(of: "combine user choice and value") {
    let choice : Observable<DateFormatter.Style> = Observable.of(.short, .long)
    let dates = Observable.of(Date())
    let observable = Observable.combineLatest(choice, dates) {
        (format, when) -> String in
        let formatter = DateFormatter()
        formatter.dateStyle = format
        return formatter.string(from: when)
    }
    observable.subscribe(onNext: { value in
        print(value)
    })
}

example(of: "zip") {
    enum Weather {
        case cloudy
        case sunny
    }
    let left: Observable<Weather> = Observable.of(.sunny, .cloudy, .cloudy,
                                                  .sunny) // If one of them completes, zip completes as well.
    let right = Observable.of("Lisbon", "Copenhagen", "London", "Madrid",
                              "Vienna")
    let observable = Observable.zip(left, right) { weather, city in
        return "It's \(weather) in \(city)"
    }
    observable.subscribe(onNext: { value in
        print(value)
    })
}

example(of: "withLatestFrom") {
    // 1
    let button = PublishSubject<Void>()
    let textField = PublishSubject<String>()
    // 2
    let observable = button.withLatestFrom(textField)
    let disposable = observable.subscribe(onNext: { value in
        print(value)
    })
    // 3
    textField.onNext("Par")
    textField.onNext("Pari")
    textField.onNext("Paris")
    button.onNext(())
    button.onNext(())
}

example(of: "sample") {
    // 1
    let button = PublishSubject<Void>()
    let textField = PublishSubject<String>()
    // 2
    let observable = textField.sample(button)
    let disposable = observable.subscribe(onNext: { value in
        print(value)
    })
    // 3
    textField.onNext("Par")
    textField.onNext("Pari")
    textField.onNext("Paris")
    button.onNext(())
    button.onNext(())
    // Get next event only after textField has event
    textField.onNext("Par")
    button.onNext(())
}

example(of: "amb (ambigous)") {
    let left = PublishSubject<String>()
    let right = PublishSubject<String>()
    // 1
    let observable = left.amb(right)
    let disposable = observable.subscribe(onNext: { value in
        print(value)
    })
    // 2
    left.onNext("Lisbon")
    right.onNext("Copenhagen")
    left.onNext("London")
    left.onNext("Madrid")
    right.onNext("Vienna")
    disposable.dispose()
}

example(of: "switchLatest") {
    // 1
    let one = PublishSubject<String>()
    let two = PublishSubject<String>()
    let three = PublishSubject<String>()
    let source = PublishSubject<Observable<String>>()
    // 2
    let observable = source.switchLatest()
    let disposable = observable.subscribe(onNext: { value in
        print(value)
    })
    // 3
    source.onNext(one)
    one.onNext("Some text from sequence one")
    two.onNext("Some text from sequence two")
    source.onNext(two)
    two.onNext("More text from sequence two")
    one.onNext("and also from sequence one")
    source.onNext(three)
    two.onNext("Why don't you see me?")
    one.onNext("I'm alone, help me")
    three.onNext("Hey it's three. I win.")
    source.onNext(one)
    one.onNext("Nope. It's me, one!")
    disposable.dispose()
}

example(of: "reduce") {
    let source = Observable.of(1, 3, 5, 7, 9)
    // 1
    let observable = source.reduce(0, accumulator: { summary, newValue in
        return summary + newValue
    })
    observable.subscribe(onNext: { value in
        print(value)
    })
}


example(of: "scan") {
    let source = Observable.of(1, 3, 5, 7, 9)
    let observable = source.scan(0, accumulator: +)
    observable.subscribe(onNext: { value in
        print(value)
    })
}


example(of: "Challenge of zip code") {
    let source = Observable.of(1, 3, 5, 7, 9)
    let observable = source.scan(0, accumulator: +)
    source.subscribe(onNext: { value in
        print(value)
    })
    observable.subscribe(onNext: { value in
        print(value)
    })
    let zip = Observable.zip(observable, source) { scan, value in
        return "The value is \(value), accomulated is \(scan)"
    }
    
    zip.subscribe(onNext: { value in
        print(value)
    })
    
 
//    let zip = Observable.zip

}


