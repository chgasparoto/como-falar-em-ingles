const DynamoDB = require('aws-sdk/clients/dynamodb');
const middy = require('@middy/core');
const inputOutputLogger = require('@middy/input-output-logger');
const errorLogger = require('@middy/error-logger');
const { v4: uuidv4 } = require('uuid');

const dynamo = new DynamoDB.DocumentClient();

const baseHandler = async (event) => {
    if (process.env.DEBUG) {
        console.log({
            message: 'Received event',
            data: JSON.stringify(event),
        });
    }

    try {
        const tableName = process.env.DYNAMO_DB_TABLE_NAME;
        const data = JSON.parse(event['body']);
        const id = uuidv4();

        const params = {
            TableName: tableName,
            Item: {
                pk: `e#${id}`,
                sk: `e#${id}`,
                entity_type: 'expression',
                expression: data,
                created_at: new Date().toISOString(),
            },
        };

        await dynamo.put(params).promise();

        console.log({
            message: `Record ${id} has been created`,
            data: JSON.stringify(params),
        });

        return {
            statusCode: 201,
            body: JSON.stringify(`Record ${id} has been created`),
            headers: {
                'Content-Type': 'application/json',
            },
        };
    } catch (err) {
        return {
            statusCode: 500,
            body: JSON.stringify('Something went wrong'),
            headers: {
                'Content-Type': 'application/json',
            },
        };
    }
};

const handler = middy(baseHandler).use(inputOutputLogger()).use(errorLogger());

module.exports = { handler };
