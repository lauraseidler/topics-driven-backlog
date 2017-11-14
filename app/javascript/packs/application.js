/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

// polyfill for async await etc.
import "babel-polyfill";

// base vue, http client and validation plugin
import Vue from 'vue';
import VueResource from 'vue-resource';
import Vuelidate from 'vuelidate';
import * as Sortable from 'sortablejs/Sortable';

// bootstrap
import BootstrapVue from 'bootstrap-vue';
// bootstrap SCSS is imported in App.Vue
import 'bootstrap-vue/dist/bootstrap-vue.css';

// font awesome
import 'vue-awesome/icons/bars'; // drag & drop icon
import Icon from 'vue-awesome/components/Icon.vue';

// our own stuff
import App from '../components/App.vue';
import RouterBack from '../components/elements/RouterBack.vue';
import router from '../router/index';
import store from '../store/index';

Vue.use(VueResource);
Vue.use(Vuelidate);
Vue.use(BootstrapVue);
Vue.component('icon', Icon);

// custom sortable directive
Vue.directive('sortable', {
    inserted: function (el, binding) {
        new Sortable(el, binding.value || {});
    }
});

// <router-back> component
Vue.component('router-back', RouterBack);

document.addEventListener('DOMContentLoaded', () => {
    store.dispatch('init').then(() => {
        new Vue({
            el: '#app',
            router,
            store,
            template: '<App/>',
            render: h => h(App),
            components: {App}
        });
    });
});
