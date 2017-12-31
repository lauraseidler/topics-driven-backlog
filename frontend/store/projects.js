import Vue from 'vue';
import { mutationTypes as coursesMutationTypes } from '@/store/courses';

export const state = {};

export const mutationTypes = {};

export const mutations = {};

export const actions = {
    /**
     * Add a project to a given course
     * @param {function} commit
     * @param {object} payload (course_id, project)
     * @returns {object}
     */
    async save({ commit }, payload) {
        try {
            const response = await Vue.http.post(
                `/courses/${payload.course_id}/projects`,
                payload.project
            );

            commit('courses/' + coursesMutationTypes.SET_PROJECT, response.body, { root: true });
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
    async patch({ commit }, payload) {
        try {
            const response = await Vue.http.patch(
                `/projects/${payload.id}`,
                payload.values
            );

            commit('courses/' + coursesMutationTypes.SET_PROJECT, response.body, { root: true });
            return response.body;
        } catch (err) {
            return err;
        }
    },

    /**
     * Deletes a given project
     * @param {function} commit
     * @param {object} payload (id, course_id)
     */
    async delete({ commit }, payload) {
        await Vue.http.delete(`/projects/${payload.id}`);
        commit('courses/' + coursesMutationTypes.REMOVE_PROJECT, payload, { root: true });
    },
};

export const getters = {
    /**
     * All projects in all courses
     * @param {object} state
     * @param {object} getters
     * @param {object} rootState
     * @returns {array}
     */
    allProjects: (state, getters, rootState) => {
        let projects = [];

        rootState.courses.state.data.forEach(course => {
            projects = projects.concat(course.projects);
        });

        return projects;
    },
};

export default {
    namespaced: true,
    state,
    mutations,
    actions,
    getters,
};
