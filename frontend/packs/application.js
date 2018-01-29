/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

// polyfill for async await etc.
import 'babel-polyfill';

// base vue, http client and validation plugin
import Vue from 'vue';
import VueResource from 'vue-resource';
import Vuelidate from 'vuelidate';
import Notifications from 'vue-notification';
import moment from 'moment';

// our own stuff
import App from '@/components/App';
import router from '@/router';
import store from '@/store';

// custom directives
import '@/directives/confirm';
import '@/directives/sortable';

// custom filters
import '@/filters/displayDate';

// register plugins
Vue.use(VueResource);
Vue.use(Vuelidate);
Vue.use(Notifications);

Vue.http.interceptors.push(function checkLogin(request, next) {
    if (store.state.loggedIn && store.state.jwt && store.state.jwt.ttl < moment().unix()) {
        store.commit('logout');

        router.push('/login?redirectTo=' + router.currentRoute.path);

        next(request.respondWith({
            message: 'Login expired! Please login again!',
        }, {
            status: 401,
        }));

        return;
    }

    /* istanbul ignore next */
    next();
});

// init store and app once dom is loaded
document.addEventListener('DOMContentLoaded', () => {
    store.dispatch('init').then(() => {
        new Vue({
            el: '#app',
            router,
            store,
            components: { App },
            template: '<App/>',
            render: h => h(App),
        });
    });
});
