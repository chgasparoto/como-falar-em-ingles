'use strict';

exports.handler = async event => {
    try {
        console.log({
            message: 'Records found',
            data: JSON.stringify(event),
        });

        return {
            statusCode: 200,
            body: JSON.stringify('Hello World'),
            headers: {
                'Content-Type': 'application/json',
            },
        };
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
