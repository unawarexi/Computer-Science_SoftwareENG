/**
 * use to decide how, when to start a function and end it
 * 
 * ============= TYPES
 * setTimeout == allows to invoke function once after set period of time
 *     * takes two arguments ( function, time in miliseconds )
 *  
 *  cleartimeout == removes the time set to display function
 * 
 * setInterval == reapeats the function over specified amount of times
 * clearinterval
 * 
 * NOTE : 1000ms == 1secs
 */

function myfunction(channel){
    console.log(`subscribe to my channel ${channel}`)
}

const timer = setTimeout(myfunction, 3000, "devDreamer");

const clear = () => {
    clearTimeout(timer) 
    console.log(`timeout cleared`)
}

// const btn = document.querySelector('.btn').addEventListener('click', clear);
                      // remove from comment , i used btn below again thats why.
//always use single quotes for document.('html-element')


function looping(youtube){
    console.log(`click the notify bell in my channel ${youtube}`)

}

const amount = setInterval(looping, 1000, 'jennyIT');

const secondfn = () => {
    clearInterval(amount)
    console.log(`interval has been cleared`)
}

const btn = document.querySelector('.btn').addEventListener('click', secondfn)


 function count (start, end){
   let times = setInterval(() => {
    console.log(start)

    if (start >= end){
        clearInterval(times)
    }
    else {
        start++
    }
                     
  }, 1000);
 }

 count(0, 10)



