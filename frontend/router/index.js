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
            path: '/projects/:id-(.*)/backlog',
            name: 'backlog',
            component: BacklogPage,
        },
        {
            path: '/stories/:identifier',
            name: 'story',
            component: StoryPage,
        },
        // {
        //     path: '/backlog',
        //     name: 'backlog',
        //     component: BacklogPage,
        // },
        {
            path: '/sprint-planning',
            name: 'sprint-planning',
            component: SprintPlanningPage,
        },
        {
            path: '/history',
            name: 'history',
            component: HistoryPage,
        },
        {
            path: '/courses/:id',
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
