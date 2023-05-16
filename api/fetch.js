
module.exports.getUsers = async() => {
    const res = await fetch('https://randomuser.me/api/?results=500&seed=fm2022&page=2');
    const data = await res.json();
    return data.results;
}