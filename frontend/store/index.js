import Vue from 'vue';
import Vuex from 'vuex';
import moment from 'moment';

import courses from '@/store/modules/courses';
import projects from '@/store/modules/projects';
import sprints from '@/store/modules/sprints';
import stories from '@/store/modules/stories';
import topics from '@/store/modules/topics';

Vue.use(Vuex);

export const state = {
    initialised: false,
    currentDate: moment().format('YYYY-MM-DD'),
    pendingChanges: 0,
    loggedIn: false,
    user: null,
    jwt: null,
};

export const mutations = {
    newPendingChange(state) {
        state.pendingChanges++;
    },
    resolvePendingChange(state) {
        state.pendingChanges--;
    },
    login(state, { user, jwt }) {
        state.loggedIn = true;
        state.user = user;
        state.jwt = jwt;

        localStorage.setItem('user', JSON.stringify(state.user));
        localStorage.setItem('jwt', JSON.stringify(state.jwt));
        Vue.http.headers.common.Authorization = `Bearer ${state.jwt.token}`;
    },
    logout(state) {
        state.user = null;
        state.loggedIn = false;
        state.jwt = null;

        localStorage.removeItem('jwt');
        localStorage.removeItem('user');
        delete Vue.http.headers.common.Authorization;
    },
};

export const actions = {
    /**
     * Initialise store and submodules
     * @param {object} state
     * @param {function} commit
     * @param {function} dispatch
     */
    init({ state, commit, dispatch }) {
        const user = localStorage.getItem('user') ? JSON.parse(localStorage.getItem('user')) : null;
        const jwt = localStorage.getItem('jwt') ? JSON.parse(localStorage.getItem('jwt')) : null;

        // if user and token present, login and initialise rest of app
        // else ensure clean logged out tate
        if (user && jwt && jwt.token && jwt.ttl && jwt.ttl > moment().unix()) {
            // switch to logged in state
            commit('login', { user, jwt });

            // init modules
            dispatch('courses/init', {});
        } else {
            // switch to logged out state
            commit('logout');
        }

        state.initialised = true;
    },

    /**
     * Send login data to API and receive token
     * @param {function} commit
     * @param {object} user
     */
    async login({ commit, dispatch }, user) {
        const res = await Vue.http.post('/get-token', user);

        commit('login', {
            user: res.body.user,
            jwt: res.body.auth_token,
        });

        dispatch('init');
    },
};

export default new Vuex.Store({
    modules: { courses, projects, sprints, stories, topics },
    state,
    mutations,
    actions,
});
