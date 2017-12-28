import Vue from 'vue';
import Vuex from 'vuex';
import moment from 'moment';

import stories from '@/store/stories';
import courses from '@/store/courses';
import sprints from '@/store/sprints';

Vue.use(Vuex);

export default new Vuex.Store({
    modules: { stories, courses, sprints },
    state: {
        initialised: false,
        currentDate: moment().format('YYYY-MM-DD'),
    },
    actions: {
        /**
         * Initialise store and submodules
         * @param {object} state
         * @param {function} dispatch
         */
        init({ state, dispatch }) {
            dispatch('stories/init');
            dispatch('courses/init');
            state.initialised = true;
        },
    },
});
