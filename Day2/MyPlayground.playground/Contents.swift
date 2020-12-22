//import UIKit

// assigning variables
var str = "Hello World"
str = "Changing Str"

//numbers
var num = 94
var largeNum = 8_000_000 // large numebrs with commas are written like so
var pi = 3.1415 // double

//multiLine
var multiLine = """
This is a
multiline string
"""

var cleanMulti = """
This goes over\
multiple lines\
with backslash
"""
// string interpolation
var score = "your score was \(num)"

// type inference
let album: String = "12:00"
let year: Int = 2020
let price: Double = 34124.43245321
let stanLoona: Bool = true

// arrays

let joe = "Joe"
let smoe = "Smoe"
let dough = "Dough"
let fosho = "FoSho"

let os = [joe, smoe, dough, fosho]
os[3]

// sets
let colors = Set(["red", "green","blue", "red"])

// tuples
var name = (first: "Tajwar", last: "Rahman")
name.1
name.first

// dictionaries
let heights = [
    "Eifel Tower": 432,
    "Empire State": 576,
    "Leaning Tower": 190
]
heights["Leaning Tower"]
heights["Sears Tower", default: 0]

//Empty collections
var teams = [String: String]() // empty dictionary
teams["John"] = "Team1"

var scoreDict = Dictionary<String, Int>()

var results = [Int]() //empty array
results.append(43)

var scoreArr = Array<Int>()

var setWords = Set<String>()
var setNumbers = Set<Double>()

// enums
enum Activity{
    case running(distance: Double)
    case talking(topic: String)
    case reading(page: Int)
    case resting(asleep: Bool)
}

var res = Activity.resting(asleep: true)

enum Planet: Int{
    case mercury = 1
    case venus
    case earth
}

var earth = Planet(rawValue: 2)
Planet(rawValue: 3)

// ternary operator
let firstCard = 11
let secondCard = 2

print(firstCard == secondCard ? "Cards are the same" : "Cards are different")

// switch case
let weather = "sunny"
switch weather{
case "rainy":
    print("take an umbrella") // no breaks needed
case "snow":
    print("wear warm clothes")
case "sunny":
    print("it is nice out")
    fallthrough // continues the switch case
default:
    print("enjoy your day")
}

// range operators
switch num{
    case 0..<50:
        print("you failed")
    case 50..<80: // 50-80 exclusive
        print("you did ok")
    default:
        print("you did great")
}
for i in 1...10{
    print("i = \(i)")
}

// repeat loop
repeat {
    print(num)
    num += 1
} while num <= 100

// exiting nested loops
outerLoop: for i in 1...10{
    for j in 1...10{
        print("\(i) * \(j) = \(j*i)")
        
        if i*j == 50 {
            break outerLoop
        }
    }
}
