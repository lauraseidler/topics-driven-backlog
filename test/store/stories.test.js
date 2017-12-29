// turn off vue console info
console.info = jest.fn();

import { mockResponse, mockResponseBody } from '../util';
import { state, mutations, actions, getters } from '@/store/stories';

describe('stories.test.js mutations', () => {
    it('sets all stories', () => {
        mutations.set(state, {
            stories: [{ id: 1, test: 1 }, { id: 2, test: 2 }],
        });

        expect(state.data.length).toBe(2);
    });

    it('adds a story if ID doesnt exist yet', () => {
        mutations.set(state, { story: { id: 3, test: 3 } });

        expect(state.data.length).toBe(3);
    });

    it('updates a story if ID exists', () => {
        mutations.set(state, { story: { id: 3, test: 4 } });

        expect(state.data.length).toBe(3);
        expect(state.data[2].test).toBe(4);
    });

    it('removes a story by ID', () => {
        mutations.remove(state, { id: 3 });

        expect(state.data.length).toBe(2);
    });
});

describe('stories.test.js actions', () => {
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

    it('fetches stories and calls set mutation', () => {
        mock = mockResponse('/stories');

        actions.fetch({ commit }).then(() => {
            expect(mock.correctRequest).toBe(true);
            expect(commit).toHaveBeenCalledWith('set', {
                stories: mockResponseBody,
            });
        });
    });

    it('saves story and calls set mutation', () => {
        mock = mockResponse('/stories', 'POST', { test: 1 });

        actions.save({ commit }, { story: { test: 1 } }).then(() => {
            expect(mock.correctRequest).toBe(true);
            expect(commit).toHaveBeenCalledWith('set', {
                story: { test: 1 },
            });
        });
    });

    it('patches a story with one given value and calls set mutation', () => {
        const payload = { test: 1 };
        mock = mockResponse('/stories/1', 'PATCH', payload);

        actions
            .patch({ commit, dispatch }, { id: 1, field: 'test', value: 1 })
            .then(() => {
                expect(mock.correctRequest).toBe(true);
                expect(commit).toHaveBeenCalledWith('set', {
                    story: payload,
                });
            });
    });

    it('patches a story with multiple values', () => {
        const payload = { test: 1, test2: 2 };
        mock = mockResponse('/stories/1', 'PATCH', payload);

        actions
            .patch({ commit, dispatch }, { id: 1, values: payload })
            .then(() => {
                expect(mock.correctRequest).toBe(true);
                expect(commit).toHaveBeenCalledWith('set', {
                    story: payload,
                });
            });
    });

    it('fetches all stories when fetch payload is set', () => {
        mock = mockResponse('/stories/1', 'PATCH');

        actions
            .patch({ commit, dispatch }, { id: 1, values: null, fetch: true })
            .then(() => {
                expect(dispatch).toHaveBeenCalledWith('fetch');
            });
    });

    it('deletes a story and calls remove mutation', () => {
        mock = mockResponse('/stories/1', 'DELETE');

        actions.delete({ commit }, { id: 1 }).then(() => {
            expect(mock.correctRequest).toBe(true);
            expect(commit).toHaveBeenCalledWith('remove', { id: 1 });
        });
    });
});

describe('stories.test.js getters', () => {
    beforeEach(() => {
        state.initialised = false;
        state.data = [
            { id: 1, identifier: 1, field: 1 },
            { id: 2, identifier: 2, field: 2 },
        ];
    });

    it('returns all stories', () => {
        expect(getters.all(state).length).toBe(0);

        state.initialised = true;
        expect(getters.all(state).length).toBe(2);
    });

    it('finds a story by identifier', () => {
        expect(getters.byIdentifier(state)(1)).toBe(null);

        state.initialised = true;
        expect(getters.byIdentifier(state)(1).id).toBe(1);
    });

    it('finds a story by field and value', () => {
        expect(getters.find(state)('field', 2).length).toBe(0);

        state.initialised = true;
        expect(getters.find(state)('field', 2).length).toBe(1);
        expect(getters.find(state)('field', 2)[0].id).toBe(2);
    });
});
