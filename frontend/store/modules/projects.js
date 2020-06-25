import { generate } from '@/store/base/resource-module/index';
import resources from '@/store/resources';
import Vue from 'vue';
import mutationTypes from '@/store/base/resource-module/mutation-types';
import actionTypes from '@/store/base/resource-module/action-types';

const resourceModule = generate({
    resource: resources.PROJECTS,
    parent: resources.COURSES,
    children: [resources.STORIES],
    template: () => {
        return {
            title: '',
        };
    },
});

/**
 * Add enroll user action
 * @returns {function}
 */
resourceModule.actions['enroll'] = function () {
    /**
     * Enroll current user to project
     *
     * @param {object} operations
     * @param {function} operations.commit
     * @param {int} projectId
     * @returns {object}
     */
    return async function ({ dispatch }, projectId) {
        const res = await Vue.http.post(`/projects/${projectId}/enrollments`);
        dispatch(`courses/${actionTypes.FETCH}`, { id: res.body.course_id }, { root: true });
        return res.body;
    };
}();

/**
 * Add disenroll user action
 * @returns {function}
 */
resourceModule.actions['disenroll'] = function () {
    /**
     * Disenroll current user from project
     *
     * @param {object} operations
     * @param {function} operations.dispatch
     * @param {int} projectId
     * @returns {object}
     */
    return async function ({ dispatch }, { projectId, courseId }) {
        const res = await Vue.http.delete(`/projects/${projectId}/enrollment`);
        dispatch(`courses/${actionTypes.FETCH}`, { id: courseId }, { root: true });
        return res.body;
    };
}();

/**
 * Add planning complete action
 * @returns {function}
 */
resourceModule.actions['planningComplete'] = function () {
    /**
     * Mark given sprint in given project as planned
     *
     * @param {object} operations
     * @param {function} operations.dispatch
     * @param {int} projectId
     * @returns {object}
     */
    return async function ({ commit }, { projectId, courseId, sprintId }) {
        const res = await Vue.http.patch(`/projects/${projectId}/sprint-planning-complete/${sprintId}`);
        commit(mutationTypes.SET_ONE, { item: res.body, parentId: courseId });
        return res.body;
    };
}();

/**
 * Add planning open action
 * @returns {function}
 */
resourceModule.actions['planningOpen'] = function () {
    /**
     * Mark given sprint in given project as open
     *
     * @param {object} operations
     * @param {function} operations.dispatch
     * @param {int} projectId
     * @returns {object}
     */
    return async function ({ commit }, { projectId, courseId, sprintId }) {
        const res = await Vue.http.patch(`/projects/${projectId}/sprint-planning-open/${sprintId}`);
        commit(mutationTypes.SET_ONE, { item: res.body, parentId: courseId });
        return res.body;
    };
}();

export default resourceModule;
