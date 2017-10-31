/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import Vue from 'vue';
import VueResource from 'vue-resource';
import Vuelidate from 'vuelidate';

import App from '../components/App.vue';
import router from '../router/index';
import store from '../store/index';

Vue.use(VueResource);
Vue.use(Vuelidate);

document.addEventListener('DOMContentLoaded', () => {
    document.body.appendChild(document.createElement('app'));

    store.dispatch('init');

    const app = new Vue({
        el: 'app',
        router,
        store,
        template: '<App/>',
        render: h => h(App),
        components: {App}
    });
});
