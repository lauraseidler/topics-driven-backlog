import Vue from 'vue';
import Router from 'vue-router';

import StoryPage from '../components/pages/StoryPage.vue';
import BacklogPage from '../components/pages/BacklogPage.vue';
import CoursePage from '../components/pages/CoursePage.vue';
import CoursesPage from '../components/pages/CoursesPage.vue';

Vue.use(Router);

const router = new Router({
   routes: [{
       path: '/stories/:identifier',
       name: 'story',
       component: StoryPage,
   }, {
       path: '/backlog',
       name: 'backlog',
       component: BacklogPage,
   },{
       path: '/courses/:id',
       name: 'course',
       component: CoursePage,
   },  {
       path: '/courses',
       name: 'courses',
       component: CoursesPage,
   }, {
       path: '*',
       redirect: '/backlog'
   }]
});

export default router;