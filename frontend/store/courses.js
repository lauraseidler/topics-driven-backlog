import Vue from 'vue';

import { current } from '@/helper/semester';

export const state = {
    initialised: false,
    data: [],
};

export const mutationTypes = {
    SET_ALL: 'setAll',
    SET_ONE: 'setOne',
    SET_SPRINT: 'setSprint',
    REMOVE_SPRINT: 'removeSprint',
};

export const mutations = {
    /**
     * Set all courses
     * @param {object} state
     * @param {array} courses
     */
    [mutationTypes.SET_ALL]: (state, courses) => {
        Vue.set(state, 'data', courses);
    },

    /**
     * Set one course. If the course already exists (determined by ID) it will be replaced,
     * otherwise it will be added to the existing courses.
     * @param {object} state
     * @param {object} course
     */
    [mutationTypes.SET_ONE]: (state, course) => {
        const alreadyExists = state.data.find(c => c.id === course.id);

        if (alreadyExists) {
            Vue.set(
                state,
                'data',
                state.data.map(c => (c.id === course.id ? course : c))
            );
        } else {
            state.data.push(course);
        }
    },

    /**
     * Set one sprint in a course identified by the course_id field of the sprint.
     * If the sprint already exists in the course, it will be replaced,
     * otherwise it will be added to the existing sprints in the course.
     * @param {object} state
     * @param {object} sprint
     */
    [mutationTypes.SET_SPRINT]: (state, sprint) => {
        const courseIndex = state.data.findIndex(
            c => c.id === sprint.course_id
        );

        if (courseIndex < 0) {
            throw new Error('Cannot add sprint to non existing course!');
        }

        const course = state.data[courseIndex];

        // ensure we actually have an array to work with
        if (!course.sprints) {
            course.sprints = [];
        }

        const alreadyExists = course.sprints.find(s => s.id === sprint.id);

        if (alreadyExists) {
            course.sprints = course.sprints.map(
                s => (s.id === sprint.id ? sprint : s)
            );
        } else {
            course.sprints.push(sprint);
        }

        Vue.set(state.data, courseIndex, course);
    },

    /**
     * Remove a sprint from a course
     * @param {object} state
     * @param {{course_id: int, id: int}} payload
     */
    [mutationTypes.REMOVE_SPRINT]: (state, payload) => {
        const courseIndex = state.data.findIndex(
            c => c.id === payload.course_id
        );

        if (courseIndex < 0) {
            throw new Error('Cannot remove sprint from non existing course!');
        }

        const course = state.data[courseIndex];
        course.sprints = course.sprints.filter(s => s.id !== payload.id);

        Vue.set(state.data, courseIndex, course);
    },
};

export const actions = {
    /**
     * Initialises the courses store
     * @param {object} state
     * @param {function} dispatch
     */
    async init({ state, dispatch }) {
        if (!state.initialised) {
            await dispatch('fetch');
            state.initialised = true;
        }
    },

    /**
     * Fetches all courses from the API and updates store
     * @param {function} commit
     * @returns {object}
     */
    async fetch({ commit }) {
        try {
            const response = await Vue.http.get('/courses');
            commit(mutationTypes.SET_ALL, response.body);
            return response.body;
        } catch (err) {
            return err;
        }
    },

    /**
     * Saves a course to the API and updates store
     * @param {function} commit
     * @param {object} payload (course)
     * @returns {object}
     */
    async save({ commit }, payload) {
        // clone course object so we can change stuff
        const course = Object.assign({}, payload.course);

        // extract semester year and type from semester info
        const semesterSplit = course.semester.split('*');
        course.semester_type = semesterSplit[0];
        course.semester_year = parseInt(semesterSplit[1], 10);
        delete course.semester;

        try {
            const response = await Vue.http.post('/courses', course);
            commit(mutationTypes.SET_ONE, response.body);
            return response.body;
        } catch (err) {
            return err;
        }
    },

    /**
     * Patches a given field of a given course with a given value
     * @param {function} commit
     * @param {object} payload (id, field, value)
     * @returns {object}
     */
    async patch({ commit }, payload) {
        const data = {};
        data[payload.field] = payload.value;

        try {
            const response = await Vue.http.patch(
                `/courses/${payload.id}`,
                data
            );
            commit(mutationTypes.SET_ONE, response.body);
            return response.body;
        } catch (err) {
            return err;
        }
    },

    /**
     * Add a sprint to a given course
     * @param {function} commit
     * @param {object} payload (id, sprint)
     * @returns {object}
     */
    async addSprint({ commit }, payload) {
        try {
            const response = await Vue.http.post(
                `/courses/${payload.id}/sprints`,
                payload.sprint
            );
            commit(mutationTypes.SET_SPRINT, response.body);
            return response.body;
        } catch (err) {
            return err;
        }
    },

    /**
     * Add a sprint collection to a given course
     * @param {function} dispatch
     * @param {object} payload (id, collection)
     * @returns {Promise}
     */
    async addSprintCollection({ dispatch }, payload) {
        try {
            const response = await Vue.http.post(
                `/courses/${payload.id}/sprint-collection`,
                payload.collection
            );
            
            // TODO: once we load courses more differentiated, also update this
            dispatch('fetch');
            return response.body;
        } catch (err) {
            return err;
        }
    },
};

export const getters = {
    /**
     * All courses
     * @param {object} state
     * @returns {array}
     */
    all: state =>
        state.initialised
            ? state.data.sort((a, b) => a.position > b.position)
            : [],

    /**
     * Find a course by id
     * @param {object} state
     * @returns {object}
     */
    byId: state => id =>
        state.initialised ? state.data.find(c => c.id === id) : null,

    /**
     * A template for a new course
     * @returns {{semester: string}}
     */
    new: () => {
        return {
            semester: current().valueString,
        };
    },

    /**
     * All sprints in all courses
     * @param {object} state
     * @returns {array}
     */
    allSprints: state => () => {
        let sprints = [];

        state.data.forEach(course => {
            sprints = sprints.concat(course.sprints);
        });

        return sprints;
    },
};

export default {
    namespaced: true,
    state,
    mutations,
    actions,
    getters,
};
