// turn off vue console info
console.info = jest.fn();

import { mockResponse } from '../util';
import { actions } from '@/store/sprints';

describe('sprints.test.js actions', () => {
    let dispatch, commit, mock;

    beforeAll(() => {
        dispatch = jest.fn(() => Promise.resolve());
        commit = jest.fn();
    });

    beforeEach(() => {
        jest.clearAllMocks();
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
});
