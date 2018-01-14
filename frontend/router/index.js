import Vue from 'vue';
import Router from 'vue-router';

import StoryPage from '@/components/pages/StoryPage';
import CoursePage from '@/components/pages/CoursePage';
import CoursesPage from '@/components/pages/CoursesPage';
import ProjectsPage from '@/components/pages/ProjectsPage';
import ProjectPage from '@/components/pages/ProjectPage';

import store from '@/store';

Vue.use(Router);

const router = new Router({
    routes: [
        {
            path: '/projects',
            name: 'projects',
            component: ProjectsPage,
        },
        {
            path: '/projects/:id-(.*)',
            name: 'project',
            component: ProjectPage,
        },
        {
            path: '/stories/:identifier',
            name: 'story',
            component: StoryPage,
        },
        {
            path: '/courses/:id-(.*)',
            name: 'course',
            component: CoursePage,
        },
        {
            path: '/courses',
            name: 'courses',
            component: CoursesPage,
        },
        {
            path: '*',
            redirect: '/projects',
        },
    ],
});

router.beforeEach((to, from, next) => {
    if (store.state.pendingChanges > 0) {
        if (confirm('You have unsaved changes. Proceed?')) {
            store.state.pendingChanges = 0;
            next();
        }
    } else {
        next();
    }
});

export default router;
