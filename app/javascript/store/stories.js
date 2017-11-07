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
                    .find(story => story.id === payload.story.id);

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
        /**
         * Initialises the stories store
         * @param state
         * @param dispatch
         */
        init({state, dispatch}) {
            if (!state.initialised) {
                dispatch('fetch').then(() => {
                    state.initialised = true;
                });
            }
        },

        /**
         * Fetches all stories from the API and updates store
         * @param commit
         * @returns {Promise}
         */
        fetch({commit}) {
            return new Promise((resolve, reject) => {
                Vue.http.get('/stories').then((response) => {
                    commit('set', {
                        stories: response.body,
                    });

                    resolve(response.body);
                }, reject);
            });
        },

        /**
         * Saves a story to the API and updates store
         * @param commit
         * @param payload
         * @returns {Promise}
         */
        save({commit}, payload) {
            return new Promise((resolve, reject) => {
                Vue.http.post('/stories', payload.story).then((response) => {
                    commit('set', {
                        story: response.body,
                    });

                    resolve(response.body);
                }, reject);
            });
        },

        /**
         * Saves order information to a story and triggers a new fetch of stories
         * @param getters
         * @param dispatch
         * @param payload
         * @returns {Promise}
         */
        reorder({getters, dispatch}, payload) {
            const story = getters.all[payload.oldIndex];

            return new Promise((resolve, reject) => {
                if (!story) {
                    return reject();
                }

                Vue.http.patch(`/stories/${story.id}`, {position: payload.newIndex}).then((response) => {
                    dispatch('fetch').then(resolve, reject);
                }, reject);
            });
        }
    },
    getters: {
        /**
         * All stories
         * @param state
         */
        all: state => state.data.sort((a, b) => a.position > b.position),
    }
}