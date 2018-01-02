// turn off vue console info
console.info = jest.fn();

import { mockResponse } from '../util';
import { actions, getters } from '@/store/projects';
import { mutationTypes as coursesMutationTypes } from '@/store/courses';

describe('projects.test.js actions', () => {
    let dispatch, commit, mock;

    beforeAll(() => {
        dispatch = jest.fn(() => Promise.resolve());
        commit = jest.fn();
    });

    beforeEach(() => {
        jest.clearAllMocks();
    });

    it('adds a project and calls set mutation', async () => {
        const payload = { test: 1 };
        mock = mockResponse('/courses/1/projects', 'POST', payload);

        await expect(
            actions.save({ commit }, { course_id: 1, project: payload })
        ).resolves.toEqual(payload);

        expect(mock.correctRequest).toBe(true);
        expect(commit).toHaveBeenCalledWith(
            'courses/' + coursesMutationTypes.SET_PROJECT,
            payload,
            { root: true }
        );
    });

    it('patches a project with given values and calls set mutation on course mutation', async () => {
        const payload = { test: 1 };
        mock = mockResponse('/projects/1', 'PATCH', payload);

        await expect(
            actions.patch({ commit, dispatch }, { id: 1, values: payload })
        ).resolves.toEqual(payload);

        expect(mock.correctRequest).toBe(true);
        expect(commit).toHaveBeenCalledWith(
            'courses/' + coursesMutationTypes.SET_PROJECT,
            payload,
            { root: true }
        );
    });

    it('deletes a project and calls remove mutation', async () => {
        mock = mockResponse('/projects/1', 'DELETE');

        await expect(
            actions.delete({ commit }, { id: 1 })
        ).resolves.toBeUndefined();

        expect(mock.correctRequest).toBe(true);
        expect(commit).toHaveBeenCalledWith(
            'courses/' + coursesMutationTypes.REMOVE_PROJECT,
            { id: 1 },
            { root: true }
        );
    });

    it('returns all projects across all courses', () => {
        const rootState = {
            courses: {
                state: {
                    data: [
                        { id: 1, field: 1, projects: [{ id: 1 }, { id: 2 }] },
                        { id: 2, field: 2, projects: [{ id: 3 }] },
                    ],
                },
            },
        };

        expect(getters.allProjects({}, {}, rootState).length).toBe(3);
    });
});
