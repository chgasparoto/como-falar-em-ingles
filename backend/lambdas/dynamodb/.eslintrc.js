module.exports = {
    extends: ['eslint:recommended', 'plugin:jest/recommended'],
    env: {
        es6: true,
        node: true,
        jest: true,
        'jest/globals': true,
    },
    parserOptions: {
        ecmaVersion: 2019,
        sourceType: 'module',
    },
    plugins: ['jest'],
    rules: {
        semi: ['error', 'always'],
        quotes: ['error', 'single'],
        indent: ['error', 4],
    },
};
