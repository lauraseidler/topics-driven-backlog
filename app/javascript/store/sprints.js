import Vue from 'vue';

export default {
    namespaced: true,
    actions: {
        /**
         * Patches a given field of a given course with a given value
         * @param commit
         * @param payload (id, field, value)
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
    },
}