// turn off vue console info
console.info = jest.fn();

import * as actions from '@/store/base/resource-module/actions';
import actionTypes from '@/store/base/resource-module/action-types';
import mutationTypes from '@/store/base/resource-module/mutation-types';
import { mockResponse } from '../../../util';

describe('The resource module action', () => {
    let fn, state, commit, dispatch, rootState, settings, mock;

    beforeEach(() => {
        state = {};
        commit = jest.fn();
        dispatch = jest.fn();
        rootState = {};

        jest.resetAllMocks();
    });

    describe('init', () => {
        beforeAll(() => {
            settings = {
                resource: 'tests',
            };

            fn = actions.init(settings);
        });

        it('returns a function', () => {
            expect(typeof fn).toBe('function');
        });

        it('dispatches a fetch action', async () => {
            await fn({ state, dispatch, rootState }, {});
            expect(dispatch).toHaveBeenCalledWith(actionTypes.FETCH, {});
        });

        it('does not dispatch the fetch action again when already initialised', () => {
            state = {
                initialised: true,
            };

            fn({ state, dispatch, rootState }, {});
            expect(dispatch).not.toHaveBeenCalled();
        });

        describe('configured with parent setting', () => {
            beforeAll(() => {
                settings = {
                    resource: 'tests',
                    parent: 'tests2',
                };

                fn = actions.init(settings);
            });

            it('throws an error if no parent ID provided', async () => {
                await expect(
                    fn({ state, dispatch, rootState }, {})
                ).rejects.toBe('Incorrect resource module configuration!');
            });

            it('dispatches parent scoped fetch action', async () => {
                state = {
                    initialised: {},
                };

                await fn({ state, dispatch, rootState }, { parentId: 1 });
                expect(dispatch).toHaveBeenCalledWith(`${settings.parent}/${actionTypes.FETCH}`, {}, { root: true });
            });

            it('does not dispatch the fetch action again when already initialised', () => {
                state = {
                    initialised: {
                        1: true,
                    },
                };

                fn({ state, dispatch, rootState }, { parentId: 1 });
                expect(dispatch).not.toHaveBeenCalled();
            });

        });

        describe('configured with children setting', () => {
            beforeAll(() => {
                settings = {
                    resource: 'tests',
                    children: ['tests2'],
                };

                fn = actions.init(settings);
            });

            it('dispatches fetch action when not all children initialised', async () => {
                state = {
                    initialised: true,
                };

                rootState = {
                    tests2: {
                        initialised: {},
                    },
                };

                await fn({ state, dispatch, rootState }, { id: 1 });
                expect(dispatch).toHaveBeenCalledWith(actionTypes.FETCH, { id: 1, parentId: null });
            });

            it('does not dispatch the fetch action again when all children already initialised', async () => {
                state = {
                    initialised: true,
                };

                rootState = {
                    tests2: {
                        initialised: {
                            1: true,
                        },
                    },
                };

                fn({ state, dispatch, rootState }, { id: 1 });
                expect(dispatch).not.toHaveBeenCalled();
            });
        });
    });

    describe('fetch', () => {
        let payload;

        beforeAll(() => {
            settings = {
                resource: 'tests',
            };

            fn = actions.fetch(settings);
        });

        it('fetches resources and commits them', async () => {
            payload = [{ id: 1 }, { id: 2 }];
            mock = mockResponse('/tests', 'GET', null, 200, payload);

            await expect(fn({ commit }, {})).resolves.toEqual(payload);

            expect(mock.correctRequest).toBe(true);
            expect(commit).toHaveBeenCalledWith(mutationTypes.SET_ALL, {
                items: payload,
            });
        });


        it('fetches a resource by ID if given and commits them', async () => {
            payload = { id: 1 };
            mock = mockResponse('/tests/1', 'GET', null, 200, payload);

            await expect(fn({ commit }, { id: 1, parentId: 1 })).resolves.toEqual(payload);

            expect(mock.correctRequest).toBe(true);
            expect(commit).toHaveBeenCalledWith(mutationTypes.SET_ONE, {
                parentId: 1,
                item: payload,
            });
        });

        describe('configured with children setting', () => {
            beforeAll(() => {
                settings = {
                    resource: 'tests',
                    children: ['tests2'],
                };

                fn = actions.fetch(settings);
            });

            it('commits child data separately and removes them from response', async () => {
                payload = [{ id: 1, tests2: [{ id: 3 }] }, { id: 2 }];
                mock = mockResponse('/tests', 'GET', null, 200, payload);

                await expect(fn({ commit }, {})).resolves.toEqual([{ id: 1 }, { id: 2 }]);

                expect(commit).toHaveBeenCalledWith(`${settings.children[0]}/${mutationTypes.SET_ALL}`, {
                    parentId: 1,
                    items: [{ id: 3 }],
                }, { root: true });
            });

            it('commits child data separately and removes them from response when ID is set', async () => {
                payload = { id: 1, tests2: [{ id: 3 }] };
                mock = mockResponse('/tests/1', 'GET', null, 200, payload);

                await expect(fn({ commit }, { id: 1 })).resolves.toEqual({ id: 1 });

                expect(commit).toHaveBeenCalledWith(`${settings.children[0]}/${mutationTypes.SET_ALL}`, {
                    parentId: 1,
                    items: [{ id: 3 }],
                }, { root: true });
            });
        });
    });

    describe('create', () => {
        let payload;

        beforeAll(() => {
            settings = {
                resource: 'tests',
            };

            fn = actions.create(settings);
        });

        it('creates a resource and commits it', async () => {
            payload = { test: 'test' };
            mock = mockResponse('/tests', 'POST', payload);

            await expect(fn({ commit }, payload)).resolves.toBe(payload);

            expect(mock.correctRequest).toBe(true);
            expect(commit).toHaveBeenCalledWith(mutationTypes.SET_ONE, {
                item: {
                    test: 'test',
                },
            });
        });

        describe('configured with parent setting', () => {
            beforeAll(() => {
                settings = {
                    resource: 'tests',
                    parent: 'tests2',
                };

                fn = actions.create(settings);
            });

            it('creates a resource and commits it', async () => {
                payload = { test: 'test' };
                mock = mockResponse(`/${settings.parent}/2/tests`, 'POST', payload);

                await expect(fn({ commit }, {
                    parentId: 2,
                    ...payload,
                })).resolves.toBe(payload);

                expect(mock.correctRequest).toBe(true);
                expect(commit).toHaveBeenCalledWith(mutationTypes.SET_ONE, {
                    parentId: 2,
                    item: payload,
                });
            });
        });
    });

    describe('update', () => {
        let payload;

        beforeAll(() => {
            settings = {
                resource: 'tests',
            };

            fn = actions.update(settings);
        });

        it('updates a resource and commits it', async () => {
            payload = { test: 'test' };
            mock = mockResponse('/tests/1', 'PATCH', payload);

            await expect(fn({ commit }, {
                id: 1,
                ...payload,
            })).resolves.toBe(payload);

            expect(mock.correctRequest).toBe(true);
            expect(commit).toHaveBeenCalledWith(mutationTypes.SET_ONE, {
                item: payload,
            });
        });

        it('updates a resource and commits it with given parent ID', async () => {
            payload = { test: 'test' };
            mock = mockResponse('/tests/1', 'PATCH', payload);

            await expect(fn({ commit }, {
                id: 1,
                parentId: 2,
                ...payload,
            })).resolves.toBe(payload);

            expect(mock.correctRequest).toBe(true);
            expect(commit).toHaveBeenCalledWith(mutationTypes.SET_ONE, {
                parentId: 2,
                item: payload,
            });
        });
    });

    describe('remove', () => {
        beforeAll(() => {
            settings = {
                resource: 'tests',
            };

            fn = actions.remove(settings);
        });

        it('removes a resource and commits it', async () => {
            mock = mockResponse('/tests/1', 'DELETE');

            await fn({ commit }, { id: 1 });

            expect(mock.correctRequest).toBe(true);
            expect(commit).toHaveBeenCalledWith(mutationTypes.REMOVE_ONE, {
                id: 1,
            });
        });

        it('removes a resource and commits it with given parent ID', async () => {
            mock = mockResponse('/tests/1', 'DELETE');

            await fn({ commit }, { id: 1, parentId: 2 });

            expect(mock.correctRequest).toBe(true);
            expect(commit).toHaveBeenCalledWith(mutationTypes.REMOVE_ONE, {
                id: 1,
                parentId: 2,
            });
        });
    });
});