// turn off vue console info
console.info = jest.fn();

import { mockResponse } from '../util';
import { actions, getters } from '@/store/sprints';
import { mutationTypes as coursesMutationTypes } from '@/store/courses';

describe('sprints.test.js actions', () => {
    let dispatch, commit, mock;

    beforeAll(() => {
        dispatch = jest.fn(() => Promise.resolve());
        commit = jest.fn();
    });

    beforeEach(() => {
        jest.clearAllMocks();
    });

    it('adds a sprint and calls set mutation', async () => {
        const payload = { test: 1 };
        mock = mockResponse('/courses/1/sprints', 'POST', payload);

        await expect(
            actions.save({ commit }, { course_id: 1, sprint: payload })
        ).resolves.toEqual(payload);

        expect(mock.correctRequest).toBe(true);
        expect(commit).toHaveBeenCalledWith(coursesMutationTypes.SET_SPRINT, payload);
    });

    it('adds a sprint collection and fetches data', async () => {
        const payload = { test: 1 };
        mock = mockResponse('/courses/1/sprint-collection', 'POST', payload);

        await expect(
            actions.saveCollection(
                { dispatch },
                { course_id: 1, collection: payload }
            )
        ).resolves.toEqual(payload);
        
        expect(mock.correctRequest).toBe(true);
        expect(dispatch).toHaveBeenCalledWith('courses/fetch', null, { root: true });
    });

    it('patches a sprint with given values and calls set mutation on course mutation', () => {
        const payload = { test: 1 };
        mock = mockResponse('/sprints/1', 'PATCH', payload);

        actions
            .patch({ commit, dispatch }, { id: 1, values: payload })
            .then(() => {
                expect(mock.correctRequest).toBe(true);
                expect(commit).toHaveBeenCalledWith(
                    'courses/set',
                    {
                        sprint: payload,
                    },
                    { root: true }
                );
            });
    });

    it('deletes a sprint and calls remove mutation', () => {
        mock = mockResponse('/sprints/1', 'DELETE');

        actions.delete({ commit }, { id: 1 }).then(() => {
            expect(mock.correctRequest).toBe(true);
            expect(commit).toHaveBeenCalledWith(
                'courses/removeSprint',
                { id: 1 },
                { root: true }
            );
        });
    });


    it('returns all sprints across all courses', () => {
        const rootState = {
            courses: {
                state: {
                    data: [
                        { id: 1, field: 1, sprints: [{ id: 1 }, { id: 2 }] },
                        { id: 2, field: 2, sprints: [{ id: 3 }] },
                    ],
                },
            },
        };

        expect(getters.allSprints({}, {}, rootState).length).toBe(3);
    });
});
