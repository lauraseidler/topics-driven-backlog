import Vue from 'vue';

export default {
    namespaced: true,
    state: {
        initialised: false,
        data: []
    },
    mutations: {
        /**
         * Set one or all stories
         * @param state
         * @param payload
         */
        set: (state, payload) => {
            if (payload.stories) {
                state.data = payload.stories;
            }

            if (payload.story) {
                const isPresent = state.data
                    .filter(story => story.id === payload.story.id).length > 0;

                if (isPresent) {
                    state.data = state.data.map(story =>
                        (story.id === payload.story.id ? payload.story : story),
                    );
                } else {
                    state.data.push(payload.story);
                }
            }
        },
    },
    actions: {
        init({ state, dispatch }) {
            if (!state.initialised) {
                dispatch('fetch');
                state.initialised = true;
            }
        },

        fetch({ commit }) {
            Vue.http.get('stories').then((response) => {
                commit('set', {
                    stories: response.body,
                });
            });
        },

        save({ commit }, payload) {
            return new Promise((resolve, reject) => {
                Vue.http.post('/stories', payload.story).then((response) => {
                    commit('set', {
                        story: response.body,
                    });

                    resolve();
                }, (response) => {
                    reject(response);
                });
            });
        },
    }
}