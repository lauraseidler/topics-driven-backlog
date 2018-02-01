import Vue from 'vue';
import Router from 'vue-router';

import CoursePage from '@/components/pages/CoursePage';
import CoursesPage from '@/components/pages/CoursesPage';
import ProjectsPage from '@/components/pages/ProjectsPage';
import ProjectPage from '@/components/pages/ProjectPage';
import LoginPage from '@/components/pages/LoginPage';
import LogoutPage from '@/components/pages/LogoutPage';
import PrintPage from '@/components/pages/PrintPage';
import MyProjectsPage from '@/components/pages/MyProjectsPage';
import MyCoursesPage from '@/components/pages/MyCoursesPage';

import store from '@/store';

Vue.use(Router);

const router = new Router({
    routes: [
        {
            path: '/my-projects',
            name: 'my-projects',
            component: MyProjectsPage,
            meta: {
                protected: true,
            },
        },
        {
            path: '/projects',
            name: 'projects',
            component: ProjectsPage,
            meta: {
                protected: true,
            },
        },
        {
            path: '/projects/:id-(.*)/print',
            name: 'print',
            component: PrintPage,
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
            path: '/courses/:id-(.*)',
            name: 'course',
            component: CoursePage,
            meta: {
                protected: true,
            },
        },
        {
            path: '/my-courses',
            name: 'my-courses',
            component: MyCoursesPage,
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
            path: '/',
            name: 'index',
            meta: {
                protected: true,
            },
        },
        {
            path: '*',
            redirect: '/login',
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
        if (to.path === '/' && store.state.loggedIn) {
            if (store.state.user.role === 0) {
                return next('/my-projects');
            } else {
                return next('/my-courses');
            }
        }

        return next();
    }

    return next(`/login?redirectTo=${to.path}`);
});

export default router;
