//refer to for in loop usefulinfo

//  while going through you'll see alot of hints


const names = { // this is an object
    firstson : "emmanuel",
    secondson : "jeff",
    lastson: "prince"
}

console.log(names) // this prints out the whole object

//to get only the values

let {
    firstson, secondson, lastson
} = names // destructuring

console.log(
    firstson,
    secondson,
    lastson,
)
