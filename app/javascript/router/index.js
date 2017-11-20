import Vue from 'vue';
import Router from 'vue-router';

import Story from '../components/pages/Story.vue';
import Stories from '../components/pages/Stories.vue';
import Courses from '../components/pages/Courses.vue';

Vue.use(Router);

const router = new Router({
   routes: [{
       path: '/stories/:identifier',
       name: 'story',
       component: Story,
   }, {
       path: '/stories',
       name: 'stories',
       component: Stories,
   }, {
       path: '/courses',
       name: 'courses',
       component: Courses,
   }, {
       path: '*',
       redirect: '/stories'
   }]
});

export default router;