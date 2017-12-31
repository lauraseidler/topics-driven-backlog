// turn off vue console info
console.info = jest.fn();

import { mockResponse, mockResponseBody } from '../util';
import {
    state,
    mutations,
    actions,
    getters,
    mutationTypes,
} from '@/store/courses';

describe('courses store mutations', () => {
    it('sets all courses', () => {
        mutations[mutationTypes.SET_ALL](state, [
            { id: 1, test: 1 },
            { id: 2, test: 2 },
        ]);

        expect(state.data.length).toBe(2);
    });

    it('adds a course if ID doesnt exist yet', () => {
        mutations[mutationTypes.SET_ONE](state, { id: 3, test: 3 });

        expect(state.data.length).toBe(3);
    });

    it('updates a course if ID exists', () => {
        mutations[mutationTypes.SET_ONE](state, { id: 3, test: 4 });

        expect(state.data.length).toBe(3);
        expect(state.data[2].test).toBe(4);
    });

    it('adds a new sprint to a course', () => {
        mutations[mutationTypes.SET_SPRINT](state, {
            id: 1,
            course_id: 1,
            test: 1,
        });

        expect(state.data[0].sprints.length).toBe(1);
        expect(state.data[0].sprints[0].test).toBe(1);
    });

    it('updates an existing sprint in a course', () => {
        mutations[mutationTypes.SET_SPRINT](state, {
            id: 1,
            course_id: 1,
            test: 2,
        });

        expect(state.data[0].sprints.length).toBe(1);
        expect(state.data[0].sprints[0].test).toBe(2);
    });

    it('throws an error when adding a sprint to a non-existent course', () => {
        expect(() => {
            mutations[mutationTypes.SET_SPRINT](state, {
                id: 1,
                course_id: 5,
                test: 2,
            });
        }).toThrow();
    });

    it('removes a sprint from a course', () => {
        mutations[mutationTypes.REMOVE_SPRINT](state, { id: 1, course_id: 1 });

        expect(state.data[0].sprints.length).toBe(0);
    });

    it('throws an error when removing a sprint from a non-existent course', () => {
        expect(() => {
            mutations[mutationTypes.REMOVE_SPRINT](state, {
                sprint: { id: 1, course_id: 5 },
            });
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

    it('initialises the store correctly', async () => {
        await expect(
            actions.init({ state, dispatch }).then(() => {
                expect(state.initialised).toBe(true);
                expect(dispatch).toHaveBeenCalledWith('fetch');
            })
        ).resolves.toBeUndefined();
    });

    it('does not initialise again when already initialised', async () => {
        await expect(
            actions.init({ state, dispatch }).then(() => {
                expect(dispatch).not.toHaveBeenCalledWith('fetch');
            })
        ).resolves.toBeUndefined();
    });

    it('fetches courses and calls set mutation', async () => {
        mock = mockResponse('/courses');

        await expect(actions.fetch({ commit })).resolves.toEqual(
            mockResponseBody
        );

        expect(mock.correctRequest).toBe(true);

        expect(commit).toHaveBeenCalledWith(
            mutationTypes.SET_ALL,
            mockResponseBody
        );
    });

    it('saves course and calls set mutation', async () => {
        const payload = { semester_type: 'W', semester_year: 2017 };

        mock = mockResponse('/courses', 'POST', payload);

        await expect(
            actions.save({ commit }, { course: { semester: 'W*2017' } })
        ).resolves.toEqual(payload);

        expect(mock.correctRequest).toBe(true);
        expect(commit).toHaveBeenCalledWith(mutationTypes.SET_ONE, payload);
    });

    it('patches a course with one given value and calls set mutation', async () => {
        const payload = { test: 1 };
        mock = mockResponse('/courses/1', 'PATCH', payload);

        await expect(
            actions.patch(
                { commit, dispatch },
                { id: 1, field: 'test', value: 1 }
            )
        ).resolves.toEqual(payload);

        expect(mock.correctRequest).toBe(true);
        expect(commit).toHaveBeenCalledWith(mutationTypes.SET_ONE, payload);
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
});
