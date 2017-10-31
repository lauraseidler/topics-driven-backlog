import Vue from 'vue';
import Router from 'vue-router';

import Stories from '../components/pages/Stories.vue';

Vue.use(Router);

const router = new Router({
   routes: [{
       path: '/stories',
       name: 'stories',
       component: Stories,
   }, {
       path: '*',
       redirect: '/stories'
   }]
});

export default router;