const _ = require('lodash');


module.exports.mapUsers = (userArray) => {
   return userArray.map(
    ({name: {first, last},
        gender,
        email,
        dob: {date}
        })=> `('${first}', '${last}', '${email}', ${Boolean(Math.random() > 0.5)}, '${date}', '${gender}')`)
    .join(',');
}




const PHONES_BRANDS = [
    'Samsung',
    'iPhone',
    'Siemens',
    'Nokia',
    'Xiaomi',
    'Huawei',
    'Sony',
    'Motorolla',
    'Alcatel'
];


const generateOnePhone = key => ({
    brand: PHONES_BRANDS[_.random(0, PHONES_BRANDS.length-1, false)],
    model: `model ${key}`,
    quantity: _.random(10, 1500, false),
    price: _.random(150, 10000, false),
    category: 'phones'
});


module.exports.generatePhones = (length = 50) => new Array(length).fill(null).map((el,i) => generateOnePhone(i));