//import UIKit

// functions
func square(num: Int) -> Int{
    return num * num
}
print(square(num: 4))

// parameter labels
func sayHello(to name: String){
    print("Hello \(name)")
}
sayHello(to: "Tajwar")

func sayHello2(_ name: String){
    print("Hello \(name)")
}
sayHello2("Tajwar")

//default params
func greet(_ name: String, again: Bool = false){
    let message = again ? "Oh it's \(name) again" : "Hello \(name)"
    print(message)
}
greet("Tajwar")
greet("Tajwar", again: true)

// variadic funcs
func variadicSquare(nums: Int...){
    for num in nums{
        print("\(num)^2 = \(num*num)")
    }
}
variadicSquare(nums: 1,2,3,4,5)

// throwing funcs
enum PasswordError: Error{
    case obvious
}

func checkPassword(_ password: String) throws -> Bool{
    if password == "password"{
        throw PasswordError.obvious
    }
    return true
}

do {
    try checkPassword("password")
    print("Good password")
} catch{
  print("You can't use that password")
}

// inout parameters -> mutates number in place
func double(num: inout Int){
    num *= 2
}
var number = 332
double(num: &number)

// closures
let driving = { (place: String) -> String in
    return "I'm driving to \(place)"
}

print(driving("NYC"))

func travel(action: (String) -> Void){ //closures as parameters
    print("I'm getting ready for vacay")
    action("NYC")
    print("I have arrived")
}

travel { (place: String) in
    print("I'm driving to \(place)") //trailing closure syntax
}

func travel2(action: (String) -> String){ // closures as parameters when they have returns
    print("I'm getting ready for vacay")
    let dest = action("NYC")
    print(dest)
    print("I have arrived")
}
travel2{ (place: String) -> String in
    return "I am going to \(place)"
}
travel2{
    "I am going to \($0)"
}

func travel3(action: (String, Int) -> String){
    print("I'm getting ready for vacay")
   let dest = action("NYC", 932)
   print(dest)
   print("I have arrived")
}

travel3{
    return "I am driving to \($0) at \($1) miles per hour"
}

func travel4() -> (String) -> Void{
    var counter = 1 // capturing values
    return{
        print("I am going to \($0)")
        counter += 1
    }
}

let result = travel4()
result("NYC")
result("NYC")
result("NYC")
result("NYC")

// structs
struct Sport{
    var name: String
    var isOnlympicSport: Bool
    var olympicStatus: String{
        if isOnlympicSport{
            return "\(name) is an Olympic sport"
        }
        else{
            return "\(name) is not an Olympic sport"
        }
    }
}
var tennis = Sport(name: "tennis", isOnlympicSport: true)
print(tennis.olympicStatus)

struct Progress{
    var task: String
    var percent: Int{
        didSet{
            print("\(task) is now \(percent)% complete")
        }
    }
}
var progress = Progress(task: "Downloading", percent: 0)
progress.percent = 10
progress.percent = 50
progress.percent = 100

struct City{
    var population: Int
    func tax() -> Int{
        return population * 1000
    }
}
var nyc = City(population: 19_000_000)
nyc.tax()

struct Person{
    var name: String
    
    mutating func changeName(newName: String){
        name = newName
    }
}

var bob = Person(name: "Bob")
bob.changeName(newName: "Bobb")
bob.name

//initalizers
struct User{
    var username: String
    init(){
        username = "Unknown"
        print("creating user")
    }
}
var john = User()
print(john.username)
john.username = "John"
print(john.username)

// string methods
var word = "This is a sentence"
print(word.count)
print(word.customMirror)
print(word.sorted())

// array methods
var arr = [1,6523,125,32,4,6,3,74,2,6]
print(arr.count)
print(arr.capacity)
print(arr.endIndex)
print(arr.sorted())

// statix properties & methods
struct Class{
    static var classSize = 0
    var name: String
    
    init(name: String){
        self.name = name
        Class.classSize += 1
    }
}

var b = Class(name: "Bob")
var s = Class(name: "Steph")
print(Class.classSize)


//classes
class Dog{
    var name: String
    var breed: String
    
    init(name: String, breed: String){
        self.name = name
        self.breed = breed
    }
    func makeNoise() {
        print("Woof!")
    }
}
var doggo = Dog(name: "Doggo", breed: "Husky")

class Husky: Dog{
    init(name: String){
        super.init(name: name, breed: "Husky")
    }
    override func makeNoise() {
        print("Bark!")
    }
}
var h = Husky(name: "Hugh")
h.makeNoise()


//deinitializer
class People {
    var name = "John Doe"
    init() {
        print("\(name) is alive!")
    }
    func printGreeting() {
        print("Hello, I'm \(name)")
    }
    deinit {
        print("\(name) is no more!")
    }
}
for _ in 1...3 {
    let person = People()
    person.printGreeting()
}

//protocol
protocol Identifiable{
    var id: String { get set }
    func displayID()
}
extension Identifiable{
    func displayID(){
        print("My id is \(id)")
    }
}
struct Users: Identifiable{
    var id: String
}
let being = Users(id: "being")
being.displayID()

//protocol inheritance
protocol Payable {
    func calculateWages() -> Int
}
protocol NeedsTraining {
    func study()
}
protocol HasVacation {
    func takeVacation(days: Int)
}
protocol Employee: Payable, NeedsTraining, HasVacation { }

//extensions
extension Int{
    func squared() -> Int{
        return self * self
    }
    var isEven: Bool {
        return self % 2 == 0
    }
}

var test = 2
print(test.squared())
print(test.isEven)

// protocol extension
let pythons = ["Eric", "Graham", "John", "Michael", "Terry", "Terry"]
let beatles = Set(["John", "Paul", "George", "Ringo"])
extension Collection {
    func summarize() {
        print("There are \(self.count) of us:")
        for name in self {
            print(name)
        }
    }
}
pythons.summarize()
beatles.summarize()
