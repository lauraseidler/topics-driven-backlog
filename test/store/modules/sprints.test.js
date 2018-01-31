// spy on console warnings
jest.spyOn(console, 'info').mockImplementation(text => text);

import sprintsModule from '@/store/modules/sprints';
import { mockResponse } from '../../util';

describe('The sprints module', () => {
    it('returns a correct new template', () => {
        const template = sprintsModule.getters.template()();
        expect(template.topic_ids.length).toBe(0);
    });

    it('sends create collection request and commits the result', async () => {
        const mock = mockResponse('/courses/1/sprint-collection', 'POST');
        const commit = jest.fn();

        await sprintsModule.actions.createCollection({ commit }, { parentId: 1, collection: [] });

        expect(mock.correctRequest).toBe(true);
        expect(commit).toHaveBeenCalled();
    });

    it('sends update collection request and commits the result', async () => {
        const mock = mockResponse('/courses/1/sprint-collection', 'PATCH');
        const commit = jest.fn();

        await sprintsModule.actions.updateCollection({ commit }, { parentId: 1, collection: [] });

        expect(mock.correctRequest).toBe(true);
        expect(commit).toHaveBeenCalled();
    });

    it('calculates correct current, next and past sprints', () => {
        const state = {};

        const getters = {
            all: () => [
                { id: 1, start_date: '2018-01-26', end_date: '2018-01-27' },
                { id: 2, start_date: '2018-01-28', end_date: '2018-01-29' },
                { id: 3, start_date: '2018-01-30', end_date: '2018-01-31' },
                { id: 4, start_date: '2018-02-01', end_date: '2018-02-02' },
            ],
        };

        const rootState = {
            currentDate: '2018-01-30',
        };


        const current = sprintsModule.getters.current(state, getters, rootState)();
        expect(current.id).toBe(3);

        const next = sprintsModule.getters.next(state, getters, rootState)();
        expect(next.id).toBe(4);

        const past = sprintsModule.getters.past(state, getters, rootState)();
        expect(past.length).toBe(2);
    });
});