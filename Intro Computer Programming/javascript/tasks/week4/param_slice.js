function param_slice(number) {
  let single_items = String(number)
  let digits = single_items.split("").map(Number)
  console.log(digits)

}

param_slice(2342)