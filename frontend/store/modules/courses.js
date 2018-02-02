import Vue from 'vue';
import { generate } from '@/store/base/resource-module/index';
import resources from '@/store/resources';
import { current } from '@/helper/semester';
import mutationTypes from '@/store/base/resource-module/mutation-types';

const resourceModule = generate({
    resource: resources.COURSES,
    children: [resources.SPRINTS, resources.PROJECTS, resources.TOPICS],
    template: () => {
        return {
            semester: current().valueString,
            allow_enrollment: true,
        };
    },
});

/**
 * Add add instructor action.
 * @returns {function}
 */
resourceModule.actions['addInstructor'] = function () {
    /**
     * Add an instructor to a course
     *
     * @param {object} operations
     * @param {function} operations.commit
     * @param {object} payload
     * @param {int} payload.parentId
     * @param {array} payload.collection
     * @returns {object}
     */
    return async function ({ commit }, { id, email }) {
        const res = await Vue.http.post(`/courses/${id}/instructors`, { email });
        commit(mutationTypes.SET_ONE, { item: res.body });
        return res.body;
    };
}();

/**
 * Add remove instructor action.
 * @returns {function}
 */
resourceModule.actions['removeInstructor'] = function () {
    /**
     * Remove an instructor from a course
     *
     * @param {object} operations
     * @param {function} operations.commit
     * @param {object} payload
     * @param {int} payload.parentId
     * @param {array} payload.collection
     * @returns {object}
     */
    return async function ({ commit }, { id, userId }) {
        const res = await Vue.http.delete(`/courses/${id}/instructor/${userId}`);
        commit(mutationTypes.SET_ONE, { item: res.body });
        return res.body;
    };
}();

export default resourceModule;
