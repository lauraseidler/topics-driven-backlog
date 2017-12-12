import Vue from 'vue';
import Vuex from 'vuex';

import stories from './stories';
import courses from './courses';
import sprints from './sprints';
import moment from "moment";

Vue.use(Vuex);

export default new Vuex.Store({
    modules: { stories, courses, sprints },
    state: {
        currentDate: moment().format('YYYY-MM-DD')
    },
    actions: {
        init({ dispatch }) {
            dispatch('stories/init');
            dispatch('courses/init');
        },
    }
});