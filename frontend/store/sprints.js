import Vue from 'vue';

export default {
    namespaced: true,
    actions: {
        /**
         * Patches a given sprint with the given values
         * @param commit
         * @param payload (id, values)
         * @returns {Promise}
         */
        patch({commit}, payload) {
            return new Promise((resolve, reject) => {
                Vue.http.patch(`/sprints/${payload.id}`, payload.values).then((response) => {
                    commit('courses/set', {
                        sprint: response.body,
                    }, { root: true });

                    resolve(response.body);
                }, reject);
            });
        },

        /**
         * Deletes a given sprint
         * @param commit
         * @param payload (id, course_id)
         * @returns {Promise}
         */
        delete({commit}, payload) {
            return new Promise((resolve, reject) => {
                Vue.http.delete(`/sprints/${payload.id}`).then(() => {
                   commit('courses/removeSprint', payload, { root: true });
                   resolve();
                }, reject);
            });
        }
    },
}