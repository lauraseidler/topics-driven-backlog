import Vue from 'vue';
import Vuex from 'vuex';

import stories from './stories';
import courses from './courses';

Vue.use(Vuex);

export default new Vuex.Store({
    modules: { stories, courses },
    actions: {
        init({ dispatch }) {
            dispatch('stories/init');
            dispatch('courses/init');
        },
    }
});