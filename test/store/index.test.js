// turn off vue console info
console.info = jest.fn();

import moment from 'moment';
import Vue from 'vue';
import VueResource from 'vue-resource';
import { state, actions, mutations } from '@/store';
import { mockResponse } from '../util';

Vue.use(VueResource);

describe('index.test.js', () => {
    it('initialises the store and submodules correctly when not logged in', () => {
        const dispatch = jest.fn();
        const commit = jest.fn();

        localStorage.clear();
        actions.init({ state, dispatch, commit });

        expect(state.initialised).toBe(true);
        expect(state.currentDate).toBe(moment().format('YYYY-MM-DD'));
        expect(commit).toHaveBeenCalledWith('logout');
    });

    it('adds to pending changes when calling mutation', () => {
        mutations.newPendingChange(state);
        expect(state.pendingChanges).toBe(1);
    });

    it('subtracts pending changes when calling mutation', () => {
        mutations.resolvePendingChange(state);
        expect(state.pendingChanges).toBe(0);
    });

    it('sets state correctly when logging in', () => {
        mutations.login(state, {
            user: {
                id: 1,
            },
            jwt: {
                token: 'token',
                ttl: moment().add(1, 'hour').unix(),
            },
        });

        expect(state.loggedIn).toBe(true);
        expect(state.user.id).toBe(1);
        expect(state.jwt).toBeTruthy();
    });

    it('logs the user in again on reinit', () => {
        const dispatch = jest.fn();
        const commit = jest.fn();

        actions.init({ state, dispatch, commit });

        expect(commit).toHaveBeenCalled();
    });

    it('dispatches init action after login', async () => {
        const dispatch = jest.fn();
        const commit = jest.fn();

        mockResponse('/get-token', 'POST');
        await actions.login({ commit, dispatch });
        expect(dispatch).toHaveBeenCalledWith('init');
    });
});
