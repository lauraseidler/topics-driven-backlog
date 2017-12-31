import Vue from 'vue';

import { mutationTypes as coursesMutationTypes } from '@/store/courses';

export const actions = {
    /**
     * Add a sprint to a given course
     * @param {function} commit
     * @param {object} payload (course_id, sprint)
     * @returns {object}
     */
    async save({ commit }, payload) {
        try {
            const response = await Vue.http.post(
                `/courses/${payload.course_id}/sprints`,
                payload.sprint
            );

            commit(coursesMutationTypes.SET_SPRINT, response.body);
            return response.body;
        } catch (err) {
            return err;
        }
    },

    /**
     * Add a sprint collection to a given course
     * @param {function} dispatch
     * @param {object} payload (course_id, collection)
     * @returns {Promise}
     */
    async saveCollection({ dispatch }, payload) {
        try {
            const response = await Vue.http.post(
                `/courses/${payload.course_id}/sprint-collection`,
                payload.collection
            );

            // TODO: once we load courses more differentiated, also update this
            dispatch('courses/fetch', null, { root: true });
            return response.body;
        } catch (err) {
            return err;
        }
    },

    /**
     * Patches a given sprint with the given values
     * @param {function} commit
     * @param {object} payload (id, values)
     * @returns {Promise}
     */
    patch({ commit }, payload) {
        return new Promise((resolve, reject) => {
            Vue.http
                .patch(`/sprints/${payload.id}`, payload.values)
                .then(response => {
                    commit(
                        'courses/set',
                        {
                            sprint: response.body,
                        },
                        { root: true }
                    );

                    resolve(response.body);
                }, reject);
        });
    },

    /**
     * Deletes a given sprint
     * @param {function} commit
     * @param {object} payload (id, course_id)
     * @returns {Promise}
     */
    delete({ commit }, payload) {
        return new Promise((resolve, reject) => {
            Vue.http.delete(`/sprints/${payload.id}`).then(() => {
                commit('courses/removeSprint', payload, { root: true });
                resolve();
            }, reject);
        });
    },
};

export const getters = {
    /**
     * All sprints in all courses
     * @param {object} state
     * @param {object} getters
     * @param {object} rootState
     * @returns {array}
     */
    allSprints: (state, getters, rootState) => {
        let sprints = [];

        rootState.courses.state.data.forEach(course => {
            sprints = sprints.concat(course.sprints);
        });

        return sprints;
    },
};

export default {
    namespaced: true,
    actions,
    getters,
};
