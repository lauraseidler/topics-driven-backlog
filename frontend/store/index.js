import Vue from 'vue';
import Vuex from 'vuex';
import moment from 'moment';

import courses from '@/store/modules/courses';
import projects from '@/store/modules/projects';
import sprints from '@/store/modules/sprints';
import stories from '@/store/modules/stories';

Vue.use(Vuex);

export const state = {
    initialised: false,
    currentDate: moment().format('YYYY-MM-DD'),
};

export const actions = {
    /**
     * Initialise store and submodules
     * @param {object} state
     * @param {function} dispatch
     */
    init({ state, dispatch }) {
        dispatch('courses/init');
        state.initialised = true;
    },
};

export default new Vuex.Store({
    modules: { courses, projects, sprints, stories },
    state,
    actions,
});
