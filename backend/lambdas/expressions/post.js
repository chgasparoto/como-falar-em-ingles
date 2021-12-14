const AWS = require('aws-sdk');
const dynamo = new AWS.DynamoDB.DocumentClient();

exports.handler = async event => {
    if (process.env.DEBUG) {
        console.log({
            message: 'Received event',
            data: JSON.stringify(event),
        });
    }

    try {
        const tableName = process.env.DYNAMO_DB_TABLE_NAME;
        const data = JSON.parse(event['body']);

        const params = {
            TableName: tableName,
            Item: {
                pk: 'c#2',
                sk: 'c#2',
                entity_type: 'category',
                expression: data,
                created_at: new Date().toISOString(),
            },
        };

        await dynamo.put(params).promise();

        console.log({
            message: 'Record has been created',
            data: JSON.stringify(params),
        });

        return {
            statusCode: 201,
            body: 'Record has been created',
            headers: {
                'Content-Type': 'application/json',
            },
        }

    } catch (err) {
        console.error(err);
        return {
            statusCode: 500,
            body: JSON.stringify('Something went wrong'),
            headers: {
                'Content-Type': 'application/json',
            },
        };
    }
};
