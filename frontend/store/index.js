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
        currentDate: moment().format('YYYY-MM-DD'),
    },
    actions: {
        /**
         * Initialise store and submodules
         * @param {function} dispatch
         */
        init({ dispatch }) {
            dispatch('stories/init');
            dispatch('courses/init');
        },
    },
});
