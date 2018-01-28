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
    return async function ({ commit }, projectId) {
        const res = await Vue.http.post(`/projects/${projectId}/enrollments`);
        commit(mutationTypes.SET_ONE, { parentId: res.body.course_id, item: res.body });
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
        dispatch(actionTypes.FETCH, { id: projectId, parentId: courseId });
        return res.body;
    };
}();

export default resourceModule;
