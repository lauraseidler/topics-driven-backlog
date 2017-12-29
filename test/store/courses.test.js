// turn off vue console info
console.info = jest.fn();

import { mockResponse, mockResponseBody } from '../util';
import { state, mutations, actions, getters } from '@/store/courses';

describe('courses.test.js mutations', () => {
    it('sets all courses', () => {
        mutations.set(state, {
            courses: [{ id: 1, test: 1 }, { id: 2, test: 2 }],
        });

        expect(state.data.length).toBe(2);
    });

    it('adds a course if ID doesnt exist yet', () => {
        mutations.set(state, { course: { id: 3, test: 3 } });

        expect(state.data.length).toBe(3);
    });

    it('updates a course if ID exists', () => {
        mutations.set(state, { course: { id: 3, test: 4 } });

        expect(state.data.length).toBe(3);
        expect(state.data[2].test).toBe(4);
    });

    it('adds a new sprint to a course', () => {
        mutations.set(state, { sprint: { id: 1, course_id: 1, test: 1 } });
        mutations.set(state, { sprint: { id: 2, course_id: 1, test: 2 } });

        expect(state.data[0].sprints.length).toBe(2);
        expect(state.data[0].sprints[0].test).toBe(1);
    });

    it('updates an existing sprint in a course', () => {
        mutations.set(state, { sprint: { id: 1, course_id: 1, test: 3 } });

        expect(state.data[0].sprints.length).toBe(2);
        expect(state.data[0].sprints[0].test).toBe(3);
    });

    it('throws an error when adding a sprint to a non-existent course', () => {
        expect(() => {
            mutations.set(state, { sprint: { id: 1, course_id: 5, test: 2 } });
        }).toThrow();
    });

    it('removes a sprint from a course', () => {
        mutations.removeSprint(state, { id: 1, course_id: 1 });

        expect(state.data[0].sprints.length).toBe(1);
    });

    it('throws an error when removing a sprint from a non-existent course', () => {
        expect(() => {
            mutations.removeSprint(state, { sprint: { id: 1, course_id: 5 } });
        }).toThrow();
    });
});

describe('courses.test.js actions', () => {
    let dispatch, commit, mock;

    beforeAll(() => {
        dispatch = jest.fn(() => Promise.resolve());
        commit = jest.fn();
    });

    beforeEach(() => {
        jest.clearAllMocks();
    });

    it('initialises the store correctly', () => {
        actions.init({ state, dispatch }).then(() => {
            expect(state.initialised).toBe(true);
            expect(dispatch).toHaveBeenCalledWith('fetch');
        });
    });

    it('does not initialise again when already initialised', () => {
        actions.init({ state, dispatch }).then(() => {
            expect(dispatch).not.toHaveBeenCalledWith('fetch');
        });
    });

    it('fetches courses and calls set mutation', () => {
        mock = mockResponse('/courses');

        actions.fetch({ commit }).then(() => {
            expect(mock.correctRequest).toBe(true);
            expect(commit).toHaveBeenCalledWith('set', {
                courses: mockResponseBody,
            });
        });
    });

    it('saves course and calls set mutation', () => {
        mock = mockResponse('/courses', 'POST', {
            semester_type: 'W',
            semester_year: 2017,
        });

        actions
            .save({ commit }, { course: { semester: 'W*2017' } })
            .then(() => {
                expect(mock.correctRequest).toBe(true);
                expect(commit).toHaveBeenCalledWith('set', {
                    course: { semester_type: 'W', semester_year: 2017 },
                });
            });
    });

    it('patches a course with one given value and calls set mutation', () => {
        const payload = { test: 1 };
        mock = mockResponse('/courses/1', 'PATCH', payload);

        actions
            .patch({ commit, dispatch }, { id: 1, field: 'test', value: 1 })
            .then(() => {
                expect(mock.correctRequest).toBe(true);
                expect(commit).toHaveBeenCalledWith('set', {
                    course: payload,
                });
            });
    });

    it('adds a sprint and calls set mutation', () => {
        const payload = { test: 1 };
        mock = mockResponse('/courses/1/sprints', 'POST', payload);

        actions.addSprint({ commit }, { id: 1, sprint: payload }).then(() => {
            expect(mock.correctRequest).toBe(true);
            expect(commit).toHaveBeenCalledWith('set', {
                sprint: payload,
            });
        });
    });

    it('adds a sprint collection and fetches data', () => {
        const payload = { test: 1 };
        mock = mockResponse('/courses/1/sprint-collection', 'POST', payload);

        actions
            .addSprintCollection({ dispatch }, { id: 1, collection: payload })
            .then(() => {
                expect(mock.correctRequest).toBe(true);
                expect(dispatch).toHaveBeenCalledWith('fetch');
            });
    });
});

describe('courses.test.js getters', () => {
    beforeEach(() => {
        state.initialised = false;
        state.data = [
            { id: 1, field: 1, sprints: [{ id: 1 }, { id: 2 }] },
            { id: 2, field: 2, sprints: [{ id: 3 }] },
        ];
    });

    it('returns all courses', () => {
        expect(getters.all(state).length).toBe(0);

        state.initialised = true;
        expect(getters.all(state).length).toBe(2);
    });

    it('finds a course by id', () => {
        expect(getters.byId(state)(1)).toBe(null);

        state.initialised = true;
        expect(getters.byId(state)(1).id).toBe(1);
    });

    it('returns a template for a new course', () => {
        expect(getters.new().semester).toBeTruthy();
    });

    it('returns all sprints across all courses', () => {
        expect(getters.allSprints(state)().length).toBe(3);
    });
});
