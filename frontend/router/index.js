import Vue from 'vue';
import Router from 'vue-router';

import StoryPage from '@/components/pages/StoryPage';
import CoursePage from '@/components/pages/CoursePage';
import CoursesPage from '@/components/pages/CoursesPage';
import ProjectsPage from '@/components/pages/ProjectsPage';
import ProjectPage from '@/components/pages/ProjectPage';
import LoginPage from '@/components/pages/LoginPage';
import LogoutPage from '@/components/pages/LogoutPage';

import store from '@/store';

Vue.use(Router);

const router = new Router({
    routes: [
        {
            path: '/projects',
            name: 'projects',
            component: ProjectsPage,
            meta: {
                protected: true,
            },
        },
        {
            path: '/projects/:id-(.*)',
            name: 'project',
            component: ProjectPage,
            meta: {
                protected: true,
            },
        },
        {
            path: '/stories/:identifier',
            name: 'story',
            component: StoryPage,
            meta: {
                protected: true,
            },
        },
        {
            path: '/courses/:id-(.*)',
            name: 'course',
            component: CoursePage,
            meta: {
                protected: true,
            },
        },
        {
            path: '/courses',
            name: 'courses',
            component: CoursesPage,
            meta: {
                protected: true,
            },
        },
        {
            path: '/login',
            name: 'login',
            component: LoginPage,
        },
        {
            path: '/logout',
            name: 'logout',
            component: LogoutPage,
        },
        {
            path: '*',
            redirect: '/projects',
        },
    ],
});

router.beforeEach((to, from, next) => {
    if (store.state.pendingChanges > 0) {
        if (!confirm('You have unsaved changes. Proceed?')) {
            return;
        }

        store.state.pendingChanges = 0;
    }

    if (!to.meta.protected || store.state.loggedIn) {
        return next();
    }

    return next(`/login?redirectTo=${to.path}`);
});

export default router;
