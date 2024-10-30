
const given_cities = {
    city1: 101,
    city2: 500,
    city3: 20000,
    city4: 52323,
    city5: 890
  };
  
  const given_region = 10000;
  
  const citiesOverThreshold = (cities, threshold) => {
    let result = [];
    for (let city in cities) {
      if (cities[city] > threshold) {
        result.push(city);
      }
    }
    return result;
  };
  
  const resultCities = citiesOverThreshold(given_cities, given_region);
  
  console.log("Cities with population greater than 10,000:", resultCities);
  