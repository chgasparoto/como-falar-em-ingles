const DynamoDB = require('aws-sdk/clients/dynamodb');
const middy = require('@middy/core');
const errorLogger = require('@middy/error-logger');
const { v4: uuidv4 } = require('uuid');

const debugMiddleware = require('/opt/nodejs/debugger');
const errorHandlerMiddleware = require('/opt/nodejs/error-handler');
const response = require('/opt/nodejs/response');

const dynamo = new DynamoDB.DocumentClient();

const baseHandler = async (event) => {
    const tableName = process.env.DYNAMO_DB_TABLE_NAME;
    const data = JSON.parse(event['body']);
    const id = uuidv4();

    const params = {
        TableName: tableName,
        Item: {
            pk: `c#${id}`,
            sk: `c#${id}`,
            entity_type: 'category',
            expression: data,
            created_at: new Date().toISOString(),
        },
    };

    await dynamo.put(params).promise();

    console.log({
        message: `Record ${id} has been created`,
        data: JSON.stringify(params),
    });

    return response(201, `Record ${id} has been created`);
};

const handler = middy(baseHandler)
    .use(debugMiddleware({ debug: true }))
    .use(errorLogger())
    .use(errorHandlerMiddleware());

module.exports = { handler };
