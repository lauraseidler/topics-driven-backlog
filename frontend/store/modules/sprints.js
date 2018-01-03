import { generate } from '@/store/base/resource-module/index';
import resources from '@/store/resources';

import Vue from 'vue';
import actionTypes from '@/store/base/resource-module/action-types';

const resourceModule = generate({
    resource: resources.SPRINTS,
    parent: resources.COURSES,
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

export default resourceModule;
