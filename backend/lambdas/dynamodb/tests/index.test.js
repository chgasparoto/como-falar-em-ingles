'user strict';

const lambda = require('../src/index');

describe('lambda middleware', () => {
    it('is a function', () => {
        expect(lambda.handler).toEqual(expect.any(Function));
    });
});
