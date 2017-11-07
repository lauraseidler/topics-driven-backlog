const { environment } = require('@rails/webpacker')


environment.resolve = {
    alias: {
        vue: 'vue/dist/vue.esm'
    }
}

module.exports = environment
