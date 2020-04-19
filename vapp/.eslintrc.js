module.exports = {
    "env": {
        "browser": true,
        "es6": true
    },
    "extends": [
        "eslint:recommended",
        "plugin:vue/essential"
    ],
    "globals": {
        "Atomics": "readonly",
        "SharedArrayBuffer": "readonly"
    },
    "parserOptions": {
        "ecmaVersion": 2018,
        "sourceType": "module"
    },
    "plugins": [
        "vue"
    ],
    "rules": {
		'no-console':'off',
		'no-irregular-whitespace':'off',
		'no-unused-vars':'off',
		'no-mixed-spaces-and-tabs':'off',
		'vue/no-unused-components':'off',
		'vue/require-v-for-key':'off'
    }
};