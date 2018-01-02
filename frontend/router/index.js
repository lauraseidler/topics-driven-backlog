import Vue from 'vue';
import Router from 'vue-router';

import StoryPage from '@/components/pages/StoryPage';
import BacklogPage from '@/components/pages/BacklogPage';
import CoursePage from '@/components/pages/CoursePage';
import CoursesPage from '@/components/pages/CoursesPage';
import SprintPlanningPage from '@/components/pages/SprintPlanningPage';
import HistoryPage from '@/components/pages/HistoryPage';
import ProjectsPage from '@/components/pages/ProjectsPage';

Vue.use(Router);

const router = new Router({
    routes: [
        {
            path: '/projects',
            name: 'projects',
            component: ProjectsPage,
        },
        {
            path: '/courses/:courseId-(.*)/projects/:id-(.*)/backlog',
            name: 'backlog',
            component: BacklogPage,
        },
        {
            path: '/courses/:courseId-(.*)/projects/:id-(.*)/sprint-planning',
            name: 'sprint-planning',
            component: SprintPlanningPage,
        },
        {
            path: '/courses/:courseId-(.*)/projects/:id-(.*)/history',
            name: 'history',
            component: HistoryPage,
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
