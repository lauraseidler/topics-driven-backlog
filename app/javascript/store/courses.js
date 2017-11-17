import Vue from 'vue';

import { current } from '../helper/semester';

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
            if (payload.courses) {
                Vue.set(state, 'data', payload.courses);
            }

            if (payload.course) {
                const isPresent = state.data
                    .find(course => course.id === payload.course.id);

                if (isPresent) {
                    Vue.set(state, 'data', state.data.map(course =>
                        (course.id === payload.course.id ? payload.course : course),
                    ));
                } else {
                    state.data.push(payload.course);
                }
            }
        },
    },
    actions: {
        /**
         * Initialises the courses store
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
         * Fetches all courses from the API and updates store
         * @param commit
         * @returns {Promise}
         */
        fetch({commit}) {
            return new Promise((resolve, reject) => {
                Vue.http.get('/courses').then((response) => {
                    commit('set', {
                        courses: response.body,
                    });

                    resolve(response.body);
                }, reject);
            });
        },

        /**
         * Saves a course to the API and updates store
         * @param commit
         * @param payload (course)
         * @returns {Promise}
         */
        save({commit}, payload) {
            return new Promise((resolve, reject) => {
                Vue.http.post('/courses', payload.course).then((response) => {
                    commit('set', {
                        course: response.body,
                    });

                    resolve(response.body);
                }, reject);
            });
        },

        /**
         * Patches a given field of a given course with a given value
         * @param commit
         * @param payload (id, field, value)
         * @returns {Promise}
         */
        patch({commit}, payload) {
            return new Promise((resolve, reject) => {
                const data = {};
                data[payload.field] = payload.value;

                Vue.http.patch(`/courses/${payload.id}`, data).then((response) => {
                    commit('set', {
                        course: response.body,
                    });

                    resolve(response.body);
                }, reject);
            });
        },
    },
    getters: {
        /**
         * All courses
         * @param state
         */
        all: state => state.initialised
            ? state.data.sort((a, b) => a.position > b.position)
            : [],

        /**
         * A template for a new course
         * @returns {{semester: string}}
         */
        new: () => {
            return {
                semester: current().value,
            }
        }
    }
}