import Vue from 'vue';
import Vuex from 'vuex';

import stories from './stories';
import courses from './courses';
import sprints from './sprints';

Vue.use(Vuex);

export default new Vuex.Store({
    modules: { stories, courses, sprints },
    actions: {
        init({ dispatch }) {
            dispatch('stories/init');
            dispatch('courses/init');
        },
    }
});