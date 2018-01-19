import { generate } from '@/store/base/resource-module/index';
import resources from '@/store/resources';

import * as _ from 'lodash';
import Vue from 'vue';
import actionTypes from '@/store/base/resource-module/action-types';

const resourceModule = generate({
    resource: resources.SPRINTS,
    parent: resources.COURSES,
    template: () => {
        return {
            topic_ids: [],
        };
    },
});

/**
 * Add create collection action.
 * @returns {function}
 */
resourceModule.actions['createCollection'] = function () {
    /**
     * Create a sprint collection for a course.
     *
     * @param {object} operations
     * @param {function} operations.dispatch
     * @param {object} payload
     * @param {int} payload.parentId
     * @param {array} payload.collection
     * @returns {object}
     */
    return async function ({ dispatch }, { parentId, collection }) {
        try {
            const res = await Vue.http.post(`/courses/${parentId}/sprint-collection`, collection);
            dispatch(`courses/${actionTypes.FETCH}`, { id: parentId }, { root: true });
            return res.body;
        } catch (err) {
            return err;
        }

    };
}();

resourceModule.getters['current'] = function () {
    return function (state, getters, rootState)  {
        return function (courseId) {
            return _.first(
                getters.all(courseId)
                    .filter(s => s.start_date <= rootState.currentDate && s.end_date >= rootState.currentDate)
                    .sort((a, b) => a.start_date.localeCompare(b.start_date)));
        };
    };
}();

resourceModule.getters['next'] = function () {
    return function (state, getters, rootState)  {
        return function (courseId) {
            return _.first(
                getters.all(courseId)
                    .filter(s => s.start_date > rootState.currentDate)
                    .sort((a, b) => a.start_date.localeCompare(b.start_date)));
        };
    };
}();

resourceModule.getters['past'] = function () {
    return function (state, getters, rootState)  {
        return function (courseId) {
            return getters.all(courseId)
                .filter(s => s.end_date < rootState.currentDate)
                .sort((a, b) => a.start_date.localeCompare(b.start_date));
        };
    };
}();

export default resourceModule;
