import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

import RxSwift

example(of: "PublishSubject") {
    let subject = PublishSubject<String>()
    
    let subscriptionOne = subject.subscribe(onNext: {
        print("1)", $0)
    })
    subject.onNext("Is anyone listening?")
    subject.on(.next("1"))
    
    let subscriptionTwo = subject
        .subscribe { event in
            print("2)", event.element ?? event)
    }
    
    subject.onNext("3")
    
    subscriptionOne.dispose()
    
    subject.onNext("4")
    
    // 1
    subject.onCompleted()
    // 2
    subject.onNext("5")
    // 3
    subscriptionTwo.dispose()
    let disposeBag = DisposeBag()
    // 4
    subject
        .subscribe {
            print("3)", $0.element ?? $0)
        }
        .disposed(by: disposeBag)
    subject.onNext("?")
    
    // every subject type, once terminated, will re-emit its stop event to future subscribers.
    
}


// 1
enum MyError: Error {
    case anError
}
// 2
func print<T: CustomStringConvertible>(label: String, event: Event<T>) {
    print(label, event.element ?? event.error ?? event ?? "nil")
}
// 3
example(of: "BehaviorSubject") {
    // 4
    let subject = BehaviorSubject(value: "Initial value")
    let disposeBag = DisposeBag()
    
    subject.onNext("X")
    
    subject.subscribe {
        print(label: "1", event: $0)
        }.disposed(by: disposeBag)
    
    subject.onError(MyError.anError)
    
    subject.subscribe {
        print(label: "2", event: $0)
        }.disposed(by: disposeBag)
    
}

example(of: "ReplaySubject") {
    // 1
    let subject = ReplaySubject<String>.create(bufferSize: 2)
    let disposeBag = DisposeBag()
    // 2
    subject.onNext("1")
    subject.onNext("2")
    subject.onNext("3")
    // 3
    subject
        .subscribe {
            print(label: "1)", event: $0)
        }
        .disposed(by: disposeBag)
    subject
        .subscribe {
            print(label: "2)", event: $0)
        }
        .disposed(by: disposeBag)
    
    subject.onNext("4")
    subject.onError(MyError.anError)
    //    subject.dispose()
    
    subject
        .subscribe {
            print(label: "3)", event: $0)
        }
        .disposed(by: disposeBag)
}

example(of: "Variable") {
    // 1
    var variable: Variable<String> = Variable("Initial value")
    let disposeBag = DisposeBag()
    // 2
    variable.value = "New initial value"
    // 3
    variable.asObservable()
        .subscribe {
            print(label: "1)", event: $0)
        }.disposed(by: disposeBag)
    
    // 1
    variable.value = "1"
    //    // 2
    //    variable.asObservable()
    //        .subscribe {
    //            print(label: "2)", event: $0)
    //        }
    //        .disposed(by: disposeBag)
    //    // 3
    variable.value = "2"
    
}
