const {User, Phone, Order, client} = require('./model');
const {getUsers} = require('./api/fetch');
const {generatePhones} = require('./utils');





async function start(){
    await client.connect();

    //  const users = await getUsers();
    // const res = await User.bulkCreate(users);
     const {rows: users} = await User.findAll();
     const phones = await Phone.bulkCreate(generatePhones());
    //  const {rows: phones} = await Phone.findAll();
    const orders = await Order.bulkCreate(users, phones);


    await client.end();
}


start();
