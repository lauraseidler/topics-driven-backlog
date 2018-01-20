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
    token: null,
};

export const mutations = {
    newPendingChange(state) {
        state.pendingChanges++;
    },
    resolvePendingChange(state) {
        state.pendingChanges--;
    },
    setUser(state, user) {
        state.user = user;
        localStorage.setItem('user', JSON.stringify(state.user));
    },
    login(state, { user, token }) {
        state.loggedIn = true;
        state.user = user;
        state.token = token;

        localStorage.setItem('user', JSON.stringify(state.user));
        localStorage.setItem('token', state.token);
        Vue.http.headers.common.Authorization = `Bearer ${state.token}`;
    },
    logout(state) {
        state.user = null;
        state.loggedIn = false;
        state.token = null;

        localStorage.removeItem('token');
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
        const token = localStorage.getItem('token') || null;

        // if user and token present, login and initialise rest of app
        // else ensure clean logged out tate
        if (user && token) {
            // switch to logged in state
            commit('login', { user, token });

            // fetch user data
            dispatch('fetchUser');

            // init modules
            dispatch('courses/init', {});
        } else {
            // switch to logged out state
            commit('logout');
        }

        state.initialised = true;
    },

    /**
     * Fetch user data from API and save
     * @param {function}commit
     */
    fetchUser({ commit }) {
        Vue.http.get('user').then((response) => {
            commit('setUser', response.body);
        });
    },

    /**
     * Send login data to API and receive token
     * @param {function} commit
     * @param {object} user
     */
    async login({ commit }, user) {
        const res = await Vue.http.post('/get-token', user);

        commit('login', {
            user: res.body.user,
            token: res.body.token,
        });
    },
};

export default new Vuex.Store({
    modules: { courses, projects, sprints, stories, topics },
    state,
    mutations,
    actions,
});
