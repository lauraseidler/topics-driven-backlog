import Vue from 'vue';
import Router from 'vue-router';

import StoryPage from '../components/pages/StoryPage.vue';
import StoriesPage from '../components/pages/StoriesPage.vue';
import CoursePage from '../components/pages/CoursePage.vue';
import CoursesPage from '../components/pages/CoursesPage.vue';

Vue.use(Router);

const router = new Router({
   routes: [{
       path: '/stories/:identifier',
       name: 'story',
       component: StoryPage,
   }, {
       path: '/stories',
       name: 'stories',
       component: StoriesPage,
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
       redirect: '/stories'
   }]
});

export default router;