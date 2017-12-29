import Vue from 'vue';

export const actions = {
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

export default {
    namespaced: true,
    actions,
};
