const path = require('path');

module.exports = {
    resolve: {
        alias: {
            // vue: 'vue/dist/vue.esm',
            '@': path.resolve(__dirname, '..', '..', 'frontend'),
            '@bootstrap': 'bootstrap-vue/es/components',
            '@icons': 'vue-awesome/icons',
        },
    },
};