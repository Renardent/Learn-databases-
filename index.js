const {User, Phone, Order, client} = require('./model');
// const {getUsers} = require('./api/fetch');
const {generatePhones} = require('./utils');
// const { mapUsers } = require('./utils');




async function start(){
    await client.connect();
    // const userArray = await getUsers();

    // //  const users = await getUsers();
    const {rows: users} = await User.findAll();
    // const res = await User.bulkCreate(users);
    const {rows: phones} = await Phone.findAll();
    //  const phones = (generatePhones(100));
    //  const res2 =  await Phone.bulkCreate(phones);
    const orders = await Order.bulkCreate(users,phones);



    await client.end();
}


start();
