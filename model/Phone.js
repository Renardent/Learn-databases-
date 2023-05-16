class Phone {
    static _client;
    static _tableName;

    static async findAll(){
        return await this._client.query(`SELECT * FROM ${this._tableName}`);
    }


    static async bulkCreate(phones) {
        const valueString = phones.map(
            ({brand, model, price,quantity, category}) => 
            `('${brand}', '${model}', ${price}, ${quantity}, '${category}')` 
        ).join(',');


        const {rows} = await this._client.query(
            `INSERT INTO ${this._tableName} 
            (brand, model, price,quantity,category) VALUES
            ${valueString} ;`
        );

        return rows;
    }
}

module.exports = Phone;