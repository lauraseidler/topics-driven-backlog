import Vue from 'vue';
import Router from 'vue-router';

import StoryPage from '@/components/pages/StoryPage';
import CoursePage from '@/components/pages/CoursePage';
import CoursesPage from '@/components/pages/CoursesPage';
import ProjectsPage from '@/components/pages/ProjectsPage';
import ProjectPage from '@/components/pages/ProjectPage';

Vue.use(Router);

const router = new Router({
    routes: [
        {
            path: '/projects',
            name: 'projects',
            component: ProjectsPage,
        },
        {
            path: '/courses/:courseId-(.*)/projects/:id-(.*)',
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

export default router;
