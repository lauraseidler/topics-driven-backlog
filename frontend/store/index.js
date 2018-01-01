import Vue from 'vue';
import Vuex from 'vuex';
import moment from 'moment';

import stories from '@/store/stories';
import courses from '@/store/courses';
import sprints from '@/store/sprints';
import projects from '@/store/projects';

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
        // dispatch('stories/init');
        dispatch('courses/init');
        state.initialised = true;
    },
};

export default new Vuex.Store({
    modules: { stories, courses, sprints, projects },
    state,
    actions,
});
